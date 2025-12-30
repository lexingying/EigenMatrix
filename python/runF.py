from __future__ import annotations

import numpy as np
from scipy.optimize import minimize

from mt_utils import chebyshev_nodes, normalize_columns, pinv_abs, save_eps, set_matplotlib_headless


def main() -> None:
    set_matplotlib_headless()
    import matplotlib.pyplot as plt

    rng = np.random.default_rng(0)
    FS = 18

    L = 10.0
    nz = 128
    zs = np.sort(rng.random(nz) * 2.0 * L - L)

    def gfn(t: np.ndarray, s: np.ndarray) -> np.ndarray:
        # MATLAB: exp(i*pi*t*transpose(s))
        return np.exp(1j * np.pi * t[:, None] * s[None, :])

    ng = 32
    gs = chebyshev_nodes(ng)
    T = normalize_columns(gfn(zs, gs))
    tol = np.linalg.norm(T, ord="fro") * 1e-4
    M = T @ np.diag(gs) @ pinv_abs(T, tol)
    mt_td_err = np.linalg.norm(M @ T - T @ np.diag(gs)) / np.linalg.norm(M @ T)
    print(f"MT-TD error: {mt_td_err:g}")

    for it in (1, 2):
        if it == 1:
            xs = np.array([-0.9, 0.0, 0.5, 0.9], dtype=float)
        else:
            xs = np.array([-0.9, 0.0, 0.1, 0.9], dtype=float)
        ws = np.ones_like(xs)
        nx = xs.size

        for is_idx, STD in enumerate([1e-2, 1e-3, 1e-4], start=1):
            usext = gfn(zs, xs) @ ws
            us = usext * (1.0 + STD * (rng.standard_normal(nz) + 1j * rng.standard_normal(nz)))

            na = int(np.round(nx * 1.5))
            A = np.zeros((nz, na), dtype=complex)
            A[:, 0] = us
            for g in range(na - 1):
                A[:, g + 1] = M @ A[:, g]

            _, _, Vh = np.linalg.svd(A, full_matrices=False)
            tV = Vh.conj().T[:, :nx]
            Psi = np.linalg.pinv(tV[:-1, :].conj()) @ tV[1:, :].conj()
            rts = np.linalg.eigvals(Psi).real
            bad = np.abs(rts) > 1
            rts[bad] = rts[bad] / np.abs(rts[bad])

            xa = np.sort(rts)
            wa, *_ = np.linalg.lstsq(gfn(zs, xa), us, rcond=None)
            wa = wa.real

            def obj(y: np.ndarray) -> float:
                x = y[:nx]
                w = y[nx:]
                r = gfn(zs, x) @ w - us
                return float(np.sum(np.abs(r) ** 2))

            y0 = np.concatenate([xa, wa])
            res = minimize(obj, y0, method="BFGS", options={"disp": False})
            y = res.x
            xb = y[:nx]
            wb = y[nx:]

            vb = gfn(zs, xb) @ wb
            vs = gfn(zs, xs) @ ws
            relerr = np.linalg.norm(vb - vs) / np.linalg.norm(vs)

            plt.figure()
            plt.stem(xs, ws, linefmt="b-", markerfmt="bo", basefmt=" ")
            plt.stem(xa, wa, linefmt="g-", markerfmt="gs", basefmt=" ")
            plt.stem(xb, wb, linefmt="r-", markerfmt="r^", basefmt=" ")
            plt.title(f"runF it={it} STD={STD:g} relerr={relerr:g}")
            plt.gca().tick_params(labelsize=FS)

            save_eps(f"exF_{it}{is_idx}")
            plt.close()


if __name__ == "__main__":
    main()


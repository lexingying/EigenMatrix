from __future__ import annotations

import numpy as np
from scipy.optimize import minimize

from mt_utils import normalize_columns, pinv_abs, save_eps, set_matplotlib_headless


def main() -> None:
    set_matplotlib_headless()
    import matplotlib.pyplot as plt

    rng = np.random.default_rng(17)
    FS = 18

    # sampling points outside unit disk
    nz = 40
    rs = rng.random(nz) + 1.2
    angles = rng.random(nz) * 2.0 * np.pi
    zs = rs * np.exp(1j * angles)

    def gfn(t: np.ndarray, s: np.ndarray) -> np.ndarray:
        # MATLAB: 1./(t*ones(size(s.'))-ones(size(t))*s.')
        return 1.0 / (t[:, None] - s[None, :])

    # M construction on unit circle nodes
    ng = 32
    gs = np.exp(2j * np.pi * (np.arange(1, ng + 1, dtype=float) - 0.5) / ng)
    T = normalize_columns(gfn(zs, gs))
    tol = np.linalg.norm(T, ord="fro") * 1e-4
    M = T @ np.diag(gs) @ pinv_abs(T, tol)
    mt_td_err = np.linalg.norm(M @ T - T @ np.diag(gs)) / np.linalg.norm(M @ T)
    print(f"MT-TD error: {mt_td_err:g}")

    for it in (1, 2):
        if it == 1:
            xs = 0.9 * np.exp(2j * np.pi * np.array([0.2, 0.5, 0.8, 1.0], dtype=float))
        else:
            xs = 0.9 * np.exp(2j * np.pi * np.array([0.2, 0.75, 0.8, 1.0], dtype=float))
        ws = np.ones(xs.shape, dtype=complex)
        nx = xs.size

        for is_idx, STD in enumerate([1e-2, 1e-3, 1e-4], start=1):
            us = gfn(zs, xs) @ ws
            us = us * (1.0 + STD * (rng.standard_normal(nz) + 1j * rng.standard_normal(nz)))

            na = int(np.round(nx * 1.5))
            A = np.zeros((nz, na), dtype=complex)
            A[:, 0] = us
            for g in range(na - 1):
                A[:, g + 1] = M @ A[:, g]

            _, _, Vh = np.linalg.svd(A, full_matrices=False)
            tV = Vh.conj().T[:, :nx]
            Psi = np.linalg.pinv(tV[:-1, :].conj()) @ tV[1:, :].conj()
            rts = np.linalg.eigvals(Psi)
            bad = np.abs(rts) > 1
            rts[bad] = rts[bad] / np.abs(rts[bad])

            xa = rts
            wa, *_ = np.linalg.lstsq(gfn(zs, xa), us, rcond=None)

            # optimize real/imag parts like the MATLAB code
            def obj(y: np.ndarray) -> float:
                x = y[0:nx] + 1j * y[nx : 2 * nx]
                w = y[2 * nx : 3 * nx] + 1j * y[3 * nx : 4 * nx]
                r = gfn(zs, x) @ w - us
                return float(np.sum(np.abs(r) ** 2))

            y0 = np.concatenate([xa.real, xa.imag, wa.real, wa.imag])
            res = minimize(obj, y0, method="BFGS", options={"disp": False})
            y = res.x
            xb = y[0:nx] + 1j * y[nx : 2 * nx]
            wb = y[2 * nx : 3 * nx] + 1j * y[3 * nx : 4 * nx]

            vb = gfn(zs, xb) @ wb
            vs = gfn(zs, xs) @ ws
            relerr = np.linalg.norm(vb - vs) / np.linalg.norm(vs)

            plt.figure()
            # plot the unit-circle nodes in the complex plane (like MATLAB's plot(z))
            gsc = np.r_[gs, gs[0]]
            plt.plot(gsc.real, gsc.imag, "k-")
            plt.plot(xs.real, xs.imag, "b+")
            plt.plot(xa.real, xa.imag, "g+")
            plt.plot(xb.real, xb.imag, "r+")
            plt.axis("equal")
            plt.title(f"runR it={it} STD={STD:g} relerr={relerr:g}")
            plt.gca().tick_params(labelsize=FS)

            save_eps(f"exR_{it}{is_idx}")
            plt.close()


if __name__ == "__main__":
    main()


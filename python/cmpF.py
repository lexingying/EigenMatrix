from __future__ import annotations

import numpy as np

from mt_utils import normalize_columns, pinv_abs, save_eps, set_matplotlib_headless


def main() -> None:
    set_matplotlib_headless()
    import matplotlib.pyplot as plt

    rng = np.random.default_rng(8)

    nz = 32
    eh = 1.0

    # MATLAB: tmp = [1/2:ng]'/ng - 1/2; gs = exp(2*pi*i*tmp);
    ng = 32
    tmp = (np.arange(1, ng + 1, dtype=float) / ng) - 0.5
    gs = np.exp(2j * np.pi * tmp)

    def gfn(t: np.ndarray, s: np.ndarray) -> np.ndarray:
        # MATLAB: (s.').^t
        return (s[None, :] ** t[:, None]).astype(complex)

    # iterate over three different z samplings
    zs = None
    for it in range(1, 4):
        if it == 1:
            zs = (np.arange(nz, dtype=float) * eh).reshape(-1, 1)
        elif it == 2:
            assert zs is not None
            zs = zs + rng.standard_normal(size=zs.shape) * 0.1
        else:
            zs = np.sort(rng.random((nz, 1)) * nz, axis=0)

        T = normalize_columns(gfn(zs[:, 0], gs))
        D = np.diag(np.exp(2j * np.pi * tmp * eh))
        tol = np.linalg.norm(T, ord="fro") * 1e-2
        M = T @ D @ pinv_abs(T, tol)

        plt.figure()
        plt.imshow(np.abs(M), aspect="equal", interpolation="nearest")
        plt.colorbar()
        plt.axis("tight")
        plt.title(f"cmpF it={it}")

        save_eps(f"cmp_{it}")
        plt.close()


if __name__ == "__main__":
    main()


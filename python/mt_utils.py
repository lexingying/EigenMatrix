"""
Small utilities to mirror MATLAB helpers used in the original .m scripts.

Key behavior we need to match:
- MATLAB `pinv(A, tol)` uses an *absolute* SVD cutoff (singular values <= tol -> 0).
  NumPy's `np.linalg.pinv(..., rcond=...)` uses a *relative* cutoff, so we implement
  the MATLAB-style variant explicitly.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Callable

import numpy as np


Array = np.ndarray


def pinv_abs(A: Array, tol: float) -> Array:
    """
    MATLAB-like pseudoinverse with absolute tolerance.

    Equivalent intent to MATLAB: `pinv(A, tol)`
    - singular values s <= tol are treated as 0 (not inverted)
    """
    U, s, Vh = np.linalg.svd(A, full_matrices=False)
    s_inv = np.zeros_like(s, dtype=A.dtype if np.iscomplexobj(A) else float)
    mask = s > tol
    s_inv[mask] = 1.0 / s[mask]
    # Vh is conjugate-transpose of V for complex SVD
    return (Vh.conj().T * s_inv) @ U.conj().T


def normalize_columns(A: Array) -> Array:
    """Normalize each column to unit 2-norm (like the MATLAB loop)."""
    norms = np.linalg.norm(A, axis=0)
    # avoid divide-by-zero; if a column is exactly zero, leave it as zero
    norms = np.where(norms == 0, 1.0, norms)
    return A / norms


def chebyshev_nodes(ng: int) -> Array:
    """Match `sort(cos(pi*[0:ng]'/ng))`."""
    k = np.arange(ng + 1, dtype=float)
    return np.sort(np.cos(np.pi * k / ng))


def set_matplotlib_headless() -> None:
    """Force a non-interactive backend (safe on CI/headless servers)."""
    import matplotlib

    matplotlib.use("Agg", force=True)


def save_eps(path_no_ext: str) -> None:
    """Save current matplotlib figure as EPS, matching MATLAB `print -depsc`."""
    import matplotlib.pyplot as plt

    plt.savefig(f"{path_no_ext}.eps", format="eps", bbox_inches="tight")


@dataclass(frozen=True)
class RecoverResult:
    xa: Array
    wa: Array
    xb: Array
    wb: Array

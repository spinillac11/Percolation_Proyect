import matplotlib.pyplot as plt
import numpy as np

# Lista de tamaños L
sizes = [16, 32, 64, 128, 256, 512]
colors = ['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b']

# --------- Figura 1: Probabilidad de percolación ---------
fig1, axs1 = plt.subplots(2, 3, figsize=(12, 8), sharex=False, sharey=False)
axs1 = axs1.flatten()

for i, L in enumerate(sizes):
    filename = f"data/perc_prob_{L}.txt"
    data = np.loadtxt(filename)
    p = data[:, 1]
    P = data[:, 2]
    err = data[:, 3]

    ax = axs1[i]
    ax.errorbar(
        p, P, yerr=err,
        fmt='o-', color=colors[i],
        markersize=3, linewidth=1, capsize=2,
        label=f'L={L}'
    )
    ax.set_title(f'L = {L}', fontsize=11)
    ax.set_xlabel('Probabilidad de llenado')
    ax.set_ylabel('P(L, p)')
    ax.grid(True)

fig1.tight_layout()
fig1.savefig("figures/Perc_prob_grid.pdf")

# --------- Figura 2: Tamaño normalizado del cluster más grande ---------
fig2, axs2 = plt.subplots(2, 3, figsize=(12, 8), sharex=False, sharey=False)
axs2 = axs2.flatten()

for i, L in enumerate(sizes):
    filename = f"data/perc_size_{L}.txt"
    data = np.loadtxt(filename)
    p = data[:, 1]
    S = data[:, 2] / (L * L)
    err = data[:, 3] / (L * L)

    ax = axs2[i]
    ax.errorbar(
        p, S, yerr=err,
        fmt='o-', color=colors[i],
        markersize=3, linewidth=1, capsize=2,
        label=f'L={L}'
    )
    ax.set_title(f'L = {L}', fontsize=11)
    ax.set_xlabel('Probabilidad de llenado')
    ax.set_ylabel('S(L, p) normalizado')
    ax.grid(True)

fig2.tight_layout()
fig2.savefig("figures/Size_grid.pdf")


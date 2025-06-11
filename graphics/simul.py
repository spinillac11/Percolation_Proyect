import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap

# Load lattices
data_clusters = np.loadtxt('lattice_clusters.txt', dtype=int)
data_lattice = np.loadtxt('lattice_plain.txt', dtype=int)
labels_lattice = np.unique(data_lattice)
labels_clusters = np.unique(data_clusters)
n_clusters = len(labels_clusters)

colors = []
for name in ('tab20', 'tab20b', 'tab20c'):
    cmap = plt.get_cmap(name)
    colors += list(cmap.colors)
cmap60 = ListedColormap(colors)

# Mapear cada valor de cluster a un índice continuo
label_to_idx_clusters = {label: idx for idx, label in enumerate(labels_clusters)}
label_to_idx_lattice = {label: idx for idx, label in enumerate(labels_lattice)}
mapped_lattice = np.vectorize(label_to_idx_lattice.get)(data_lattice)
mapped_clusters = np.vectorize(label_to_idx_clusters.get)(data_clusters)

# Dibujar
dpi = 300
fig, ax = plt.subplots(figsize=(8, 8), dpi=dpi)
grid = ax.pcolormesh(mapped_clusters, cmap=cmap60, 
                     edgecolors='black', linewidth=0.2,
                     antialiased=False, shading='flat')
ax.set_aspect('equal')
ax.invert_yaxis()

# Escribir IDs si es pequeño...
rows, cols = data_clusters.shape
if rows <= 50:
    for i in range(rows):
        for j in range(cols):
            ax.text(j+0.5, i+0.5, str(data_clusters[i,j]),
                    ha='center', va='center', fontsize=6,
                    color='white')

ax.set_xticks([])
ax.set_yticks([])
plt.tight_layout()
plt.savefig('figures/clusters.pdf', format='pdf')
plt.close()
print("Figura guardada en clusters.pdf")

dpi = 300
fig, ax = plt.subplots(figsize=(8, 8), dpi=dpi)
grid = ax.pcolormesh(mapped_lattice, cmap=cmap60, 
                     edgecolors='black', linewidth=0.2,
                     antialiased=False, shading='flat')
ax.set_aspect('equal')
ax.invert_yaxis()

# Escribir IDs si es pequeño...
rows, cols = data_lattice.shape
if rows <= 50:
    for i in range(rows):
        for j in range(cols):
            ax.text(j+0.5, i+0.5, str(data_lattice[i,j]),
                    ha='center', va='center', fontsize=6,
                    color='white')

ax.set_xticks([])
ax.set_yticks([])
plt.tight_layout()
plt.savefig('figures/lattice.pdf', format='pdf')
plt.close()
print("Figura guardada en lattice.pdf")

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap

# Cargar la matriz de clusters
data = np.loadtxt('lattice.txt', dtype=int)
labels = np.unique(data)
n_clusters = len(labels)

# --- Generar colormap HSV de n_clusters ---
colors = []
for name in ('tab20', 'tab20b', 'tab20c'):
    cmap = plt.get_cmap(name)
    colors += list(cmap.colors)
cmap60 = ListedColormap(colors)

# Mapear cada valor de cluster a un índice continuo
label_to_idx = {label: idx for idx, label in enumerate(labels)}
mapped = np.vectorize(label_to_idx.get)(data)

# Dibujar
dpi = 300
fig, ax = plt.subplots(figsize=(8, 8), dpi=dpi)
grid = ax.pcolormesh(mapped, cmap=cmap60, 
                     edgecolors='black', linewidth=0.2,
                     antialiased=False, shading='flat')
ax.set_aspect('equal')
ax.invert_yaxis()

# Escribir IDs si es pequeño...
rows, cols = data.shape
if rows <= 50:
    for i in range(rows):
        for j in range(cols):
            ax.text(j+0.5, i+0.5, str(data[i,j]),
                    ha='center', va='center', fontsize=6,
                    color='white')

ax.set_xticks([])
ax.set_yticks([])
plt.tight_layout()
plt.savefig('clusters.pdf', format='pdf')
print("Figura guardada en clusters.pdf")

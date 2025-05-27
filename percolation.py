import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap

# Cargar la matriz de clusters
data = np.loadtxt('lattice.txt', dtype=int)

# Obtener etiquetas únicas de clusters
labels = np.unique(data)
n_clusters = len(labels)

# Crear colormap usando la API sin warnings
base_cmap = plt.get_cmap('tab20', n_clusters)
cmap = ListedColormap(base_cmap.colors)

# Mapear cada valor de cluster a un índice continuo
label_to_idx = {label: idx for idx, label in enumerate(labels)}
mapped = np.vectorize(label_to_idx.get)(data)

# Crear la figura de alta resolución
dpi = 300
fig, ax = plt.subplots(figsize=(6, 6), dpi=dpi)

# Dibujar cada celda como parche vectorial para PDF nítido
grid = ax.pcolormesh(mapped, cmap=cmap, edgecolors='black', linewidth=0.2, antialiased=False, shading='flat')
ax.set_aspect('equal')
ax.invert_yaxis()


# Escribir número de cluster en cada celda
rows, cols = data.shape
for i in range(rows):
    for j in range(cols):
        ax.text(j + 0.5, i + 0.5, str(data[i, j]), ha='center', va='center', fontsize=6, color='white')

# Quitar ejes y márgenes
ax.set_xticks([])
ax.set_yticks([])
plt.tight_layout()

# Guardar en PDF vectorial nítido
output_file = 'clusters.pdf'
plt.savefig(output_file, format='pdf')
print(f"Figura guardada en {output_file}")


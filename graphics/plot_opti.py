import numpy as np
import matplotlib.pyplot as plt
import os

# Paths
data_dir = "/home/ertorreso/2025-I-Intro/Proyectos/Percolation_Proyect/data"
figures_dir = "/home/ertorreso/2025-I-Intro/Proyectos/Percolation_Proyect/figures"

# File names and corresponding labels
files = [
    "opti_O0.txt",
    "opti_O1.txt",
    "opti_O2.txt",
    "opti_O3.txt",
    "opti_Ofast.txt"
]

labels = ['-O0', '-O1', '-O2', '-O3', '-Ofast']
colors = ['blue', 'green', 'orange', 'red', 'purple']

plt.figure(figsize=(10, 6))

for file, label, color in zip(files, labels, colors):
    filepath = os.path.join(data_dir, file)
    data = np.loadtxt(filepath)
    x = data[:, 0]
    mean = data[:, 1] / 1000       # Convert to ms
    std = data[:, 2] / 1000        # Convert to ms

    plt.errorbar(x, mean, yerr=std, label=label, fmt='-o', capsize=5, color=color)

plt.xlabel("L (Size)")
plt.ylabel("Execution Time (ms)")
plt.title("Execution Time vs L for Optimization Levels")
plt.legend()
plt.grid(True, which='both', linestyle='--', linewidth=0.5)
plt.tight_layout()

# Make sure figures directory exists
os.makedirs(figures_dir, exist_ok=True)

# Save the plot
output_path = os.path.join(figures_dir, "opti_comparison.pdf")
plt.savefig(output_path)
print(Figura guardada en opti_comparison.pdf)

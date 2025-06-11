import numpy as np
import matplotlib.pyplot as plt


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
    data = np.loadtxt("data/"+file)
    x = data[:, 0]
    mean = data[:, 1] / 1000       # Convert to ms
    std = data[:, 2] / 1000        # Convert to ms

    plt.errorbar(x, mean, yerr=std, label=label, fmt='-o', capsize=5, color=color)

plt.xlabel("L")
plt.ylabel("Tiempo de ejecución (ms)")
plt.title("Tiempo de ejecución vs L por Nivel de optimización")
plt.legend()
plt.grid(True, which='both', linestyle='--', linewidth=0.5)
plt.tight_layout()


plt.savefig("figures/opti_comparison.pdf")
print("Figura guardada en opti_comparison.pdf")

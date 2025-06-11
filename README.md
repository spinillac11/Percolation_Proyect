# Percolation Project

Este proyecto implementa un simulador de percolación por sitios en una red cuadrada \(L \times L\), con identificación de clusters mediante el algoritmo de Hoshen-Kopelman, y análisis de desempeño (optimización, profiling con gprof y perf, flamegraphs). Además incluye scripts en Python para graficar resultados y generación automática de informe en LaTeX.

---

## Tabla de contenidos

- [Requisitos](#requisitos)  
- [Estructura de directorios](#estructura-de-directorios)  
- [Instrucciones de compilación y uso](#instrucciones-de-compilación-y-uso)  
- [Makefile: Targets principales](#makefile-targets-principales)  
- [Archivos fuente](#archivos-fuente)  
- [Testing con Catch2](#testing-con-catch2)  
- [Profiling y optimización](#profiling-y-optimización)  
- [Generación de informe LaTeX](#generación-de-informe-latex)  
- [Limpieza (clean)](#limpieza-clean)  
- [Licencia](#licencia)  

---

## Requisitos

- **Compilador C++** con soporte C++17 (e.g., `g++`)  
- **Make**  
- **Catch2** para tests unitarios  
- **Python 3** con bibliotecas necesarias para scripts de graficado (`matplotlib`, `numpy`, etc.)  
- **LaTeX** (`pdflatex`) para compilar el informe  
- **Herramientas de profiling**: `gprof`, `perf`, `FlameGraph` (stackcollapse-perf.pl, flamegraph.pl), `rsvg-convert` o similar para SVG→PDF  
- Opcional: `valgrind` para análisis de memoria  

---

## Estructura de directorios

```text
.
├── Makefile
├── include/                # Archivos de cabecera (.hpp/.h)
│   └── ... 
├── source/                 # Código fuente en C++
│   ├── main.cpp
│   ├── functions.cpp
│   └── test.cpp
├── build/                  # Archivos objeto (.o) generados
├── figures/                # Figuras generadas (PDF, SVG, etc.)
├── data/                   # Datos de entrada/salida para análisis
├── graphics/               # Scripts Python para graficar (simul.py, plot_opti.py, analysis.py, etc.)
├── script/                 # Scripts bash (e.g., analysis.sh, organize_report_gprof.sh, ...)
├── out/                    # Salida de compilación LaTeX (PDF, aux, log, etc.)
├── out_report/             # Reportes de profiling (gprof, perf) y logs
└── main.tex                # Fuente principal del informe en LaTeX



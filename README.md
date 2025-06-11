# Percolation Project

Este proyecto implementa un simulador de percolación en c++ por sitios en una red cuadrada L^2, con identificación de clusters mediante el algoritmo de Hoshen-Kopelman, y análisis de desempeño (optimización, profiling con gprof y perf, flamegraphs). Además incluye scripts en Python para graficar resultados y generación automática de informe en LaTeX.

---

## Tabla de contenidos

- [Ejecución: Targets principales](#ejecucion-targets-principales)
- [Estructura de directorios](#estructura-de-directorios)    

---

## Ejecución

Ejecutable (program.x): 
  make

Ejecución de la simulación con valores de L y p dados por el usuario:
  make run

Obtención datos y graficas para análisis de percolación: 
  make analysis

Obtención datos y gráfica para análisis de niveles de optimización:
  make optimization

Ejecución con L = 4 Y P = 0.6:
  make simul

Testing (hacer "sapck load catch2" antes de ejecutar):
  make test

Generar TODOS los datos de cero para el articulo y compilarlo:
  make report

Compila el articulo si ya están las gráficas y los reportes de profiling:
  make compile

Compilación con banderas de debugging y ejecución de gdb:
  make debug

Reporte profiling:
 make profile

Valgrind con banderas de debugging con L = 6 y p = 0.6:
  make valgrind

Limpiar
  make clean

---

## Estructura de directorios

```text
.
├── Makefile
├── include/                      # Archivos de cabecera (.hpp/.h)
│   └── include.h                 # Declaración de funciones
├── source/                       # Código fuente en C++
│   ├── main.cpp                    
│   ├── functions.cpp             # Implementación de funciones
│   └── test.cpp                  # Implementación de funciones
├── build/                        # Archivos objeto (.o) generados
├── figures/                      # Figuras generadas (PDF, SVG, etc.)
├── data/                         # Datos de salida para análisis de percolación
├── graphics/                     # Scripts Python para graficar 
│   ├── analysis.py               # Gráficas análisis de percolación              
│   ├── plot_opti.py              # Gráficas análisis de niveles de optimización
│   └── simul.py                  # Graficas de red de clusters 
├── script/                       # Scripts bash 
    ├── analysis.sh               # Datos análisis de percolación   
    ├── optimization.sh           # Datos de niveles de optimización
    ├── organize_report_perf.sh   # Filtrar reporte de perf
    └── organize_report_gprof.sh  # Filtrar reporte de gprof                
├── out/                          # Salida de compilación LaTeX ==> PDF del articulo
├── out_report/                   # Reportes de profiling (gprof, perf)
└── main.tex                      # Fuente principal del informe en LaTeX



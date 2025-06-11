# Compiler and flags
CXX = g++
SANITIZERS = -fsanitize=address,leak,undefined
CXXFLAGS = -std=c++17 -Wall -g -I$(INC) $(SANITIZERS)
CXXFLAGS_GPROF = -g -pg
CXXFLAGS_PERF = -fno-omit-frame-pointer
CXXFLAGS_DEBUG := -std=c++17 -Wall -ggdb
CXXFLAGS_VALGRIND := -std=c++17 -Wall -g

# Latex report
TEX=pdflatex
SRC_TEX=main.tex
OUT=out
OUT_REPORT=out_report
OUT_VALGRIND=out_valgrind

# Proyect directories 
INC = include
SRC = source
GRP = graphics
OBJ = build
FIG = figures
DAT = data
SCP = script

# Executables
EXE = program.x
EXE_GPROF = program_gprof.x
EXE_PERF = program_perf.x
EXE_DEBUG = program_debug.x
EXE_VALGRIND = program_valgrind.x

# Links main.o and functions.o into the final program executable
$(EXE): $(OBJ)/main.o $(OBJ)/functions.o 
	@echo "Linking .o to create $(EXE)"
	$(CXX) $(CXXFLAGS) $(OBJ)/main.o $(OBJ)/functions.o -o $@

# Links test.o and functions.o into a test binary using Catch2
test.x: $(OBJ)/test.o $(OBJ)/functions.o
	@echo "Linking .o to create $@"
	$(CXX) $(CXXFLAGS) $(OBJ)/test.o $(OBJ)/functions.o -o $@ -l Catch2Main -l Catch2

# Compiles the main program source file into an object file
$(OBJ)/main.o: $(SRC)/main.cpp
	@echo "Creating main.o"
	@mkdir -p $(OBJ)
	$(CXX) $(CXXFLAGS) -c $(SRC)/main.cpp -o $@

# Compiles the shared functions file into an object file
$(OBJ)/functions.o: $(SRC)/functions.cpp
	@echo "Creating functions.o"
	@mkdir -p $(OBJ)
	$(CXX) $(CXXFLAGS) -c $(SRC)/functions.cpp -o $@

# Compiles the unit test source file into an object file
$(OBJ)/test.o: $(SRC)/test.cpp 
	@echo "Creating test.o"
	@mkdir -p $(OBJ)
	$(CXX) $(CXXFLAGS) -c $(SRC)/test.cpp -o $@

# Prompts the user for input values and runs the simulation
run: $(EXE)
	@echo
	@read -p "  >> Ingresa el tamaño de la red (por ejemplo, 100): " N; \
	read -p "  >> Ingresa la probabilidad de llenado p (por ejemplo, 0.5927): " P; \
	echo; \
	echo "  Ejecutando $(EXE) con parámetros: N=$$N  p=$$P"; \
	./$(EXE) $$N $$P; \
	echo; \
	echo "  Generando gráfica con simul.py..."; \
	mkdir -p $(FIG)
	python3 $(GRP)/simul.py; \
	echo; \
	echo "  Listo: se creó 'figures/cluster.pdf' y 'figures/lattice.pdf'."

# Executes a shell script and a Python script for analyzing percolation results
analysis: $(EXE)
	@echo "Ejecutando análisis de percolación"	
	mkdir -p $(DAT)
	bash $(SCP)/$@.sh
	python3 $(GRP)/$@.py
	@echo "Gráficas de análisis creadas"

# Compiles and runs the program with different optimization levels
optimization: $(SRC)/main.cpp $(SRC)/functions.cpp
	@echo "Ejecutando comparación de niveles de optimización"
	@mkdir -p $(DAT)
	bash $(SCP)/$@.sh
	python3 graphics/plot_opti.py
	rm -f O0.x O1.x O2.x O3.x Ofast.x

# Runs a small test simulation with fixed values
simul: $(EXE)
	@echo "==> Ejecutando simulación con N=4, p=0.6"
	./$(EXE) 4 0.6
	@echo "==> Generando 'cluster.pdf' desde 'lattice.txt'..."
	@mkdir -p $(FIG)
	python3 graphics/simul.py lattice.txt cluster.pdf
	@echo "==> cluster.pdf y lattice.pdf creados."

# Executes unit tests using the compiled test binary
test: test.x
	./$< 

# Compiles the program without sanitizers for debugging, then launches GDB
debug:
	@echo "Compilando sin sanitizers"
	$(CXX) -I$(INC) $(CXXFLAGS_DEBUG) -o $(EXE_DEBUG) $(SRC)/main.cpp $(SRC)/functions.cpp
	@echo "==> Ejecutando GDB sobre $(EXE_DEBUG)..."
	gdb -ex "file $(EXE_DEBUG)"

# Uses Valgrind to check for memory errors and leaks
valgrind:
	mkdir -p $(OUT_VALGRIND)
	@echo "Compilando sin sanitizers"
	$(CXX) -I$(INC) $(CXXFLAGS_VALGRIND) -o $(EXE_VALGRIND) $(SRC)/main.cpp $(SRC)/functions.cpp
	@echo "==> Ejecutando Valgrind sobre $(EXE_VALGRIND) con N=6 y P=0.6..."
	valgrind --tool=memcheck --leak-check=yes ./$(EXE_VALGRIND) 6 0.6 > $(OUT_VALGRIND)/valgrind_log.txt 2>&1 || true
	@echo "==> Log de Valgrind guardado en 'valgrind_log.txt'."
	rm -f *_valgrind.x

# Runs simulations and builds a LaTeX report
report: simul optimization analysis profile
	mkdir -p $(OUT)
	$(TEX) -output-directory=$(OUT) $(SRC_TEX)
	$(TEX) -output-directory=$(OUT) $(SRC_TEX) # dos pasadas

# Compiles the report without re-running the simulations
compile:
	mkdir -p $(OUT)
	$(TEX) -output-directory=$(OUT) $(SRC_TEX)
	$(TEX) -output-directory=$(OUT) $(SRC_TEX) # dos pasadas

# Uses gprof and perf to generate profiling reports and flamegraphs
# Values used on the profiler simulation
L_PROF = 1000 
P_PROF = 0.6
profile:
	mkdir -p $(OUT_REPORT)
	@echo "Compilando para gprof"
	$(CXX) -I$(INC) $(CXXFLAGS_GPROF) -o $(EXE_GPROF) $(SRC)/main.cpp $(SRC)/functions.cpp
	@echo "Ejecutando programa con gprof"
	echo "Ejecutando programa para L = $(L_PROF), p = $(P_PROF)"
	./$(EXE_GPROF) $(L_PROF) $(P_PROF)  1>/dev/null 
	@echo "Procesando el reporte"
	gprof $(EXE_GPROF) gmon.out > $(OUT_REPORT)/report_gprof.txt
	@echo "Reporte plano generado adecuadamente"
	@echo "Compilando para perf"
	$(CXX) -I$(INC) $(CXXFLAGS_PERF) -o $(EXE_PERF) $(SRC)/main.cpp $(SRC)/functions.cpp
	perf stat ./$(EXE_PERF) $(L_PROF) $(P_PROF) > $(OUT_REPORT)/profile_summary
	@echo "Generando reporte con perf"
	perf record ./$(EXE_PERF) $(L_PROF) $(P_PROF) >/dev/null
	perf report > $(OUT_REPORT)/report_perf.txt
	@echo "Reporte generadi exitosamente"
	@echo "Generando flamegraph"
	perf record --call-graph dwarf  -F 99 -g -- ./$(EXE_PERF) $(L_PROF) $(P_PROF) >/dev/null
	perf script > $(OUT_REPORT)/out.perf
	~/Downloads/FlameGraph/stackcollapse-perf.pl ./$(OUT_REPORT)/out.perf > $(OUT_REPORT)/out.folded
	~/Downloads/FlameGraph/flamegraph.pl $(OUT_REPORT)/out.folded > $(FIG)/flamegraph.svg
	rm -f *.out *.folded *.perf *.data *.old profile_summary *_gprof.x *_perf.x
	@echo "Convertir flamegraph.svg ==> flamegraph.pdf"
	rsvg-convert -f pdf -o $(FIG)/flamegraph.pdf $(FIG)/flamegraph.svg
	@echo "Filtrar reportes *.txt con las funciones implementadas"
	bash $(SCP)/organize_report_gprof.sh
	bash $(SCP)/organize_report_perf.sh 	
	
# Deletes intermediate and output files to keep project tidy
clean:
	@echo "Cleaning /$(OBJ)"
	rm -f $(OBJ)/*.o *.txt *.x
	@echo "Cleaning /$(OUT)"
	rm -rf $(OUT)/*.aux $(OUT)/*.log $(OUT)/*.out $(OUT)/*.pdf 
	@echo "Cleaning /$(DAT)"
	rm -f $(DAT)/*.txt
	@echo "Cleaning /$(FIG)"
	rm -f $(FIG)/*
	@echo "Cleaning /$(OUT_REPORT)"
	rm -r $(OUT_REPORT)/*
	rm -r $(OUT_VALGRIND)/*
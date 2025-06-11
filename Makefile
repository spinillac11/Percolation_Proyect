# Compilator
CXX = g++
INC = include
SANITIZERS = -fsanitize=address,leak,undefined
CXXFLAGS = -std=c++17 -Wall -g -I$(INC) $(SANITIZERS)

# Latex report
TEX=pdflatex
SRC_TEX=main.tex
OUT=out

# Directories
SRC = source
GRP = graphics
OBJ = build
FIG = figures
DAT = data
SCP = script

# executable
EXE = program.x

$(EXE): $(OBJ)/main.o $(OBJ)/functions.o 
	@echo "Linking .o to create $(EXE)"
	$(CXX) $(CXXFLAGS) $(OBJ)/main.o $(OBJ)/functions.o -o $@

test.x: $(OBJ)/test.o $(OBJ)/functions.o
	@echo "Linking .o to create $@"
	$(CXX) $(CXXFLAGS) $(OBJ)/test.o $(OBJ)/functions.o -o $@ -l Catch2Main -l Catch2

$(OBJ)/main.o: $(SRC)/main.cpp
	@echo "Creating main.o"
	@mkdir -p $(OBJ)
	$(CXX) $(CXXFLAGS) -c $(SRC)/main.cpp -o $@


$(OBJ)/functions.o: $(SRC)/functions.cpp
	@echo "Creating functions.o"
	@mkdir -p $(OBJ)
	$(CXX) $(CXXFLAGS) -c $(SRC)/functions.cpp -o $@

$(OBJ)/test.o: $(SRC)/test.cpp 
	@echo "Creating test.o"
	@mkdir -p $(OBJ)
	$(CXX) $(CXXFLAGS) -c $(SRC)/test.cpp -o $@

run: $(EXE)
	@echo
	@read -p "  >> Ingresa el tamaño de la red (por ejemplo, 100): " N; \
	read -p "  >> Ingresa la probabilidad de llenado p (por ejemplo, 0.5927): " P; \
	echo; \
	echo "  Ejecutando $(EXE) con parámetros: N=$$N  p=$$P"; \
	./$(EXE) $$N $$P; \
	echo; \
	echo "  Ahora generando gráfica con simul.py..."; \
	mkdir -p $(FIG)
	python3 $(GRP)/simul.py; \
	echo; \
	echo "  Listo: se creó 'figures/cluster.pdf'."

analysis: $(EXE)
	@echo "Ejecutando análisis de percolación"	
	mkdir -p $(DAT)
	bash $(SCP)/$@.sh
	python3 $(GRP)/$@.py
	@echo "Gráficas de análisis creadas"

optimization: $(SRC)/main.cpp $(SRC)/functions.cpp
	@echo "Ejecutando comparación de niveles de optimización"
	@mkdir -p $(DAT)
	bash $(SCP)/$@.sh
	python3 graphics/plot_opti.py 

simul: $(EXE)
	@echo "==> Ejecutando simulación con N=4, p=0.6"
	./$(EXE) 4 0.6
	@echo "==> Generando 'cluster.pdf' desde 'lattice.txt'..."
	@mkdir -p $(FIG)
	python3 graphics/simul.py lattice.txt cluster.pdf
	@echo "==> Listo: cluster.pdf creado."

test: test.x
	./$< 

debug: CXXFLAGS := -std=c++17 -Wall -ggdb -I$(INC)
debug: clean_obj $(EXE)
	@echo "==> Ejecutando GDB sobre $(EXE)..."
	gdb -ex "file $(EXE)"

# Limpia solo los archivos .o
clean_obj:
	@echo "Limpiando objetos anteriores..."
	rm -f $(OBJ)/*.o


valgrind: CXXFLAGS := -std=c++17 -Wall -g -I$(INC)
valgrind: clean_obj $(EXE)
	@echo "==> Ejecutando Valgrind sobre $(EXE) con N=6 y P=0.6..."
	valgrind --tool=memcheck --leak-check=yes ./$(EXE) 6 0.6 > valgrind_log.txt 2>&1 || true
	@echo "==> Log de Valgrind guardado en 'valgrind_log.txt'."


report:
	make simul
	make optimization
	make analysis
	mkdir -p $(OUT)
	$(TEX) -output-directory=$(OUT) $(SRC_TEX)
	$(TEX) -output-directory=$(OUT) $(SRC_TEX)  # dos pasadas

temporal:
	mkdir -p $(OUT)
	$(TEX) -output-directory=$(OUT) $(SRC_TEX)
	$(TEX) -output-directory=$(OUT) $(SRC_TEX)  # dos pasadas

# values
L_PROF = 1000 
P_PROF = 0.57
profile:
	mkdir -p $(OUT)_report
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
	~/Downloads/FlameGraph/flamegraph.pl $(OUT_REPORT)/out.folded > figures/flamegraph.svg
	rm -f *.out *.folded *.perf *.data *.old profile_summary *_gprof.x *_perf.x
	@echo "Filtrar reportes *.txt con las funciones implementadas"
	bash organize_report_gprof.sh
	bash organize_report_perf.sh 	
	
clean:
	@echo "Cleaning /$(OBJ)"
	rm -f $(OBJ)/*.o *.txt *.x
	@echo "Cleaning /$(OUT)"
	rm -rf $(OUT)/*.aux $(OUT)/*.log $(OUT)/*.out $(OUT)/*.pdf $(FIG)/*.pdf 
	@echo "Cleaning /$(DAT)"
	rm -f $(DAT)/*.txt
	@echo "Cleaning /$(FIG)"
	rm -f $(FIG)/*.pdf
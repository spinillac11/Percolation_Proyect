# Compilator
CXX = g++
INC = include
SANITIZERS = -fsanitize=address,leak,undefined
CXXFLAGS = -std=c++17 -Wall -g -I$(INC) $(SANITIZERS)
CXXFLAGS_PROFILE = -g -pg

# Latex report
TEX=pdflatex
SRC_TEX=main.tex
OUT=out

# Directories
SRC = source
OBJ = build

# executables
EXE = program.x
EXE_GPROF = program_gprof.x

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
	python3 graphics/simul.py lattice.txt cluster.pdf; \
	echo; \
	echo "  Listo: se creó 'lattice.txt' y 'cluster.pdf'."

simul: $(EXE)
	@echo "==> Ejecutando simulación con N=4, p=0.6"
	./$(EXE) 4 0.6
	@echo "==> Generando 'cluster.pdf' desde 'lattice.txt'..."
	python3 graphics/simul.py lattice.txt cluster.pdf
	@echo "==> Listo: cluster.pdf creado."

test: test.x
	./$< 

report:
	mkdir -p $(OUT)
	$(TEX) -output-directory=$(OUT) $(SRC_TEX)
	$(TEX) -output-directory=$(OUT) $(SRC_TEX)  # dos pasadas

profile:
	@echo "Compilando con gprof"
	$(CXX) -I$(INC) $(CXXFLAGS_PROFILE) -o $(EXE_GPROF) $(SRC)/main.cpp $(SRC)/functions.cpp
	@L=100
	@p=0.5
	@echo "Ejecutando programa para L = $(L), p = $(p)"
	./$(EXE_GPROF) 10000 0.5 1>/dev/null
	@echo "Procesando el reporte"
	gprof $(EXE_GPROF) gmon.out > analysis.txt
	@echo "Reporte plano generado adecuadamente"

clean:
	@echo "Cleaning /build"
	rm -f $(OBJ)/*.o *.x *.pdf *.txt
	@echo "Cleaning /$(OUT)"
	rm -rf $(OUT)/*.aux $(OUT)/*.log $(OUT)/*.out $(OUT)/*.pdf
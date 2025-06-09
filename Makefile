# Compilator
CXX = g++
INC = include
SANITIZERS = -fsanitize=address,leak,undefined
CXXFLAGS = -std=c++17 -Wall -g -I$(INC) $(SANITIZERS)


# Directories
SRC = source
OBJ = build
FIG = figures

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
	python3 graphics/simul.py; \
	echo; \
	echo "  Listo: se creó 'figures/cluster.pdf'."

simul: $(EXE)
	@echo "==> Ejecutando simulación con N=4, p=0.6"
	./$(EXE) 4 0.6
	@echo "==> Generando 'cluster.pdf' desde 'lattice.txt'..."
	python3 graphics/simul.py lattice.txt cluster.pdf
	@echo "==> Listo: cluster.pdf creado."

test: test.x
	./$< 

clean:
	@echo "Cleaning /build"
	rm -f $(OBJ)/*.o *.x $(FIG)/*.pdf *.txt
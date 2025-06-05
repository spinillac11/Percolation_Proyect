# Compilator
CXX = g++
INC = include
CXXFLAGS = -std=c++17 -Wall -g -I$(INC)
SANITIZERS = -fsanitize=address,leak,undefined

# Directories
SRC = src
OBJ = build

program.x: $(OBJ)/main.o $(OBJ)/functions.o 
	@echo "Linking .o to create program.x"
	$(CXX) $(CXXFLAGS) $(OBJ)/main.o $(OBJ)/functions.o -o $@


$(OBJ)/main.o: $(SRC)/main.cpp
	@echo "Creating main.o"
	@mkdir -p $(OBJ)
	$(CXX) $(CXXFLAGS) -c $(SRC)/main.cpp -o $@


$(OBJ)/functions.o: $(SRC)/functions.cpp
	@echo "Creating functions.o"
	@mkdir -p $(OBJ)
	$(CXX) $(CXXFLAGS) -c $(SRC)/functions.cpp -o $@


clean:
	@echo "Cleaning /build"
	rm -f $(OBJ)/*.o program.x
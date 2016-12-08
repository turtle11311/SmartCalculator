CC = gcc
CXX = g++
CXXFLAGS += -g -std=c++11 -Wall -Isrc/
LEX = flex
YACC = bison
LDFLAGS += -lfl
VPATH = src:build
BUILDDIR = build
TARGET = SmartCalculator

.PHONY: all clean

all: $(BUILDDIR) $(TARGET)

$(BUILDDIR)/%.o: %.cpp
	$(CXX) $(CXXFLAGS) $< $(LDFLAGS) -c -o $@

$(TARGET): $(BUILDDIR)/calc_scanner.o $(BUILDDIR)/calc_parser.o
	$(CXX) $(CXXFLAGS) $^ $(LDFLAGS) -o $@

$(BUILDDIR)/calc_scanner.cpp: calc_token.l calc_parser.cpp
	$(LEX) -t $< > $@

$(BUILDDIR)/calc_parser.cpp: calc_parser.y
	$(YACC) -d $< -o $@

$(BUILDDIR):
		mkdir $@
clean:
	$(RM) -rf $(BUILDDIR)

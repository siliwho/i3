CC=gcc
CFLAGS=-Wall -Wextra -std=c11
LIBS=-lncurses
TARGET=theme_tui
SRC=themes.c

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC) $(LIBS)
	@echo "Compilation successful! Run with ./${TARGET}"

clean:
	rm -f $(TARGET)


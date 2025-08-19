CC=gcc
CFLAGS=-std=c11 -Wall -O2
TARGET=hello-c
SOURCES=hello.c

# Default target
all: $(TARGET)

# Build the executable
$(TARGET): $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) -o $(TARGET)

# Run the program
run: $(TARGET)
	./$(TARGET)

# Run tests (placeholder - no tests in hello world)
test:
	@echo "No tests configured for hello world"

# Clean build artifacts
clean:
	rm -f $(TARGET) *.o

# Lint code (if clang-tidy available)
lint:
	@if command -v clang-tidy >/dev/null 2>&1; then \
		clang-tidy $(SOURCES) -- $(CFLAGS); \
	else \
		echo "clang-tidy not available"; \
	fi

# Format code (if clang-format available)
format:
	@if command -v clang-format >/dev/null 2>&1; then \
		clang-format -i $(SOURCES); \
	else \
		echo "clang-format not available"; \
	fi

.PHONY: all run test clean lint format

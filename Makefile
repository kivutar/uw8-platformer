all: sprites.zig
	zig build

sprites.zig: $(wildcard *.png)
	for file in $^; do go run png2src.go $$file >> $@; done

clean:
	rm sprites.zig
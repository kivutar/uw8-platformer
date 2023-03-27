all: sprites.zig
	zig build

sprites.zig: $(wildcard assets/*.png)
	for f in $^; do go run png2src.go $$f >> $@; done

clean:
	rm -f sprites.zig
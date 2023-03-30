package main

import (
	"fmt" // register the PNG format with the image package
	"image/color"
	"image/png"
	"os"
	"path/filepath"
)

func indexOf(c color.Color, pal []color.Color) int {
	for k, v := range pal {
		if c == v {
			return k
		}
	}
	return -1
}

func noExt(fileName string) string {
	fileName = filepath.Base(fileName)
	return fileName[:len(fileName)-len(filepath.Ext(fileName))]
}

func main() {
	for _, fname := range os.Args[1:] {
		infile, err := os.Open(fname)
		if err != nil {
			panic(err)
		}
		defer infile.Close()

		src, err := png.Decode(infile)
		if err != nil {
			panic(err)
		}

		model := src.ColorModel()
		pal, ok := model.(color.Palette)
		if !ok {
			panic("no palette")
		}

		fmt.Printf("pub const %s = [256]u8{", noExt(infile.Name()))

		bounds := src.Bounds()
		w, h := bounds.Max.X, bounds.Max.Y
		for y := 0; y < h; y++ {
			for x := 0; x < w; x++ {
				color := src.At(x, y)
				i := indexOf(color, pal)
				fmt.Printf("0x%x,", i)
			}
		}

		fmt.Println("};")
	}
}

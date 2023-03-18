package main

import (
	"fmt" // register the PNG format with the image package
	"image/color"
	"image/png"
	"os"
)

func indexOf(c color.Color, pal []color.Color) int {
	for k, v := range pal {
		if c == v {
			return k
		}
	}
	return -1
}

func main() {
	infile, err := os.Open(os.Args[1])
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

	fmt.Print("{")

	bounds := src.Bounds()
	w, h := bounds.Max.X, bounds.Max.Y
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			color := src.At(x, y)
			i := indexOf(color, pal)
			fmt.Printf("0x%x,", i)
		}
	}

	fmt.Println("}")
}

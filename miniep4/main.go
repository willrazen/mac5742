package main

import (
	"flag"
	"miniep4/fs"
)

func main() {
	var showOffset bool
	flag.BoolVar(&showOffset, "off", false, "Shows offset.")
	flag.Parse()
	if showOffset {
		fs.ShowOffset()
	} else {
		fs.SysInfo()
	}
}

package main

import (
	"flag"
	"miniep4/fs"
)

func main() {
	var info string
	flag.StringVar(&info, "info", "", "Print info. Options: sys, struct")
	flag.Parse()
	switch info {
	case "sys":
		fs.SysInfo()
	case "struct":
		fs.StructInfo()
	}
}

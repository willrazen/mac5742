package fs

import (
	"fmt"
	"golang.org/x/sys/cpu"
	"runtime"
	"unsafe"
)

func SysInfo() {
	fmt.Println("CPU =", runtime.NumCPU(), "threads")
	fmt.Println("GOMAXPROCS =", runtime.GOMAXPROCS(-1), "threads")
	var x *cpu.CacheLinePad
	fmt.Println("CacheLinePad =", unsafe.Sizeof(*x), "bytes")
}

func StructInfo() {
	c := &Counter{}
	fmt.Printf("%d,%d", unsafe.Offsetof(c.v2), unsafe.Sizeof(*c))
}

package fs

import (
	"fmt"
	"golang.org/x/sys/cpu"
	"runtime"
	"unsafe"
)

func Info() {
	fmt.Println("CPU =", runtime.NumCPU(), "threads")
	fmt.Println("GOMAXPROCS =", runtime.GOMAXPROCS(-1), "threads")
	var x *cpu.CacheLinePad
	fmt.Println("CacheLinePad =", unsafe.Sizeof(*x), "bytes")
}

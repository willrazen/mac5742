package main

import (
	"fmt"
	"miniep2/pi"
)

func main() {
	// fmt.Println(pi.Original(2022, 1e7))
	// fmt.Println(pi.Unroll4(2022, 1e7))
	// fmt.Println(pi.Unroll10(2022, 1e7))
	// fmt.Println(pi.Xoroshiro(2022, 1e7))
	// fmt.Println(pi.Splitmix(2022, 1e7))
	fmt.Println(pi.Best(2022, 1e7))
}

package pi

import "github.com/vpxyz/xorshift/splitmix64"

// Estimates pi through monte carlo
func Splitmix(seed int, runs int) float64 {

	rng := splitmix64.NewSource(int64(seed))
	hits := 0

	for i := 0; i < runs; i++ {
		x := float64(rng.Uint64()>>11) / (1 << 53)
		y := float64(rng.Uint64()>>11) / (1 << 53)
		if x*x+y*y <= 1.0 {
			hits++
		}
	}

	return float64(4*hits) / float64(runs)
}

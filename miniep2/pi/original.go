package pi

import "math/rand"

// Estimates pi through monte carlo
func Original(seed int, runs int) float64 {

	rng := rand.New(rand.NewSource(int64(seed)))
	hits := 0

	for i := 0; i < runs; i++ {
		x, y := rng.Float64(), rng.Float64()
		if x*x+y*y <= 1.0 {
			hits++
		}
	}

	return float64(4*hits) / float64(runs)
}

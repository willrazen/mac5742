package pi

import "math/rand"

// Estimates pi through monte carlo
func Unroll4(seed int, runs int) float64 {

	rng := rand.New(rand.NewSource(int64(seed)))
	hits := 0

	var x float64
	var y float64
	for i := 0; i < runs; i += 4 {
		x = rng.Float64()
		y = rng.Float64()
		if x*x+y*y <= 1.0 {
			hits++
		}
		x = rng.Float64()
		y = rng.Float64()
		if x*x+y*y <= 1.0 {
			hits++
		}
		x = rng.Float64()
		y = rng.Float64()
		if x*x+y*y <= 1.0 {
			hits++
		}
		x = rng.Float64()
		y = rng.Float64()
		if x*x+y*y <= 1.0 {
			hits++
		}
	}

	return float64(4*hits) / float64(runs)
}

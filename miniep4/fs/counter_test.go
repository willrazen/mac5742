package fs

import (
	"testing"
)

const threads = 4
const reps = 100000

func BenchmarkCounter(b *testing.B) {
	c := &Counter{}
	b.ResetTimer()
	ParallelInc(*c, threads, reps)
}

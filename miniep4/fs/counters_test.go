package fs

import "testing"

const nThreads = 4
const reps = 100000

func BenchmarkNoPad(b *testing.B) {
	counter := &NotPaddedCounter{}
	b.ResetTimer()
	ParallelInc(counter, nThreads, reps)
}

func BenchmarkPad(b *testing.B) {
	counter := &PaddedCounter{}
	b.ResetTimer()
	ParallelInc(counter, nThreads, reps)
}

package fs

import (
	"sync"
	"sync/atomic"
)

const padBytes = 1

type Counter interface {
	Increment()
}

type NotPaddedCounter struct {
	v1 uint64
	v2 uint64
}

type PaddedCounter struct {
	v1 uint64
	_  [padBytes]byte
	v2 uint64
}

func (c *NotPaddedCounter) Increment() {
	atomic.AddUint64(&c.v1, 1)
	atomic.AddUint64(&c.v2, 1)
}

func (c *PaddedCounter) Increment() {
	atomic.AddUint64(&c.v1, 1)
	atomic.AddUint64(&c.v2, 1)
}

func ParallelInc(c Counter, nThreads int, reps int) {
	wg := sync.WaitGroup{}
	wg.Add(nThreads)
	for threads := 0; threads < nThreads; threads++ {
		go func(i int) {
			for j := 0; j < reps; j++ {
				c.Increment()
			}
			wg.Done()
		}(threads)
	}
	wg.Wait()
}

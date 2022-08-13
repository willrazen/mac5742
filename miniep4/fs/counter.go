package fs

import (
	"sync"
	"sync/atomic"
)

const padding = 137

type Counter struct {
	v1 uint64
	_  [padding]byte
	v2 uint64
}

func (c *Counter) Increment() {
	atomic.AddUint64(&c.v1, 1)
	atomic.AddUint64(&c.v2, 1)
}

func ParallelInc(c Counter, threads int, reps int) {
	wg := sync.WaitGroup{}
	wg.Add(threads)
	for t := 0; t < threads; t++ {
		go func(i int) {
			for j := 0; j < reps; j++ {
				c.Increment()
			}
			wg.Done()
		}(t)
	}
	wg.Wait()
}

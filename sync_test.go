package testing

import (
	"sync"
	"sync/atomic"
	"testing"
)

func BenchmarkMutex(b *testing.B)  {
	var number int
	lock := sync.Mutex{}
	for i:=0; i< b.N;i++{
		go func() {
			defer lock.Unlock()
			lock.Lock()
			number++
		}()
	}
}

func BenchmarkAtomic(b *testing.B)  {
	var number int32
	for i:=0; i< b.N;i++{
		go func() {
			atomic.AddInt32(&number, 1)
		}()
	}
}


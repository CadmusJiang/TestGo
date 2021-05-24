package testing

import (
	"testing"
)

const (
	smallWindowSize = 2350000
	smallMsgCount   = 2350000
	smallMsgSize    = 10000
	bigWindowSize   = 235
	bigMsgCount     = 235
	bigMsgSize      = 100000000
)

type (
	message     []byte
	smallBuffer [smallWindowSize]message
	bigBuffer   [bigWindowSize]message
)

func generateMessage(n int, size int) message {
	m := make(message, size)
	for i := range m {
		m[i] = byte(n)
	}
	return m
}

func pushSmallMsg(b *smallBuffer, highID int) {
	m := generateMessage(highID, smallMsgSize)
	(*b)[highID%smallWindowSize] = m
}

func pushBigMsg(b *bigBuffer, highID int) {
	m := generateMessage(highID, bigMsgSize)
	(*b)[highID%bigWindowSize] = m
}

func BenchmarkSmallMemoryGC(b *testing.B) {
	var buf smallBuffer
	for i := 0; i < smallMsgCount; i++ {
		pushSmallMsg(&buf, i)
	}
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		pushSmallMsg(&buf, i)
	}
}

func BenchmarkBigMemoryGC(b *testing.B) {
	var buf bigBuffer
	for i := 0; i < bigMsgCount; i++ {
		pushBigMsg(&buf, i)
	}
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		pushBigMsg(&buf, i)
	}
}

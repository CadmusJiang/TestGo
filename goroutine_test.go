package testing

import (
	"math/rand"
	"testing"
	"time"
)

func merge(x, y, out []int) {
	n, m := len(x), len(y)
	for i, j, k := 0, 0, 0; k < n+m; k++ {
		if i < n && j < m {
			if x[i] < y[j] {
				out[k] = x[i]
				i++
			} else {
				out[k] = y[j]
				j++
			}
		} else {
			if i < n {
				out[k] = x[i]
				i++
			} else {
				out[k] = y[j]
				j++
			}
		}
	}
}
func min(x, y int) int {
	if x < y {
		return x
	}
	return y
}
func mergesortT(arr, buff []int) {
	n := len(arr)
	x, y := arr, buff
	i, j, k := 0, 0, 0
	for i = 1; i < n; i <<= 1 {
		for j = 0; j < n-i; j = k {
			k = min(n, j+2*i)
			merge(x[j:j+i], x[j+i:k], y[j:k])
		}
		x, y = y, x
	}
	if &x[0] != &arr[0] {
		copy(arr, x)
	}
}
func mergesort(arr, buff []int, sed chan int, level int) {
	n := len(arr)
	if n <= 2 || level <= 1 {
		mergesortT(arr, buff)
		if sed != nil {
			sed <- 0
		}
		return
	}
	recv := make(chan int)
	mid := n >> 1
	go mergesort(arr[:mid], buff[0:mid], recv, level>>1)
	mergesort(arr[mid:], buff[mid:], nil, level>>1)
	<-recv
	merge(arr[:mid], arr[mid:], buff)
	copy(arr, buff)
	if sed != nil {
		sed <- 0
	}
}

func MergeSort(arr []int, t int) {
	buff := make([]int, len(arr))
	mergesort(arr, buff, nil, t)
}

func Shuffle(slice []int) {
	r := rand.New(rand.NewSource(time.Now().Unix()))
	for len(slice) > 0 {
		n := len(slice)
		randIndex := r.Intn(n)
		slice[n-1], slice[randIndex] = slice[randIndex], slice[n-1]
		slice = slice[:n-1]
	}
}

func BenchmarkGoroutineMergeSort(b *testing.B){
	// 归并排序有点问题影响不大
	var slice []int
	for i:=0;i<100000;i++{
		slice=append(slice,i)
	}
	Shuffle(slice)
	b.ResetTimer()
	for i:=0;i<b.N;i++{
		MergeSort(slice,8)
	}
}
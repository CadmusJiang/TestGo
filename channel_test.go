package testing

import (
	"testing"
)

func BenchmarkSendBlockChannel(b *testing.B){
	data := make(chan int)

	go func() {
		for  _= range data {//通过range不断地处理data
		}
	}()
	b.ResetTimer()
	for i:=0;i<b.N;i++{
		data <- i
	}
	close(data)
}

func BenchmarkGetBlockChannel(b *testing.B){
	data := make(chan int)

	go func() {
		for i:=0;i<1000000000;i++{
			data<-i
		}
	}()
	b.ResetTimer()
	for i:=0;i<b.N;i++{
		_, _ = <-data
	}
}

func BenchmarkSendNonBlockChannel(b *testing.B){
	data := make(chan int,10000)

	go func() {
		for  _= range data {//通过range不断地处理data
		}
	}()
	b.ResetTimer()
	for i:=0;i<b.N;i++{
		data <- i
	}
	close(data)
}

func BenchmarkGetNonBlockChannel(b *testing.B){
	data := make(chan int,10000)

	go func() {
		for i:=0;i<1000000000;i++{
			data<-i
		}
	}()
	b.ResetTimer()
	for i:=0;i<b.N;i++{
		_, _ = <-data
	}
}



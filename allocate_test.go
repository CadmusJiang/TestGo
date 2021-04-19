package testing

import "testing"

var smallSize = 100
var bigSize = 1000000
func BenchmarkMakeSmallSlice(b *testing.B){
	for i:=0;i<b.N;i++{
		_ = make([]byte, smallSize)
	}
}

func BenchmarkMakeSmallMap(b *testing.B){
	for i:=0;i<b.N;i++{
		_ = make(map[int]bool, smallSize)
	}
}

func BenchmarkMakeSmallChannel(b *testing.B){
	for i:=0;i<b.N;i++{
		_ = make(chan int, smallSize)
	}
}

func BenchmarkMakeBigSlice(b *testing.B){
	for i:=0;i<b.N;i++{
		_ = make([]byte, bigSize)
	}
}

func BenchmarkMakeBigMap(b *testing.B){
	for i:=0;i<b.N;i++{
		_ = make(map[int]bool, bigSize)
	}
}

func BenchmarkMakeBigChannel(b *testing.B){
	for i:=0;i<b.N;i++{
		_ = make(chan int, bigSize)
	}
}

type SmallTiDB struct{
	Tidb string
	Tikv string
	Pd string
}

type BigTiDB struct{
	Tidbs [100000]string
	Tikv [100000]string
	Pd [100000]string
}


func BenchmarkNewSmallObject(b *testing.B){
	for i:=0;i<b.N;i++{
		_ = new(SmallTiDB)
	}
}

func BenchmarkNewBigObject(b *testing.B){
	for i:=0;i<b.N;i++{
		_ = new(BigTiDB)
	}
}
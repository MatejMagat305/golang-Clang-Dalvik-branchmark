package main

import (
	"fmt"
	"math/rand"
	"runtime"
	"time"
)

const N = 2048

var (
	a = [N][N]float64{}
	b = [N][N]float64{}
	c = [N][N]float64{}
)

func main() {
	rand.Seed(time.Now().UnixNano())
	for i := 0; i < N; i++ {
		for j := 0; j < N; j++ {
			a[i][j] = rand.Float64()
			b[i][j] = rand.Float64()
		}
	}
	numUseCpu := 6
	ch := make(chan struct{})
	for i := 0; i < numUseCpu; i++ {
		go func() { ch <- struct{}{} }()
	}
	runtime.GOMAXPROCS(numUseCpu)
	start := time.Now()
	for i := 0; i < N; i++ {
		<-ch
		go func(ii int) {
			for j := 0; j < N; j++ {
				for k := 0; k < N; k++ {
					c[ii][j] += a[ii][k] * b[k][j]
				}
			}
			ch <- struct{}{}
		}(i)
	}
	for i := 0; i < numUseCpu; i++ {
		<-ch
	}
	elapsed := time.Since(start)
	fmt.Println("time: ", elapsed)
}

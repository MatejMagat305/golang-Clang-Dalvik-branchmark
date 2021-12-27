package main

import (
	"fmt"
	"math/rand"
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
	start := time.Now()
	for i := 0; i < N; i++ {
		for j := 0; j < N; j++ {
			for k := 0; k < N; k++ {
				c[i][j] += a[i][k] * b[k][j]
			}
		}
	}
	elapsed := time.Since(start)
	fmt.Println("time: ", elapsed)
}

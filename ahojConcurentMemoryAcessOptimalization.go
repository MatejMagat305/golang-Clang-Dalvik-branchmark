package main

import (
    "fmt"
    "math/rand"
    "runtime"
    "sync"
    "time"
)

const (
    N         = 2048
    BLOCKSIZE = 64
)

var (
    a = [N][N + 1]int64{}
    b = [N][N + 1]int64{}
    c = [N][N + 1]int64{}
)

// Funkcia na násobenie blokov
func multiplyBlock(bi, bj, bk int, wg *sync.WaitGroup) {
    defer wg.Done()
    for i := bi; i < bi+BLOCKSIZE && i < N; i++ {
        for j := bj; j < bj+BLOCKSIZE && j < N; j++ {
            var sum int64
            for k := bk; k < bk+BLOCKSIZE && k < N; k++ {
                sum += a[i][k] * b[k][j]
            }
            c[i][j] += sum
        }
    }
}

func main() {
    rand.Seed(time.Now().UnixNano())

    // Inicializácia matíc náhodnými hodnotami (0 až 100)
    for i := 0; i < N; i++ {
        for j := 0; j < N; j++ {
            a[i][j] = int64(rand.Intn(100))
            b[i][j] = int64(rand.Intn(100))
            c[i][j] = 0 // Inicializácia výsledkovej matice
        }
    }

    // Nastavenie počtu CPU
    numCPUs := runtime.NumCPU()
    runtime.GOMAXPROCS(numCPUs)
    fmt.Printf("Using %d CPUs\n", numCPUs)

    var wg sync.WaitGroup

    start := time.Now()

    // Paralelizácia pomocou blokov
    for bi := 0; bi < N; bi += BLOCKSIZE {
        for bj := 0; bj < N; bj += BLOCKSIZE {
            for bk := 0; bk < N; bk += BLOCKSIZE {
                wg.Add(1)
                go multiplyBlock(bi, bj, bk, &wg) // Paralelné spracovanie blokov
            }
        }
    }

    // Čakanie na dokončenie všetkých gorutín
    wg.Wait()

    elapsed := time.Since(start)
    fmt.Printf("Elapsed time: %s\n", elapsed)

    // Výpis prvého prvku výsledkovej matice c pre kontrolu
    fmt.Printf("First element in result matrix C: %d\n", c[0][0])
}

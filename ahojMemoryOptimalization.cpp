#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <omp.h>

#define n 2048
#define BLOCK_SIZE 64

double A[n][n + 1] __attribute__((aligned(64)));
double B[n][n + 1] __attribute__((aligned(64)));
double C[n][n + 1] __attribute__((aligned(64)));

// Funkcia na násobenie blokov
void matmul_block(int bi, int bj, int bk) {
    for (int i = bi; i < bi + BLOCK_SIZE; i++) {
        for (int j = bj; j < bj + BLOCK_SIZE; j++) {
            double sum = 0;
            for (int k = bk; k < bk + BLOCK_SIZE; k++) {
                sum += A[i][k] * B[k][j];
            }
            C[i][j] += sum;
        }
    }
}

int main() {
    // Inicializácia matíc náhodnými hodnotami
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            A[i][j] = (double)rand() / (double)RAND_MAX;
            B[i][j] = (double)rand() / (double)RAND_MAX;
            C[i][j] = 0;
        }
    }

    struct timespec start, end;
    double time_spent;

    // Násobenie matíc s paralelným blokovaním
    clock_gettime(CLOCK_REALTIME, &start);
    printf("Using %d threads\n", omp_get_max_threads()); 
    // Paralelizácia pomocou OpenMP
    #pragma omp parallel for collapse(2)
    for (int bi = 0; bi < n; bi += BLOCK_SIZE) {
        for (int bj = 0; bj < n; bj += BLOCK_SIZE) {
            for (int bk = 0; bk < n; bk += BLOCK_SIZE) {
                matmul_block(bi, bj, bk);
            }
        }
    }
    
    clock_gettime(CLOCK_REALTIME, &end);
    time_spent = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1000000000.0;
    printf("Elapsed time in seconds: %f \n", time_spent);
    return 0;
}

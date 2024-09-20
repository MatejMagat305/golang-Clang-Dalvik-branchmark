#!/bin/bash

# Preloženie programu pre rôzne jadrá
echo "Kompilujem binárky..."
g++ -O3 -march=armv9-a -mcpu=cortex-a510 -mtune=cortex-a510 ahojMemoryAcess.cpp -o matrix_A510
g++ -O3 -march=armv9-a -mcpu=cortex-a710 -mtune=cortex-a710 ahojMemoryAcess.cpp -o matrix_A710
g++ -O3 -march=armv9-a -mcpu=cortex-x2 -mtune=cortex-x2 ahojMemoryAcess.cpp -o matrix_X2
g++ -O3 ahojMemoryAcess.cpp -o matrix_O3
g++ -O3 -march=armv8 ahojMemoryAcess.cpp -o matrix_O3armv8
g++ -O3 -march=armv9 ahojMemoryAcess.cpp -o matrix_O3armv9
g++ -O3 -march=native ahojMemoryAcess.cpp -o matrix_native  # Pridanie kompilácie s -march=native

# Definícia asociatívneho poľa (slovníka) s binárkami
declare -A binaries
binaries=(
    [0]="matrix_A510"
    [4]="matrix_A710"
    [7]="matrix_X2"
)
number=5

# Funkcia na meranie výkonu pre všetky binárky naraz v jednom cykle
measure_all_in_cycle() {
    core=$1
    total_bin=0
    total_O3=0
    total_O3armv8=0
    total_O3armv9=0
    total_native=0
    for ((i=1; i<=number; i++)); do
        echo "Opakovanie $i na jadre $core:"

        # Meranie pre binaries[$core]
        start_bin=$(date +%s.%N)
        taskset -c $core ./${binaries[$core]}
        end_bin=$(date +%s.%N)
        elapsed_bin=$(echo "$end_bin - $start_bin" | bc)
        total_bin=$(echo "$total_bin + $elapsed_bin" | bc)
        echo "${binaries[$core]} na jadre $core: čas $elapsed_bin sekúnd"

        # Meranie pre matrix_O3
        start_O3=$(date +%s.%N)
        taskset -c $core ./matrix_O3
        end_O3=$(date +%s.%N)
        elapsed_O3=$(echo "$end_O3 - $start_O3" | bc)
        total_O3=$(echo "$total_O3 + $elapsed_O3" | bc)
        echo "matrix_O3 na jadre $core: čas $elapsed_O3 sekúnd"

        # Meranie pre matrix_O3armv8
        start_O3armv8=$(date +%s.%N)
        taskset -c $core ./matrix_O3armv8
        end_O3armv8=$(date +%s.%N)
        elapsed_O3armv8=$(echo "$end_O3armv8 - $start_O3armv8" | bc)
        total_O3armv8=$(echo "$total_O3armv8 + $elapsed_O3armv8" | bc)
        echo "matrix_O3armv8 na jadre $core: čas $elapsed_O3armv8 sekúnd"

        # Meranie pre matrix_O3armv9
        start_O3armv9=$(date +%s.%N)
        taskset -c $core ./matrix_O3armv9
        end_O3armv9=$(date +%s.%N)
        elapsed_O3armv9=$(echo "$end_O3armv9 - $start_O3armv9" | bc)
        total_O3armv9=$(echo "$total_O3armv9 + $elapsed_O3armv9" | bc)
        echo "matrix_O3armv9 na jadre $core: čas $elapsed_O3armv9 sekúnd"

        # Meranie pre matrix_native (nová binárka s -march=native)
        start_native=$(date +%s.%N)
        taskset -c $core ./matrix_native
        end_native=$(date +%s.%N)
        elapsed_native=$(echo "$end_native - $start_native" | bc)
        total_native=$(echo "$total_native + $elapsed_native" | bc)
        echo "matrix_native na jadre $core: čas $elapsed_native sekúnd"
    done

    avg_bin=$(echo "$total_bin / $number" | bc -l)
    avg_O3=$(echo "$total_O3 / $number" | bc -l)
    avg_O3armv8=$(echo "$total_O3armv8 / $number" | bc -l)
    avg_O3armv9=$(echo "$total_O3armv9 / $number" | bc -l)
    avg_native=$(echo "$total_native / $number" | bc -l)

    echo "Priemerný čas pre ${binaries[$core]} na jadre $core: $avg_bin sekúnd"
    echo "Priemerný čas pre matrix_O3 na jadre $core: $avg_O3 sekúnd"
    echo "Priemerný čas pre matrix_O3armv8 na jadre $core: $avg_O3armv8 sekúnd"
    echo "Priemerný čas pre matrix_O3armv9 na jadre $core: $avg_O3armv9 sekúnd"
    echo "Priemerný čas pre matrix_native na jadre $core: $avg_native sekúnd"
}

# Meranie výkonu na jednotlivých jadrách, všetky binárky naraz
echo "Meranie na jadre 7:"
measure_all_in_cycle 7

echo "Meranie na jadre 4:"
measure_all_in_cycle 4

echo "Meranie na jadre 0:"
measure_all_in_cycle 0

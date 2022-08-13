# paths
ENV=$(pwd)
HF=${ENV}/miniep5/hyperfine/hyperfine
SCR=${ENV}/miniep5/hyperfine/scripts
cd ${ENV}/ep1

# prepare out
OUT=out/$(date +"%Y%m%d%H%M%S")
mkdir -p ${OUT}

# compile
make -C src
for STRAT in seq pth omp
do
    mv src/mandelbrot_${STRAT} ${OUT}/
done

# helper function for creating pictures
gen () {
    cd ${OUT}
    ./mandelbrot_$@
    mv output.ppm $1_$2.ppm
    cd ../..
}

# create pictures and check if they are all equal
SIZE=2000
CHECK=equal
for REGION in full seahorse elephant spiral
do
    gen seq ${REGION} ${SIZE}
    for STRAT in pth omp
    do
        gen ${STRAT} ${REGION} ${SIZE}
        cmp -s ${OUT}/seq_${REGION}.ppm ${OUT}/${STRAT}_${REGION}.ppm
        if [ $? -ne 0 ]; then
            CHECK=different
            break 2
        fi
    done
done
echo ${CHECK}

# 2**seq with commas
gseqc () {
    RES=
    for x in $(seq $1 $2 $3)
    do 
        RES=(${RES},$((2**x)))
    done
    echo "${RES:1}"
}

# benchmarking seq
cd src
LOG=../${OUT}/bench_seq.txt
echo -n "" > ${LOG}
$HF --runs 10 \
    --export-json ../${OUT}/bench_seq.json \
    -L strat seq \
    -L region full,seahorse,elephant,spiral \
    -L bench 0,1 \
    -L size $(gseqc 4 13) \
    -p "make BENCH={bench}" \
    "./mandelbrot_{strat} {region} {size}" \
    -c "make clean" \
    >> ${LOG}
cd ..

# benchmarking pth and omp
cd src
LOG=../${OUT}/bench_par.txt
echo -n "" > ${LOG}
$HF --runs 10 \
    --export-json ../${OUT}/bench_par.json \
    -L strat pth,omp \
    -L region full,seahorse,elephant,spiral \
    -L bench 1 \
    -L num_threads $(gseqc 0 5) \
    -L size $(gseqc 4 13) \
    -p "make BENCH={bench} NUM_THREADS={num_threads}" \
    "./mandelbrot_{strat} {region} {size}" \
    -c "make clean" \
    >> ${LOG}
cd ..

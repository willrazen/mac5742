# paths
ENV=$(pwd)
HF=${ENV}/miniep5/hyperfine/hyperfine
SCR=${ENV}/miniep5/hyperfine/scripts
cd ${ENV}/miniep5

# prepare out
OUT=out/$(date +"%Y%m%d%H%M%S")
mkdir -p ${OUT}/hf
# rm -f ${OUT}/hf/*

# ranges
num_ifs=(0 1 10 100 1000 10000)
num_threads=(1 2 4 8 16 32 64 128 256 512 1024 2048 4096)
array_size=(1 10 100 1000 10000 100000 1000000)

# run
for i in ${num_ifs}
do
    make --silent -C src IF=${i}
    mv src/contention ${OUT}
    for t in ${num_threads}
    do
        for a in ${array_size}
        do
            name=${i}_${t}_${a}
            $HF --runs 100 --export-json ${OUT}/hf/${name}.json "${OUT}/contention ${t} ${a}" > ${OUT}/hf/${name}.txt
        done
    done
done
rm -f ${OUT}/contention

# analyze (done in analysis.ipynb)
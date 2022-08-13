# paths
ENV=$(pwd)
HF=${ENV}/miniep5/hyperfine/hyperfine
SCR=${ENV}/miniep5/hyperfine/scripts
cd ${ENV}/miniep6

# prepare out
OUT=out/$(date +"%Y%m%d%H%M%S")
mkdir -p ${OUT}
lstopo --of svg | grep -v anon > ${OUT}/lstopo.svg

# find best algorithm 1
FN=alg1
LOG=${OUT}/${FN}.txt
echo -n "" > ${LOG}
for ORD in ijk ikj jik jki kij kji
do
    echo "-------------\nORDER = ${ORD}\n" >> ${LOG}
    ORD_STR=$(echo "*x=\&${ORD:0:1},*y=\&${ORD:1:1},*z=\&${ORD:2:1}")
    sed "s/@ORD@/${ORD_STR}/" src/${FN}.c > ${OUT}/.${FN}.c
    gcc-11 -O2 -o ${OUT}/${FN} ${OUT}/.${FN}.c
    $HF --runs 10 --export-json ${OUT}/${FN}_${ORD}.json "${OUT}/${FN}" >> ${LOG}
    rm -f ${OUT}/.${FN}.c ${OUT}/${FN}
done

# geometric seq
gseq () { for x in $(seq $1 $2 $3); do echo $((2**x)); done }

# find best algorithm 2
FN=alg2
SUFFIX=
LOG=${OUT}/${FN}${SUFFIX}.txt
echo -n "" > ${LOG}
BLK=
for Ah in $(gseq 0 10)
for Aw in $(gseq 0 10)
for Bw in $(gseq 0 10)
do
    BLK=(${BLK},Ah=${Ah}\\,Aw=${Aw}\\,Bw=${Bw})
done
BLK="${BLK:1}"
$HF --runs 10 --export-json ${OUT}/${FN}${SUFFIX}.json -L blk ${BLK} -p \
"sed 's/@BLK@/{blk}/' src/${FN}.c | gcc-11 -O2 -o ${OUT}/${FN} -xc -" \
"${OUT}/${FN}" >> ${LOG}
rm -f ${OUT}/${FN}

# fine tune algorithm 2
FN=alg2
SUFFIX=_fine
LOG=${OUT}/${FN}${SUFFIX}.txt
echo -n "" > ${LOG}
BLK=
Aw=4
Bw=512
for Ah in $(seq 4 4 256)
do
    BLK=(${BLK},Ah=${Ah}\\,Aw=${Aw}\\,Bw=${Bw})
done
BLK="${BLK:1}"
$HF --runs 50 --export-json ${OUT}/${FN}${SUFFIX}.json -L blk ${BLK} -p \
"sed 's/@BLK@/{blk}/' src/${FN}.c | gcc-11 -O2 -o ${OUT}/${FN} -xc -" \
"${OUT}/${FN}" >> ${LOG}
rm -f ${OUT}/${FN}

# compare best alg 2
FN=alg2
SUFFIX=_best
LOG=${OUT}/${FN}${SUFFIX}.txt
echo -n "" > ${LOG}
BLK=(Ah=n\\,Aw=n\\,Bw=n,Ah=160\\,Aw=4\\,Bw=512)
$HF --runs 100 --export-json ${OUT}/${FN}${SUFFIX}.json -L blk ${BLK} -p \
"sed 's/@BLK@/{blk}/' src/${FN}.c | gcc-11 -O2 -o ${OUT}/${FN} -xc -" \
"${OUT}/${FN}" >> ${LOG}
rm -f ${OUT}/${FN}

# run all algorithms
LOG=${OUT}/all.csv
make test -B -C src --silent > ${LOG}
make clean -C src

# var size
gcc-11 -Wall -Wno-maybe-uninitialized -pedantic -g -O2 -o ${OUT}/size src/size.c
${OUT}/size

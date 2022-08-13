# paths
ENV=$(pwd)
cd ${ENV}/miniep4

# prepare out
OUT=out/$(date +"%Y%m%d%H%M%S")
mkdir -p ${OUT}

# get sytem information
go run main.go -info sys > ${OUT}/info.txt
sysctl -a | grep "^hw.*l.*size" >> ${OUT}/info.txt

# measure
echo 'Padding[bytes],Offset[bytes],Size[bytes],Time[ms],Stddev[%]' > ${OUT}/data.csv
for PAD in {0..137}
do
    find fs -type f -name "*.go" -print0 | \
        xargs -0 gsed -i "s/padding = [[:digit:]]\+/padding = ${PAD}/g"
    INFO=$(go run main.go -info struct)
    go test -count=100 miniep4/fs -run=^$ -bench . -benchtime=1x > ${OUT}/tmp.txt
    r=$(${HOME}/go/bin/benchstat ${OUT}/tmp.txt | \
        grep ms | tr -s ' ' | cut -d ' ' -f 2- | tr -d ' ')
    echo ${PAD},${INFO},${r//ms±/,} >> ${OUT}/data.csv
done
rm -f ${OUT}/tmp.txt

# analyze (done in analysis.ipynb)
# paths
ENV=$(pwd)
cd ${ENV}/miniep4

# macOS compatibility
# brew install gsed

# prepare out
OUT=out/$(date +"%Y%m%d%H%M%S")
mkdir -p ${OUT}

# get sytem information
go run main.go > ${OUT}/info.txt

# measure
echo 'Padding[bytes],Offset[bytes],NoPadTime[ms],NoPadDev[%],PadTime[ms],PadDev[%]' > ${OUT}/data.csv
for PADBYTES in {1..137}
do
    find fs -type f -name "*.go" -print0 | xargs -0 gsed -i "s/padBytes = [[:digit:]]\+/padBytes = ${PADBYTES}/g"
    OFF=$(go run main.go -off)
    go test -count=10 miniep4/fs -run=^$ -bench . -benchtime=1x > ${OUT}/tmp.txt
    r=$(${HOME}/go/bin/benchstat ${OUT}/tmp.txt | grep ms | tr -s ' ' | cut -d ' ' -f 2- | tr '\n' ',')
    r=${r//ms ±/,}
    r=${r// /}
    echo ${PADBYTES},${OFF},${r%,} >> ${OUT}/data.csv
done

# analyse
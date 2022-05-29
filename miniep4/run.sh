# macOS compatibility
# brew install gsed

# prepare out
OUT=out/$(date +"%Y%m%d%H%M%S")
mkdir -p ${OUT}

# get sytem information
go run main.go > ${OUT}/info.txt

# measure
echo 'PadBytes,NoPadTime[ms],NoPadDev[%],PadTime[ms],PadDev[%]' > ${OUT}/data.csv
for PADBYTES in {1..137}
do
    find fs -type f -name "*.go" -print0 | xargs -0 gsed -i "s/padBytes = [[:digit:]]\+/padBytes = ${PADBYTES}/g"
    go test -count=100 miniep4/fs -run=^$ -bench . -benchtime=1x > ${OUT}/tmp.txt
    r=$(${HOME}/go/bin/benchstat ${OUT}/tmp.txt | grep ms | tr -s ' ' | cut -d ' ' -f 2- | tr '\n' ',')
    r=${r//ms ±/,}
    r=${r// /}
    echo ${PADBYTES},${r%,} >> ${OUT}/data.csv
done

# analyse
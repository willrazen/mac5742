# paths
ENV=/home/ec2-user/environment/mac5742
HF=${ENV}/miniep1/hyperfine/hyperfine
SCR=${ENV}/miniep1/hyperfine/scripts
cd ${ENV}/miniep2

# prepare out
OUT=out/$(date +"%Y%m%d%H%M%S")
mkdir -p ${OUT}

# testing
go test -count=1 -v -cpu 2 miniep2/pi > ${OUT}/test.txt

# profiling with go
go test -v -cpu 2 miniep2/pi -run=^$ -bench Original -benchtime=60s -benchmem -memprofile ${OUT}/mem.prof -cpuprofile ${OUT}/cpu.prof > ${OUT}/original.bench
rm -f pi.test
#go tool pprof -http=localhost:8080 ${OUT}/cpu.prof
go tool pprof -svg ${OUT}/cpu.prof > ${OUT}/cpu_graph.svg
go tool pprof -http=localhost:8080 --no_browser ${OUT}/cpu.prof < /dev/null &
sleep 1
curl "http://localhost:8080/ui/flamegraph" -o ${OUT}/cpu_flame.html
kill $!

# benchmarking
go test -count=500 -cpu 2 miniep2/pi -run=^$ -bench . -benchtime=1x -benchmem > ${OUT}/all.bench
${HOME}/go/bin/benchstat ${OUT}/all.bench > ${OUT}/stats.txt

# compiler optimizations
go build -o ${OUT}/pi -compiler gc -gcflags "-m"
go build -o ${OUT}/pi_exe -buildmode=exe -compiler gc -gcflags "-m"
#go build -o ${OUT}/pi_gccgo -compiler gccgo -gccgoflags="-fPIC -m64 -pthread -fmessage-length=0 -fdebug-prefix-map=/tmp/go-build484823780=/tmp/go-build -gno-record-gcc-switches -O2"
$HF --runs 200 --warmup 20 "${OUT}/pi" "${OUT}/pi_exe" > ${OUT}/compile.txt

# final analysis
$HF --runs 1000 --warmup 100 --export-json ${OUT}/best.json "${OUT}/pi_exe" > ${OUT}/best.txt
analyze () {
    python3 ${SCR}/advanced_statistics.py ${OUT}/${1}.json > ${OUT}/${1}_stats.txt
    python3 ${SCR}/plot_histogram.py ${OUT}/${1}.json --bins ${2} -o ${OUT}/${1}_hist.png
    python3 ${SCR}/plot_progression.py ${OUT}/${1}.json -o ${OUT}/${1}_prog.png
}
analyze best 100

# paths
ENV=/home/ec2-user/environment/mac5742
HF=${ENV}/hyperfine/hyperfine
cd ${ENV}/MiniEP2

# prepare out
OUT=out/$(date +"%Y%m%d%H%M%S")
mkdir -p ${OUT}

# profiling with go test
go test ./src -v -cpu 4 -bench . -benchmem -memprofile ${OUT}/mem.prof -cpuprofile ${OUT}/cpu.prof -benchtime=10s > ${OUT}/bench.log
mv src.test ${OUT}
go tool pprof -svg ${OUT}/cpu.prof > ${OUT}/cpu.svg
go tool pprof -http=localhost:8080 ${OUT}/cpu.prof

# profiling with perf
go build -o ${OUT}/pi src/main.go
sudo perf record -F max -o ${OUT}/perf.data --call-graph dwarf ${OUT}/pi

# time with hyperfine
go build -o ${OUT}/pi -buildmode=exe -compiler gc src/main.go
#go build -o ${OUT}/pi -compiler gccgo -gccgoflags="-fPIC -m64 -pthread -fmessage-length=0 -fdebug-prefix-map=/tmp/go-build484823780=/tmp/go-build -gno-record-gcc-switches -O2" src/main.go
$HF --runs 100 --warmup 10 "${OUT}/pi"


#https://meltware.com/2019/01/16/gccgo-benchmarks-2019.html
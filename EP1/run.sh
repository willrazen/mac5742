# paths
ENV=/home/ec2-user/environment/mac5742
HF=${ENV}/hyperfine/hyperfine
SCR=${ENV}/hyperfine/scripts
cd ${ENV}/EP1

# prepare out
OUT=out/$(date +"%Y%m%d%H%M%S")
mkdir -p ${OUT}
INFO=${OUT}/run_info.txt

# prepare go
go version > ${INFO}
go build -o bin/pi src/main.go

# prepare python
python --version >> ${INFO}
pip install numpy matplotlib scipy

# run
$HF --runs 2000 --export-json ${OUT}/go.json "bin/pi"
$HF --runs 100 --export-json ${OUT}/py.json "python3 src/main.py"
#$HF --runs 10 --export-json ${OUT}/py_np.json "python3 src/main_np.py"

# analyze results
analyze () {
    python ${SCR}/advanced_statistics.py ${OUT}/${1}.json > ${OUT}/${1}_stats.txt
    python ${SCR}/plot_histogram.py ${OUT}/${1}.json --bins ${2} -o ${OUT}/${1}_hist.png
    python ${SCR}/plot_progression.py ${OUT}/${1}.json -o ${OUT}/${1}_prog.png
}
analyze go 500
analyze py 50

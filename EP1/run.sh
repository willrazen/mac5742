# paths
env=/home/ec2-user/environment
hf=$env/hyperfine/hyperfine
scripts=$env/hyperfine/scripts
cd ${env}/EP1

# prepare go
go version
go build -o bin/pi src/main.go

# prepare python
python --version
pip install numpy matplotlib scipy

# run
$hf --runs 2000 --export-json out/go.json "${env}/EP1/bin/pi"
$hf --runs 100 --export-json out/py.json "python3 ${env}/EP1/src/main.py"
#$hf --runs 10 --export-json out/py_np.json "python3 ${env}/EP1/src/main_np.py"

# analyze results
analyze () {
    python $scripts/advanced_statistics.py out/${1}.json > out/${1}_stats.txt
    python $scripts/plot_histogram.py out/${1}.json --bins ${2} -o out/${1}_hist.png
    python $scripts/plot_progression.py out/${1}.json -o out/${1}_prog.png
}
analyze go 500
analyze py 50

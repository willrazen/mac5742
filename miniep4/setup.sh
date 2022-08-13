# paths
ENV=$(pwd)
cd ${ENV}/miniep4

# macOS sed
brew install gsed

# go libs
go get golang.org/x/perf/cmd/benchstat

# python libs (using pyenv)
echo "3.10.4" > .python-version
python -m venv venv
source ./venv/bin/activate
pip install --upgrade pip
pip install setuptools wheel
pip install pandas plotly kaleido notebook ipykernel
python -m ipykernel install --name=venv

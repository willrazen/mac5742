# paths
ENV=$(pwd)
cd ${ENV}/miniep6

# install hyperfine
VER=v1.13.0
ARQ=x86_64-apple-darwin
mkdir -p tmp
curl -L https://github.com/sharkdp/hyperfine/releases/download/${VER}/hyperfine-${VER}-${ARQ}.tar.gz -o tmp/hyperfine.tar.gz
tar -xzvf tmp/hyperfine.tar.gz -C tmp
mkdir -p hyperfine
mv tmp/hyperfine-${VER}-${ARQ}/* hyperfine/
git clone https://github.com/sharkdp/hyperfine.git tmp/repo
mv tmp/repo/scripts/ hyperfine/
rm -rf tmp

# set python
echo "3.10.4" > .python-version
python -m venv venv
source ./venv/bin/activate
pip install --upgrade pip
pip install setuptools wheel
pip install pandas tabulate plotly kaleido notebook ipykernel
python -m ipykernel install --name=venv

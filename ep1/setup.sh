# paths
ENV=$(pwd)
cd ${ENV}/ep1

# set python
echo "3.10.4" > .python-version
python -m venv venv
source ./venv/bin/activate
pip install --upgrade pip
pip install setuptools wheel
pip install pandas tabulate plotly kaleido notebook ipykernel Pillow
python -m ipykernel install --name=venv

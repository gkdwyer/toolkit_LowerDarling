# experimental HPC setup script

# Trying to get this to work with pip on HPC. It's annoying because 3.11 seems broken
module load python/3.9

# build venv
python3 -m venv rtoolkit
source rtoolkit/bin/activate

# should install the toml, but the direct install seems to work better.
# python3 -m pip install .
pip install git+https://github.com/MDBAuth/EWR_tool.git@GalenH

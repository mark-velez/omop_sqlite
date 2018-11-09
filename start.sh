#!/usr/bin/env bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
virtualenv venv
./venv/bin/pip install --upgrade pip
source venv/bin/activate
pip install -r requirements.txt
export JUPYTER_CONFIG_DIR="${SCRIPTPATH}"
jupyter notebook --generate-config -y
echo "c.NotebookApp.contents_manager_class = 'jupytext.TextFileContentsManager'" >> jupyter_notebook_config.py
echo "c.NotebookApp.default_jupytext_formats = 'ipynb,py:light'" >> jupyter_notebook_config.py
echo "c.ContentsManager.freeze_metadata = True" >> jupyter_notebook_config.py
jupyter notebook --notebook-dir=nb

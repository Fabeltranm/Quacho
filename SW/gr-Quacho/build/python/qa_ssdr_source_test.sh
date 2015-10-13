#!/bin/sh
export GR_DONT_LOAD_PREFS=1
export srcdir=/home/ferney/DOCTORADO/QUACHO/gr-Quacho/python
export PATH=/home/ferney/DOCTORADO/QUACHO/gr-Quacho/build/python:$PATH
export LD_LIBRARY_PATH=/home/ferney/DOCTORADO/QUACHO/gr-Quacho/build/lib:$LD_LIBRARY_PATH
export PYTHONPATH=/home/ferney/DOCTORADO/QUACHO/gr-Quacho/build/swig:$PYTHONPATH
/usr/bin/python2 /home/ferney/DOCTORADO/QUACHO/gr-Quacho/python/qa_ssdr_source.py 

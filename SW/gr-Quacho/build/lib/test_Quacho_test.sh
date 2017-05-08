#!/bin/sh
export GR_DONT_LOAD_PREFS=1
export srcdir=/home/ferney/DOCTORADO/QUACHO/gr-Quacho/lib
export PATH=/home/ferney/DOCTORADO/QUACHO/gr-Quacho/build/lib:$PATH
export LD_LIBRARY_PATH=/home/ferney/DOCTORADO/QUACHO/gr-Quacho/build/lib:$LD_LIBRARY_PATH
export PYTHONPATH=$PYTHONPATH
test-Quacho 

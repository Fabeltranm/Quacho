/* -*- c++ -*- */

#define QUACHO_API

%include "gnuradio.i"			// the common stuff

//load generated python docstrings
%include "Quacho_swig_doc.i"

%{
#include "Quacho/ssdr_sink.h"
#include "Quacho/ssdr_source.h"
%}


%include "Quacho/ssdr_sink.h"
GR_SWIG_BLOCK_MAGIC2(Quacho, ssdr_sink);
%include "Quacho/ssdr_source.h"
GR_SWIG_BLOCK_MAGIC2(Quacho, ssdr_source);

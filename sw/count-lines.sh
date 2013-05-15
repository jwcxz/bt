#!/bin/bash

# entertaining script to count number of lines written for this

function numlines {
    printf '%5d\n' `wc -l $@ | tail -n 1 | sed -e 's/^ *//' | cut -d' ' -f1`
}

BSV=`ls -1 bsv/*.bsv`
VHD=`find fpga/hdl/ -iname "*.vhd"`
TEX=`find doc -iname "*.tex"`
TB=`find sim/bsv/ -iname "*.bsv"`
SH=`find sw -iname "*.sh"`
PY=`find sw -iname "*.py"`

echo "Calculating amount of brainpower spent on bt..."
echo ""

echo "Language      Lines"
echo "------------  -----"

echo -n " Bluespec: "; numlines $BSV
echo -n "     VHDL: "; numlines $VHD
echo -n "Testbench: "; numlines $TB
echo -n "    LaTeX: "; numlines $TEX
echo -n "    Shell: "; numlines $SH
echo -n "   Python: "; numlines $PY
echo ""
echo -n "    Total: "; numlines $BSV $VHD $TB $TEX $SH $PY

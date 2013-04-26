#!/usr/bin/env python2

import sys
import numpy as np
import todat, fromdat

indata = fromdat.from_dat(sys.argv[1]);

outdata = [];
for sample in indata:
    outdata.append(sample*sample);

todat.to_dat_l(outdata, sys.argv[2]);

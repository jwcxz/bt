#!/usr/bin/env python2

# convert wav file to 14-bit representation that bluespec can understand

import sys
import numpy as np

import sampler

def to_dat(indata, inwidth, fname):
    f = open(fname, 'wb');

    shift = inwidth - 14;

    for sample in indata:
        sample = sample/(2**shift);
        a = (sample >> 8) & 0x3F;
        b = sample & 0xFF;
        f.write(chr(a) + chr(b));

    f.close();

def to_dat_l(indata, fname):
    f = open(fname, 'wb');

    for sample in indata:
        a = (sample >> 24) & 0x0F;
        b = (sample >> 16) & 0xFF;
        c = (sample >>  8) & 0xFF;
        d = sample & 0xFF;

        f.write(chr(a) + chr(b) + chr(c) + chr(d));

    f.close();
    

if __name__ == "__main__":
    fr, sw, wavdata = sampler.get_samples(sys.argv[1]);
    shift = sw*8 - 14;
    indata = wavdata[:,0];

    """
    indata = [];
    for s in [1,2,3,4,5,6,-1,-2,-3,-4,-5,-6]:
        indata.append(s << 2);
    """

    to_dat(indata, sw*8, sys.argv[2]);

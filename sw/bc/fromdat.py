#!/usr/bin/env python2

# read samples from a dat file

import sys
import numpy as np

def twoscomp(sample):
    if (sample >> 13) == 1:
        # negative
        return -( (sample ^ 0x3FFF) + 1);
    else:
        # positive
        return sample;

final_width = 14;

samples = [];

def from_dat(fname):
    f = open(fname, 'rb');
    data = f.read();
    
    i = 0;
    while i < len(data):
        sample = (ord(data[i]) << 8) + (ord(data[i+1]))
        sample = twoscomp(sample);

        samples.append(sample);

        i += 2;

    return samples;

if __name__ == "__main__":
    s = from_dat(sys.argv[1]);
    print s;

#!/usr/bin/env python2

import struct, sys, wave
import numpy as np

def twoscomp(sample):
    if (sample >> 15) == 1:
        # negative
        return -( (sample ^ 0xFFFF) + 1);
    else:
        # positive
        return sample;

def get_samples(fname):
    wf = wave.open(fname, 'r');
    frate = wf.getframerate();
    unpacker = "<%s" % ("H"*wf.getnchannels()*wf.getnframes());
    frames = wf.readframes(wf.getnframes());
    wf.close();

    samples = [ twoscomp(s) for s in struct.unpack(unpacker, frames) ];
    samples = np.array(samples);

    return (frate, samples.reshape((-1,2)));


if __name__ == "__main__":
    fr, s = get_samples(sys.argv[1]);
    print fr, s.shape

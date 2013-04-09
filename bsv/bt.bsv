import Types::*;


import ClientServer::*;
import GetPut::*;

import FixedPoint::*;

import AudioProcessorTypes::*;
import Chunker::*;
import FFT::*;
import FIRFilter::*;
import Splitter::*;

import Vector::*;

import OverSampler::*;
import Overlayer::*;
import ToMP::*;
import FromMP::*;
import PitchAdjust::*;

import FilterCoefficients::*;



interface BeatTracker;
    method Action putSampleInput(AudioSample in);
    method ActionValue#(MetBankOutput) getBeatInfo();
endinterface

module mkBeatTracker(BeatTracker);


    //BeatClassifier bc <- mkBeatClassifier();

    //MetronomeBank mb <- mkMetronomeBank();


    method Action putSampleInput(AudioSample x);
        bc.request.put(x);
    endmethod

    method ActionValue#(MetBankOutput) getBeatInfo();
        let x <- mb.response.get();
        return x;
    endmethod


endmodule

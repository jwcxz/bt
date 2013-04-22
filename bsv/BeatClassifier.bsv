import Types::*;

import FShow::*;

import ClientServer::*;
import GetPut::*;
import FIFO::*;

typedef Server#(
    AudioSample,
    BeatGuess
) BeatClassifier;


module mkBeatClassifier(BeatClassifier);
    FIFO#(AudioSample) infifo  <- mkFIFO1();
    FIFO#(BeatGuess)   outfifo <- mkFIFO1();

    Reg#(SampleEnergy) cur_energy <- mkReg(0);
    Reg#(SampleEnergy) avg_energy <- mkReg(0);

    Reg#(SampleCount) sample_count <- mkReg(0);

    //*
    rule inject_sample (sample_count != fromInteger(sample_count_max));
        let sample = infifo.first();
        infifo.deq();

        SampleEnergy rsample = extend(unpack(sample));
        SampleEnergy energy = rsample * rsample;
        //$display("got: ", fshow(sample), fshow(rsample), fshow(energy));
        
        cur_energy <= cur_energy + energy/fromInteger(sample_count_max+1);
        sample_count <= sample_count + 1;
    endrule
    // */

    //*
    rule compare_energies (sample_count == fromInteger(sample_count_max));
        if (cur_energy > avg_energy + (avg_energy/2)) begin
            $display("UNS ", fshow(cur_energy), "/", fshow(avg_energy));

            BeatGuess x = pack(avg_energy);
            outfifo.enq(x);
        end

        //*
        avg_energy <= (avg_energy/2) + (cur_energy/2);
        // */

        /*
        avg_energy <= (cur_energy/8) + 
                      (avg_energy/2) + (avg_energy/4) + (avg_energy/8);
        // */

        cur_energy <= fromInteger(0);

        sample_count <= 0;
    endrule
    // */

    interface Put request = toPut(infifo);
    interface Get response = toGet(outfifo);
endmodule

import Types::*;

import FShow::*;

import ClientServer::*;
import GetPut::*;
import FIFO::*;

import Vector::*;
import FixedPoint::*;

typedef Server#(
    AudioSample,
    BeatGuess
) BeatClassifier;


module mkBeatClassifier(BeatClassifier);
    BeatClassifier bc <- mkBeatClassifierVariance();

    interface Put request = bc.request;
    interface Get response = bc.response;
endmodule


module mkBeatClassifierVariance(BeatClassifier);
    FIFO#(AudioSample) infifo  <- mkFIFO1();
    FIFO#(BeatGuess)   outfifo <- mkFIFO1();

    Reg#(SampleCount) sample_count <- mkReg(0);
    Reg#(UInt#(4)) energy_stage <- mkReg(0);

    Reg#(UInt#(26)) cur_energy <- mkReg(0);

    Vector#(AvgEnergyLength, Reg#(Energy))   energy_buf <- replicateM(mkReg(0));
    Vector#(AvgEnergyLength, Reg#(SqEnergy)) square_buf <- replicateM(mkReg(0));
    Integer buf_last_idx = valueof(TSub#(AvgEnergyLength,1));

    Reg#(Energy)   avg_energy <- mkReg(0);
    Reg#(SqEnergy) sqr_energy <- mkReg(0);
    Reg#(SqEnergy) variance <- mkReg(0);
    Reg#(CuEnergy) lin_b <- mkReg(0);

    Reg#(LinReg) fp_lin_b <- mkReg(0);
    Reg#(LinReg) fp_lin_a <- mkReg(0);

    rule inject_sample (sample_count != fromInteger(sample_count_max));
        let sample = infifo.first();
        infifo.deq();

        // cheap trick to switch everything to unsigned multiplication
        UInt#(13) l = unpack( pack(abs(sample.left))[12:0] );
        UInt#(13) r = unpack( pack(abs(sample.right))[12:0] );

        UInt#(26) energy_l = unsignedMul(l, l);
        UInt#(26) energy_r = unsignedMul(r, r);

        UInt#(26) energy = energy_l/2 + energy_r/2;
        
        cur_energy <= cur_energy + energy/fromInteger(sample_count_max+1);
        sample_count <= sample_count + 1;
    endrule
    
    // energy calculations
    rule energy_calc_in (sample_count == fromInteger(sample_count_max) &&
                         energy_stage == 0);

        Energy   cur_etrunc = unpack( pack(cur_energy)[25:25-valueof(TSub#(VISize,1))] );
        SqEnergy cur_square = unsignedMul(cur_etrunc, cur_etrunc);


        // calculate mu_E and mu_E2
        avg_energy <= avg_energy - (energy_buf[1]/fromInteger(avg_energy_length))
                                 + (cur_etrunc/fromInteger(avg_energy_length));

        sqr_energy <= sqr_energy - (square_buf[0]/fromInteger(avg_energy_length))
                                 + (cur_square/fromInteger(avg_energy_length));


        // shift energy bufs down
        energy_buf[buf_last_idx] <= cur_etrunc;
        square_buf[buf_last_idx] <= cur_square;

        for (Integer i = 0; i < valueof(TSub#(AvgEnergyLength,1)); i = i + 1) begin
            energy_buf[i] <= energy_buf[i+1];
            square_buf[i] <= square_buf[i+1];
        end

        energy_stage <= 1;
    endrule

    rule energy_calc_1 (energy_stage == 1);
        variance <= sqr_energy - unsignedMul(avg_energy, avg_energy);
        $display("> ", fshow(sqr_energy), " ", fshow(unsignedMul(avg_energy, avg_energy)), " ", fshow(sqr_energy - unsignedMul(avg_energy, avg_energy)));
        energy_stage <= 2;
    endrule

    rule energy_calc_2 (energy_stage == 2);
        // multiply variance term by average energy
        lin_b <= unsignedMul(variance, avg_energy);
        energy_stage <= 3;
    endrule

    rule energy_calc_3 (energy_stage == 3);
        // obtain coefficients
        fp_lin_a <= fromReal(1.5142857) * fromUInt(avg_energy);
        fp_lin_b <= fromReal(0.0025714) * fromUInt(lin_b);
        energy_stage <= 4;
    endrule

    rule energy_calc_4 (energy_stage == 4);
        // obtain coefficients
        LinReg cur_energy_fp = fromUInt(energy_buf[buf_last_idx]);

        if (cur_energy_fp > fp_lin_a - fp_lin_b) begin
            $display("UNS ", fshow(cur_energy), " / ", fshow(avg_energy),
                        fshow(fp_lin_a), fshow(fp_lin_b),
                        fshow(fp_lin_a - fp_lin_b));

            UInt#(28) y = fromInteger(0);
            BeatGuess x = pack(y);
            outfifo.enq(x);
        end

        energy_stage <= 0;

        // reset sample_count
        sample_count <= 0;
    endrule

    interface Put request = toPut(infifo);
    interface Get response = toGet(outfifo);
endmodule


module mkBeatClassifierFixed(BeatClassifier);
    FIFO#(AudioSample) infifo  <- mkFIFO1();
    FIFO#(BeatGuess)   outfifo <- mkFIFO1();

    Reg#(UInt#(26)) cur_energy <- mkReg(0);
    Reg#(UInt#(26)) avg_energy <- mkReg(0);

    Reg#(SampleCount) sample_count <- mkReg(0);

    //*
    rule inject_sample (sample_count != fromInteger(sample_count_max));
        let sample = infifo.first();
        infifo.deq();

        // cheap trick to switch everything to unsigned multiplication
        UInt#(13) l = unpack( pack(abs(sample.left))[12:0] );
        UInt#(13) r = unpack( pack(abs(sample.right))[12:0] );

        UInt#(26) energy_l = unsignedMul(l, l);
        UInt#(26) energy_r = unsignedMul(r, r);

        UInt#(26) energy = energy_l/2 + energy_r/2;
        
        cur_energy <= cur_energy + energy/fromInteger(sample_count_max+1);
        sample_count <= sample_count + 1;
    endrule
    // */

    //*
    rule compare_energies (sample_count == fromInteger(sample_count_max));
        if (cur_energy > avg_energy + (avg_energy/2)) begin
            $display("UNS ", fshow(cur_energy), "/", fshow(avg_energy));

            BeatGuess x = {2'b00, pack(avg_energy)};
            outfifo.enq(x);
        end

        /*
        avg_energy <= (avg_energy/2) + (cur_energy/2);
        // */

        //*
        avg_energy <= (cur_energy/16) + 
                      (avg_energy/2) + (avg_energy/4) +
                        (avg_energy/8) + (avg_energy/16);
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


module mkBeatClassifierTest(BeatClassifier);
    // basically just generates a metronome

    FIFO#(AudioSample) infifo  <- mkFIFO1();
    FIFO#(BeatGuess)   outfifo <- mkFIFO1();


    Reg#(PulserCount) mpc <- mkReg(0);
    Reg#(Bool) tick <- mkReg(False);

    Reg#(TempoIncrement) increment <- mkReg(calc_tempo_increment(125/4.0));
    Reg#(MetronomeCounter) counter <- mkReg(0);

    rule ignore(True);
        let sample = infifo.first();
        infifo.deq();
    endrule

    rule pulser(True);
        if (mpc != fromInteger(pulser_count_max)) begin
            mpc <= mpc + 1;
            tick <= False;
        end else begin
            mpc <= 0;
            tick <= True;
        end
    endrule

    rule metronome_counter(tick);
        if (counter + increment < counter) begin
            BeatGuess x = fromInteger(0);
            outfifo.enq(x);
        end

        counter <= counter + increment;
    endrule

    interface Put request = toPut(infifo);
    interface Get response = toGet(outfifo);
endmodule

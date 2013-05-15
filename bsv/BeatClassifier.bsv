import Types::*;
import Vector::*;
import FixedPoint::*;

import FShow::*;

import ClientServer::*;
import GetPut::*;
import FIFO::*;

typedef Server#(
    AudioSample,
    BeatGuess
) BeatClassifier;


module mkBeatClassifier(BeatClassifier);
    //BeatClassifier bc <- mkBeatClassifierVariance();
    //BeatClassifier bc <- mkBeatClassifierFixed();
    BeatClassifier bc <- mkBeatClassifierFixedAndBuffered();

    interface Put request = bc.request;
    interface Get response = bc.response;
endmodule


module mkBeatClassifierFixedAndBuffered(BeatClassifier);
    FIFO#(AudioSample) infifo  <- mkFIFO1();
    FIFO#(BeatGuess)   outfifo <- mkFIFO1();

    Reg#(FBEnergy) cur_energy <- mkReg(0);
    Reg#(FBEnergy) avg_energy <- mkReg(0);

    Vector#(FBAvgEnergyLength, Reg#(FBEnergy)) energy_buf <- replicateM(mkReg(0));
    Integer buf_last_idx = valueof(TSub#(FBAvgEnergyLength,1));

    Reg#(SampleCount) sample_count <- mkReg(0);
    Reg#(UInt#(3)) energy_stage <- mkReg(0);

    rule inject_sample (sample_count != fromInteger(sample_count_max));
        let sample = infifo.first();
        infifo.deq();

        Int#(14) l = sample.left;
        Int#(14) r = sample.left;

        Int#(28) e_l = signedMul(l, l);
        Int#(28) e_r = signedMul(r, r);

        Int#(28) e = e_l/2 + e_r/2;
        
        cur_energy <= cur_energy + e/fromInteger(sample_count_max+1);
        sample_count <= sample_count + 1;
    endrule

    rule prepare_energy_calc (sample_count == fromInteger(sample_count_max));
        // calculate new average energy
        FBEnergy old_energy_avg = energy_buf[0] / fromInteger(avg_energy_length);
        FBEnergy new_energy_avg = cur_energy / fromInteger(avg_energy_length);
        FBEnergy c_avg_energy = avg_energy - old_energy_avg + new_energy_avg;


        // shift energy buffer down
        energy_buf[buf_last_idx] <= cur_energy;
        for (Integer i=0; i<buf_last_idx; i=i+1) begin
            energy_buf[i] <= energy_buf[i+1];
        end

        // update average energy
        avg_energy <= c_avg_energy;

        // reset sample energy
        cur_energy <= 0;

        sample_count <= 0;
        energy_stage <= 1;
    endrule

    rule compare_energies (energy_stage == 1);
        // generate comparison
        FBFPEnergy cur_energy_fp = fromInt(energy_buf[buf_last_idx]);
        FBFPEnergy avg_energy_fp = fromReal(1.4) * fromInt(avg_energy);

        if (cur_energy_fp > avg_energy_fp) begin
            BeatGuess x = pack(avg_energy);
            outfifo.enq(x);

            $write("UNS ");
                fxptWrite(4, cur_energy_fp);
                $write(" ");
                fxptWrite(4, avg_energy_fp);
                $display("");
        end

        energy_stage <= 0;
    endrule

    interface Put request = toPut(infifo);
    interface Get response = toGet(outfifo);
endmodule


module mkBeatClassifierFixed(BeatClassifier);
    FIFO#(AudioSample) infifo  <- mkFIFO1();
    FIFO#(BeatGuess)   outfifo <- mkFIFO1();

    Reg#(SampleEnergy) cur_energy <- mkReg(0);
    Reg#(SampleEnergy) avg_energy <- mkReg(0);

    Reg#(SampleCount) sample_count <- mkReg(0);

    //*
    rule inject_sample (sample_count != fromInteger(sample_count_max));
        let sample = infifo.first();
        infifo.deq();

        SampleEnergy energy = signedMul(sample.left, sample.left);
        
        cur_energy <= cur_energy + energy/fromInteger(sample_count_max+1);
        sample_count <= sample_count + 1;
    endrule
    // */

    //*
    rule compare_energies (sample_count == fromInteger(sample_count_max));
        if (cur_energy > avg_energy + (avg_energy/4)) begin
            $display("UNS ", fshow(cur_energy), "/", fshow(avg_energy));

            BeatGuess x = pack(avg_energy);
            outfifo.enq(x);
        end

        /*
        avg_energy <= (avg_energy/2) + (cur_energy/2);
        // */

        //*
        avg_energy <= (cur_energy/4) + 
                      (avg_energy/2) + (avg_energy/4);
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


module mkBeatClassifierVariance(BeatClassifier);
    FIFO#(AudioSample) infifo  <- mkFIFO1();
    FIFO#(BeatGuess)   outfifo <- mkFIFO1();

    Reg#(SampleCount) sample_count <- mkReg(0);
    Reg#(UInt#(4)) energy_stage <- mkReg(0);
    Reg#(VEnergyStage) var_count <- mkReg(0);

    // keeps track of currently running instantaneous energy creator
    Reg#(Int#(28)) smp_energy <- mkReg(0);

    Vector#(VAvgEnergyLength, Reg#(VEnergy)) energy_buf <- replicateM(mkReg(0));
    Integer buf_last_idx = valueof(TSub#(VAvgEnergyLength,1));

    Reg#(VEnergy)    avg_energy <- mkReg(0);
    Reg#(VVariance)  variance <- mkReg(0);
    Reg#(VVarEnergy) lin_b <- mkReg(0);

    Reg#(VLinReg) fp_lin_b <- mkReg(0);
    Reg#(VLinReg) fp_lin_a <- mkReg(0);


    rule inject_sample (sample_count != fromInteger(sample_count_max));
        let sample = infifo.first();
        infifo.deq();

        Int#(14) l = sample.left;
        Int#(14) r = sample.right;

        Int#(28) e_l = signedMul(l, l);
        Int#(28) e_r = signedMul(r, r);

        Int#(28) e = e_l/2 + e_r/2;
        
        smp_energy <= smp_energy + (e >> valueof(SampleCountSize));
        sample_count <= sample_count + 1;
    endrule
    

    // energy calculations
    rule energy_calc_0 (sample_count == fromInteger(sample_count_max) &&
                        energy_stage == 0);

        //Energy   cur_etrunc = unpack( pack(cur_energy)[27:27-valueof(TSub#(VISize,1))] );
        VEnergy   cur_energy = smp_energy;

        // calculate new average energy
        VEnergy old_energy_avg = energy_buf[0] / fromInteger(avg_energy_length); 
        VEnergy new_energy_avg = cur_energy / fromInteger(avg_energy_length);
        VEnergy c_avg_energy = avg_energy - old_energy_avg + new_energy_avg;
        
        // reset variance counter
        variance <= 0;
        
        // shift energy buffer down
        energy_buf[buf_last_idx] <= cur_energy;
        for (Integer i=0; i<buf_last_idx; i=i+1) begin
            energy_buf[i] <= energy_buf[i+1];
        end

        // update average energy
        avg_energy <= c_avg_energy;

        // reset energy sampler
        smp_energy <= 0;

        // progress to next stage
        energy_stage <= 1;
        var_count <= 0;
    endrule

    rule energy_calc_1 (energy_stage == 1);
        VEnergy vt0_t = energy_buf[2*var_count] - avg_energy;
        VEnergy vt1_t = energy_buf[2*var_count+1] - avg_energy;

        VHEnergy vt0_tt = unpack(truncateLSB(pack(vt0_t)));
        VHEnergy vt1_tt = unpack(truncateLSB(pack(vt1_t)));

        VEnergy vt0   = signedMul(vt0_tt, vt0_tt) / fromInteger(avg_energy_length);
        VEnergy vt1   = signedMul(vt1_tt, vt1_tt) / fromInteger(avg_energy_length);

        variance <= variance + vt0 + vt1;
        
        if ( var_count == fromInteger((avg_energy_length/2) - 1) ) begin
            energy_stage <= 2;
        end else begin
            var_count <= var_count + 1;
        end
    endrule

    rule energy_calc_2 (energy_stage == 2);
        // multiply variance term by average energy
        VVarEnergy c_lin_b = signedMul(variance, avg_energy);

        lin_b <= c_lin_b;
        energy_stage <= 3;

        $display("2: ", 
                fshow(variance), " ", 
                fshow(avg_energy), " ",
                fshow(c_lin_b)
            );
    endrule

    rule energy_calc_3 (energy_stage == 3);
        // obtain regression coefficients
        VLinReg c_fp_lin_a = fromReal(1.5142857) * fromInt(avg_energy);
        VLinReg c_fp_lin_b = fromReal(0.0025714) * fromInt(lin_b);

        fp_lin_a <= c_fp_lin_a;
        fp_lin_b <= c_fp_lin_b;
        energy_stage <= 4;

        $write("3: ");
            fxptWrite(4, c_fp_lin_a);
            $write(" ");
            fxptWrite(4, c_fp_lin_b);
            $display("");
    endrule

    rule energy_calc_4 (energy_stage == 4);
        // obtain coefficients
        VLinReg cur_energy_fp = fromInt(energy_buf[buf_last_idx]);

        if (cur_energy_fp > abs(fp_lin_a - fp_lin_b)) begin
            Int#(28) y = fromInteger(0);
            BeatGuess x = pack(y);
            outfifo.enq(x);

            $display("UNS");
        end

        energy_stage <= 0;

        // reset sample_count
        sample_count <= 0;

        $write("4: ");
            fxptWrite(4, cur_energy_fp);
            $write(" ");
            fxptWrite(4, fp_lin_a - fp_lin_b);
            $display("\n");
    endrule


    interface Put request = toPut(infifo);
    interface Get response = toGet(outfifo);
endmodule


/*
module mkBeatClassifierVarianceOld(BeatClassifier);
    FIFO#(AudioSample) infifo  <- mkFIFO1();
    FIFO#(BeatGuess)   outfifo <- mkFIFO1();

    Reg#(SampleCount) sample_count <- mkReg(0);
    Reg#(Int#(4)) energy_stage <- mkReg(0);

    Reg#(Int#(28)) cur_energy <- mkReg(0);
    Reg#(Int#(56)) cur_square <- mkReg(0);

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
        Int#(14) l = sample.left;
        Int#(14) r = sample.right;

        Int#(28) energy_l = signedMul(l, l);
        Int#(28) energy_r = signedMul(r, r);

        Int#(28) energy = energy_l/2 + energy_r/2;
        
        cur_energy <= cur_energy + energy/fromInteger(sample_count_max+1);
        sample_count <= sample_count + 1;
    endrule
    
    // energy calculations
    rule energy_calc_in (sample_count == fromInteger(sample_count_max) &&
                         energy_stage == 0);

        //Energy   cur_etrunc = unpack( pack(cur_energy)[27:27-valueof(TSub#(VISize,1))] );
        Energy   cur_etrunc = cur_energy;

        // calculate average energy
        avg_energy <= avg_energy - (energy_buf[0]/fromInteger(avg_energy_length))
                                 + (cur_etrunc/fromInteger(avg_energy_length));


        // shift energy buffer
        energy_buf[buf_last_idx] <= cur_etrunc;
        square_buf[buf_last_idx] <= cur_square;

        for (Integer i = 0; i < buf_last_idx; i = i + 1) begin
            energy_buf[i] <= energy_buf[i+1];
            square_buf[i] <= square_buf[i+1];
        end

        energy_stage <= 1;
        cur_energy <= 0;
    endrule

    rule energy_calc_1 (energy_stage == 1);
        SqEnergy c_variance = sqr_energy - signedMul(avg_energy, avg_energy);

        variance <= c_variance;
        energy_stage <= 2;


        $display("1: ", 
                fshow(sqr_energy), " ", 
                fshow(signedMul(avg_energy, avg_energy)), " ", 
                fshow(c_variance)
            );
    endrule

    rule energy_calc_2 (energy_stage == 2);
        // multiply variance term by average energy
        CuEnergy c_lin_b = signedMul(variance, avg_energy);

        lin_b <= c_lin_b;
        energy_stage <= 3;

        $display("2: ", 
                fshow(variance), " ", 
                fshow(avg_energy), " ",
                fshow(c_lin_b)
            );
    endrule

    rule energy_calc_3 (energy_stage == 3);
        // obtain regression coefficients
        LinReg c_fp_lin_a = fromReal(1.5142857) * fromInt(avg_energy);
        LinReg c_fp_lin_b = fromReal(0.0025714) * fromInt(lin_b>>(1*28));

        fp_lin_a <= c_fp_lin_a;
        fp_lin_b <= c_fp_lin_b;
        energy_stage <= 4;

        $write("3: ");
            $write(fshow(lin_b>>(28)));
            $write(" ");
            $write(fshow(lin_b>>(2*28)));
            $write(" ");
            $write(fshow(lin_b>>(3*28)));
            $write(" ");
            fxptWrite(4, c_fp_lin_a);
            $write(" ");
            fxptWrite(4, c_fp_lin_b);
            $display("");
    endrule

    rule energy_calc_4 (energy_stage == 4);
        // obtain coefficients
        LinReg cur_energy_fp = fromInt(energy_buf[buf_last_idx]);

        if (cur_energy_fp > fp_lin_a - fp_lin_b) begin
            Int#(28) y = fromInteger(0);
            BeatGuess x = pack(y);
            outfifo.enq(x);
        end

        energy_stage <= 0;

        // reset sample_count
        sample_count <= 0;

        $write("4: ");
            fxptWrite(4, cur_energy_fp);
            $write(" ");
            fxptWrite(4, fp_lin_a - fp_lin_b);
            $display("\n");
    endrule

    interface Put request = toPut(infifo);
    interface Get response = toGet(outfifo);
endmodule
*/

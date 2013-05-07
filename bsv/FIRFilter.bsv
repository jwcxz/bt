import Types::*;

import ClientServer::*;
import GetPut::*;
import FIFO::*;

import Vector::*;
import FixedPoint::*;

typedef Server#(
    AudioSample,
    AudioSample
) FIRFilter;


module mkFIRFilter #(Vector#(n, FixedPoint#(FIR_ISIZE, FIR_FSIZE)) cf) (FIRFilter);
    
    FIFO#(AudioSample) infifo <- mkFIFO1();
    FIFO#(AudioSample) outfifo <- mkFIFO1();
    
    Integer ntaps = valueof(TSub#(n, 1));
    Vector#(n, Reg#(AudioSample)) prev <- replicateM(mkRegU);

    Vector#(n, Reg#(FixedPoint#(FIR_ISIZE, FIR_FSIZE))) mul_l <- replicateM(mkReg(0));
    Vector#(n, Reg#(FixedPoint#(FIR_ISIZE, FIR_FSIZE))) mul_r <- replicateM(mkReg(0));

    Reg#(UInt#(4)) stage <- mkReg(0);

    Reg#(FixedPoint#(FIR_ISIZE,FIR_FSIZE)) acc_l <- mkReg(0);
    Reg#(FixedPoint#(FIR_ISIZE,FIR_FSIZE)) acc_r <- mkReg(0);

    rule process_in (stage == 0);
        AudioSample sample = infifo.first();
        infifo.deq();

        prev[0] <= sample;
        for (Integer i = 0; i < ntaps-1; i = i+1) begin
            prev[i+1] <= prev[i];
        end

        acc_l <= cf[0] * fromInt(sample.left);
        acc_r <= cf[0] * fromInt(sample.right);

        stage <= 1;
    endrule

    rule process_mul(stage > 0 && stage < fromInteger(ntaps));
        acc_l <= acc_l + cf[stage] * fromInt(prev[stage].left);
        acc_r <= acc_r + cf[stage] * fromInt(prev[stage].right);

        if (stage == fromInteger(ntaps-1)) begin
            stage <= 0;
            AudioSample a = AudioSample{ left: fxptGetInt(acc_l),
                                         right: fxptGetInt(acc_r) };
            outfifo.enq(a);
        end else begin
            stage <= stage + 1;
        end
    endrule
    
    interface Put request = toPut(infifo);
    interface Get response = toGet(outfifo);

endmodule


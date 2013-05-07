import Counter::*;

import ClientServer::*;
import GetPut::*;

import FShow::*;

import Types::*;
import BeatTracker::*;

(* synthesize *)
module mkTestbench(Empty);
    BeatTracker bt <- mkBeatTracker();

    Reg#(File) fr <- mkRegU();
    Reg#(File) fw <- mkRegU();

    Reg#(Bool) init_done <- mkReg(False);
    Reg#(Bool) read_done <- mkReg(False);

    Reg#(Bool) tick <- mkReg(False);
    Reg#(UInt#(10)) tick_count <- mkReg(0);

    rule init(!init_done);
        init_done <= True;

        File t_in <- $fopen("in.dat", "rb");
        if (t_in == InvalidFile) begin
            $display("couldn't open input file");
            $finish;
        end
        fr <= t_in;

        File t_out <- $fopen("out.dat", "wb");
        if (t_out == InvalidFile) begin
            $display("couldn't open output file");
            $finish;
        end
        fw <= t_out;
    endrule

    rule sync(True);
        bt.q_sync();
    endrule

    rule generate_tick(init_done);
        if (tick_count == fromInteger(521)) begin
            tick_count <= 0;
            tick <= True;
        end else begin
            tick_count <= tick_count + 1;
            tick <= False;
        end
    endrule

    rule read(init_done && !read_done && tick);
        int a <- $fgetc(fr);
        int b <- $fgetc(fr);

        if (a == -1 || b == -1) begin
            read_done <= True;
            $fclose(fr);
        end else begin
            Bit#(8) a8 = truncate(pack(a));
            Bit#(8) b8 = truncate(pack(b));

            Bit#(16) c = {a8, b8};
            Bit#(14) d = c[13:0];
            Bit#(28) e = {d, d};

            bt.putSampleInput(unpack(e));
        end
    endrule

    rule write(init_done);
        TopLvlOut dout <- bt.getBeatInfo();
        $fwrite(fw, "%c", dout);
    endrule

    rule finish(read_done);
        $fclose(fw);
        $finish();
    endrule

endmodule

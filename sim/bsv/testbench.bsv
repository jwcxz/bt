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

    rule read(init_done && !read_done);
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

            bt.putSampleInput(unpack(d));
        end
    endrule

    rule write(init_done);
        TopLvlOut dout <- bt.getBeatInfo();

        Bit#(8) a8 = 8'b00000000;
        Bit#(8) b8 = {4'b0000, pack(dout)[19:16]};
        Bit#(8) c8 = pack(dout)[15:8];
        Bit#(8) d8 = pack(dout)[7:0];

        $fwrite(fw, "%c", a8);
        $fwrite(fw, "%c", b8);
        $fwrite(fw, "%c", c8);
        $fwrite(fw, "%c", d8);
    endrule

    rule finish(read_done);
        $fclose(fw);
        $finish();
    endrule

endmodule

//
// Generated by Bluespec Compiler, version 2012.10.beta2 (build 29674, 2012-10.10)
//
// On Thu Apr 25 11:52:51 EDT 2013
//
// Method conflict info:
// Method: q_sync
// Conflict-free: putSampleInput, getBeatInfo
// Conflicts: q_sync
//
// Method: putSampleInput
// Conflict-free: q_sync, getBeatInfo
// Conflicts: putSampleInput
//
// Method: getBeatInfo
// Conflict-free: q_sync, putSampleInput
// Conflicts: getBeatInfo
//
//
// Ports:
// Name                         I/O  size props
// RDY_q_sync                     O     1
// RDY_putSampleInput             O     1 reg
// getBeatInfo                    O     8 reg
// RDY_getBeatInfo                O     1 reg
// CLK                            I     1 clock
// RST_N                          I     1 reset
// putSampleInput_in              I    14 reg
// EN_q_sync                      I     1
// EN_putSampleInput              I     1
// EN_getBeatInfo                 I     1
//
// No combinational paths from inputs to outputs
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
  `define BSV_ASSIGNMENT_DELAY
`endif

`ifdef BSV_POSITIVE_RESET
  `define BSV_RESET_VALUE 1'b1
  `define BSV_RESET_EDGE posedge
`else
  `define BSV_RESET_VALUE 1'b0
  `define BSV_RESET_EDGE negedge
`endif

module mkBeatTracker(CLK,
		     RST_N,

		     EN_q_sync,
		     RDY_q_sync,

		     putSampleInput_in,
		     EN_putSampleInput,
		     RDY_putSampleInput,

		     EN_getBeatInfo,
		     getBeatInfo,
		     RDY_getBeatInfo);
  input  CLK;
  input  RST_N;

  // action method q_sync
  input  EN_q_sync;
  output RDY_q_sync;

  // action method putSampleInput
  input  [13 : 0] putSampleInput_in;
  input  EN_putSampleInput;
  output RDY_putSampleInput;

  // actionvalue method getBeatInfo
  input  EN_getBeatInfo;
  output [7 : 0] getBeatInfo;
  output RDY_getBeatInfo;

  // signals for module outputs
  wire [7 : 0] getBeatInfo;
  wire RDY_getBeatInfo, RDY_putSampleInput, RDY_q_sync;

  // register bc_counter
  reg [19 : 0] bc_counter;
  wire [19 : 0] bc_counter$D_IN;
  wire bc_counter$EN;

  // register bc_increment
  reg [19 : 0] bc_increment;
  wire [19 : 0] bc_increment$D_IN;
  wire bc_increment$EN;

  // register bc_mpc
  reg [10 : 0] bc_mpc;
  wire [10 : 0] bc_mpc$D_IN;
  wire bc_mpc$EN;

  // register bc_tick
  reg bc_tick;
  wire bc_tick$D_IN, bc_tick$EN;

  // register beat_guess
  reg [27 : 0] beat_guess;
  wire [27 : 0] beat_guess$D_IN;
  wire beat_guess$EN;

  // register init_done
  reg init_done;
  wire init_done$D_IN, init_done$EN;

  // register mb_counter
  reg [19 : 0] mb_counter;
  wire [19 : 0] mb_counter$D_IN;
  wire mb_counter$EN;

  // register mb_counter_1
  reg [19 : 0] mb_counter_1;
  wire [19 : 0] mb_counter_1$D_IN;
  wire mb_counter_1$EN;

  // register mb_counter_2
  reg [19 : 0] mb_counter_2;
  wire [19 : 0] mb_counter_2$D_IN;
  wire mb_counter_2$EN;

  // register mb_counter_3
  reg [19 : 0] mb_counter_3;
  wire [19 : 0] mb_counter_3$D_IN;
  wire mb_counter_3$EN;

  // register mb_increment
  reg [19 : 0] mb_increment;
  wire [19 : 0] mb_increment$D_IN;
  wire mb_increment$EN;

  // register mb_increment_1
  reg [19 : 0] mb_increment_1;
  wire [19 : 0] mb_increment_1$D_IN;
  wire mb_increment_1$EN;

  // register mb_increment_2
  reg [19 : 0] mb_increment_2;
  wire [19 : 0] mb_increment_2$D_IN;
  wire mb_increment_2$EN;

  // register mb_increment_3
  reg [19 : 0] mb_increment_3;
  wire [19 : 0] mb_increment_3$D_IN;
  wire mb_increment_3$EN;

  // register mb_last_counter
  reg [19 : 0] mb_last_counter;
  wire [19 : 0] mb_last_counter$D_IN;
  wire mb_last_counter$EN;

  // register mb_last_counter_1
  reg [19 : 0] mb_last_counter_1;
  wire [19 : 0] mb_last_counter_1$D_IN;
  wire mb_last_counter_1$EN;

  // register mb_last_counter_2
  reg [19 : 0] mb_last_counter_2;
  wire [19 : 0] mb_last_counter_2$D_IN;
  wire mb_last_counter_2$EN;

  // register mb_last_counter_3
  reg [19 : 0] mb_last_counter_3;
  wire [19 : 0] mb_last_counter_3$D_IN;
  wire mb_last_counter_3$EN;

  // register mb_out_count
  reg [2 : 0] mb_out_count;
  wire [2 : 0] mb_out_count$D_IN;
  wire mb_out_count$EN;

  // register mb_tick_pulse
  reg mb_tick_pulse;
  wire mb_tick_pulse$D_IN, mb_tick_pulse$EN;

  // register mb_tick_pulse_1
  reg mb_tick_pulse_1;
  wire mb_tick_pulse_1$D_IN, mb_tick_pulse_1$EN;

  // register mb_tick_pulse_2
  reg mb_tick_pulse_2;
  wire mb_tick_pulse_2$D_IN, mb_tick_pulse_2$EN;

  // register mb_tick_pulse_3
  reg mb_tick_pulse_3;
  wire mb_tick_pulse_3$D_IN, mb_tick_pulse_3$EN;

  // register mb_valid
  reg mb_valid;
  wire mb_valid$D_IN, mb_valid$EN;

  // register mb_valid_1
  reg mb_valid_1;
  wire mb_valid_1$D_IN, mb_valid_1$EN;

  // register mb_valid_2
  reg mb_valid_2;
  wire mb_valid_2$D_IN, mb_valid_2$EN;

  // register mb_valid_3
  reg mb_valid_3;
  wire mb_valid_3$D_IN, mb_valid_3$EN;

  // register mpc
  reg [10 : 0] mpc;
  wire [10 : 0] mpc$D_IN;
  wire mpc$EN;

  // register sync_next
  reg sync_next;
  wire sync_next$D_IN, sync_next$EN;

  // register sync_this
  reg sync_this;
  wire sync_this$D_IN, sync_this$EN;

  // ports of submodule bc_infifo
  wire [13 : 0] bc_infifo$D_IN;
  wire bc_infifo$CLR,
       bc_infifo$DEQ,
       bc_infifo$EMPTY_N,
       bc_infifo$ENQ,
       bc_infifo$FULL_N;

  // ports of submodule bc_outfifo
  wire [27 : 0] bc_outfifo$D_IN, bc_outfifo$D_OUT;
  wire bc_outfifo$CLR,
       bc_outfifo$DEQ,
       bc_outfifo$EMPTY_N,
       bc_outfifo$ENQ,
       bc_outfifo$FULL_N;

  // ports of submodule bt_info
  wire [7 : 0] bt_info$D_IN, bt_info$D_OUT;
  wire bt_info$CLR, bt_info$DEQ, bt_info$EMPTY_N, bt_info$ENQ, bt_info$FULL_N;

  // rule scheduling signals
  wire CAN_FIRE_RL_bc_ignore,
       CAN_FIRE_RL_bc_metronome_counter,
       CAN_FIRE_RL_bc_pulser,
       CAN_FIRE_RL_beat_injector_cont,
       CAN_FIRE_RL_beat_injector_start,
       CAN_FIRE_RL_init,
       CAN_FIRE_RL_mb_metronome_counter,
       CAN_FIRE_RL_mb_metronome_counter_1,
       CAN_FIRE_RL_mb_metronome_counter_2,
       CAN_FIRE_RL_mb_metronome_counter_3,
       CAN_FIRE_RL_mb_tick_pulse_off,
       CAN_FIRE_RL_mb_tick_pulse_off_1,
       CAN_FIRE_RL_mb_tick_pulse_off_2,
       CAN_FIRE_RL_mb_tick_pulse_off_3,
       CAN_FIRE_RL_pulser,
       CAN_FIRE_getBeatInfo,
       CAN_FIRE_putSampleInput,
       CAN_FIRE_q_sync,
       WILL_FIRE_RL_bc_ignore,
       WILL_FIRE_RL_bc_metronome_counter,
       WILL_FIRE_RL_bc_pulser,
       WILL_FIRE_RL_beat_injector_cont,
       WILL_FIRE_RL_beat_injector_start,
       WILL_FIRE_RL_init,
       WILL_FIRE_RL_mb_metronome_counter,
       WILL_FIRE_RL_mb_metronome_counter_1,
       WILL_FIRE_RL_mb_metronome_counter_2,
       WILL_FIRE_RL_mb_metronome_counter_3,
       WILL_FIRE_RL_mb_tick_pulse_off,
       WILL_FIRE_RL_mb_tick_pulse_off_1,
       WILL_FIRE_RL_mb_tick_pulse_off_2,
       WILL_FIRE_RL_mb_tick_pulse_off_3,
       WILL_FIRE_RL_pulser,
       WILL_FIRE_getBeatInfo,
       WILL_FIRE_putSampleInput,
       WILL_FIRE_q_sync;

  // inputs to muxes for submodule ports
  wire [19 : 0] MUX_mb_counter$write_1__VAL_2,
		MUX_mb_counter_1$write_1__VAL_2,
		MUX_mb_counter_2$write_1__VAL_2,
		MUX_mb_counter_3$write_1__VAL_2;
  wire [2 : 0] MUX_mb_out_count$write_1__VAL_1;
  wire MUX_mb_counter$write_1__SEL_1,
       MUX_mb_counter_1$write_1__SEL_1,
       MUX_mb_counter_2$write_1__SEL_1,
       MUX_mb_counter_3$write_1__SEL_1,
       MUX_mb_tick_pulse$write_1__SEL_1;

  // remaining internal signals
  reg [19 : 0] IF_mb_out_count_6_EQ_1_8_THEN_mb_last_counter__ETC___d79;
  wire mb_valid_1_9_AND_NOT_mb_tick_pulse_1_0_1_2_AND_ETC___d48;

  // action method q_sync
  assign RDY_q_sync = !sync_next ;
  assign CAN_FIRE_q_sync = !sync_next ;
  assign WILL_FIRE_q_sync = EN_q_sync ;

  // action method putSampleInput
  assign RDY_putSampleInput = bc_infifo$FULL_N ;
  assign CAN_FIRE_putSampleInput = bc_infifo$FULL_N ;
  assign WILL_FIRE_putSampleInput = EN_putSampleInput ;

  // actionvalue method getBeatInfo
  assign getBeatInfo = bt_info$D_OUT ;
  assign RDY_getBeatInfo = bt_info$EMPTY_N ;
  assign CAN_FIRE_getBeatInfo = bt_info$EMPTY_N ;
  assign WILL_FIRE_getBeatInfo = EN_getBeatInfo ;

  // submodule bc_infifo
  FIFO1 #(.width(32'd14), .guarded(32'd1)) bc_infifo(.RST(RST_N),
						     .CLK(CLK),
						     .D_IN(bc_infifo$D_IN),
						     .ENQ(bc_infifo$ENQ),
						     .DEQ(bc_infifo$DEQ),
						     .CLR(bc_infifo$CLR),
						     .D_OUT(),
						     .FULL_N(bc_infifo$FULL_N),
						     .EMPTY_N(bc_infifo$EMPTY_N));

  // submodule bc_outfifo
  FIFO1 #(.width(32'd28), .guarded(32'd1)) bc_outfifo(.RST(RST_N),
						      .CLK(CLK),
						      .D_IN(bc_outfifo$D_IN),
						      .ENQ(bc_outfifo$ENQ),
						      .DEQ(bc_outfifo$DEQ),
						      .CLR(bc_outfifo$CLR),
						      .D_OUT(bc_outfifo$D_OUT),
						      .FULL_N(bc_outfifo$FULL_N),
						      .EMPTY_N(bc_outfifo$EMPTY_N));

  // submodule bt_info
  SizedFIFO #(.p1width(32'd8),
	      .p2depth(32'd4),
	      .p3cntr_width(32'd2),
	      .guarded(32'd1)) bt_info(.RST(RST_N),
				       .CLK(CLK),
				       .D_IN(bt_info$D_IN),
				       .ENQ(bt_info$ENQ),
				       .DEQ(bt_info$DEQ),
				       .CLR(bt_info$CLR),
				       .D_OUT(bt_info$D_OUT),
				       .FULL_N(bt_info$FULL_N),
				       .EMPTY_N(bt_info$EMPTY_N));

  // rule RL_pulser
  assign CAN_FIRE_RL_pulser =
	     mb_valid && !mb_tick_pulse &&
	     mb_valid_1_9_AND_NOT_mb_tick_pulse_1_0_1_2_AND_ETC___d48 &&
	     init_done ;
  assign WILL_FIRE_RL_pulser = CAN_FIRE_RL_pulser ;

  // rule RL_beat_injector_start
  assign CAN_FIRE_RL_beat_injector_start =
	     bc_outfifo$EMPTY_N && init_done && mb_out_count == 3'd0 ;
  assign WILL_FIRE_RL_beat_injector_start =
	     CAN_FIRE_RL_beat_injector_start && !EN_q_sync ;

  // rule RL_beat_injector_cont
  assign CAN_FIRE_RL_beat_injector_cont =
	     bt_info$FULL_N && init_done && mb_out_count != 3'd0 &&
	     mb_out_count <= 3'd4 ;
  assign WILL_FIRE_RL_beat_injector_cont = CAN_FIRE_RL_beat_injector_cont ;

  // rule RL_bc_ignore
  assign CAN_FIRE_RL_bc_ignore = bc_infifo$EMPTY_N ;
  assign WILL_FIRE_RL_bc_ignore = bc_infifo$EMPTY_N ;

  // rule RL_bc_metronome_counter
  assign CAN_FIRE_RL_bc_metronome_counter = bc_outfifo$FULL_N && bc_tick ;
  assign WILL_FIRE_RL_bc_metronome_counter =
	     CAN_FIRE_RL_bc_metronome_counter ;

  // rule RL_bc_pulser
  assign CAN_FIRE_RL_bc_pulser = 1'd1 ;
  assign WILL_FIRE_RL_bc_pulser = 1'd1 ;

  // rule RL_mb_metronome_counter
  assign CAN_FIRE_RL_mb_metronome_counter = mb_valid && mb_tick_pulse ;
  assign WILL_FIRE_RL_mb_metronome_counter =
	     CAN_FIRE_RL_mb_metronome_counter &&
	     !WILL_FIRE_RL_beat_injector_cont ;

  // rule RL_mb_tick_pulse_off
  assign CAN_FIRE_RL_mb_tick_pulse_off = CAN_FIRE_RL_mb_metronome_counter ;
  assign WILL_FIRE_RL_mb_tick_pulse_off = CAN_FIRE_RL_mb_metronome_counter ;

  // rule RL_mb_metronome_counter_1
  assign CAN_FIRE_RL_mb_metronome_counter_1 =
	     CAN_FIRE_RL_mb_tick_pulse_off_1 ;
  assign WILL_FIRE_RL_mb_metronome_counter_1 =
	     CAN_FIRE_RL_mb_metronome_counter_1 &&
	     !WILL_FIRE_RL_beat_injector_cont ;

  // rule RL_mb_tick_pulse_off_1
  assign CAN_FIRE_RL_mb_tick_pulse_off_1 = mb_valid_1 && mb_tick_pulse_1 ;
  assign WILL_FIRE_RL_mb_tick_pulse_off_1 = CAN_FIRE_RL_mb_tick_pulse_off_1 ;

  // rule RL_mb_metronome_counter_2
  assign CAN_FIRE_RL_mb_metronome_counter_2 = mb_valid_2 && mb_tick_pulse_2 ;
  assign WILL_FIRE_RL_mb_metronome_counter_2 =
	     CAN_FIRE_RL_mb_metronome_counter_2 &&
	     !WILL_FIRE_RL_beat_injector_cont ;

  // rule RL_mb_tick_pulse_off_2
  assign CAN_FIRE_RL_mb_tick_pulse_off_2 =
	     CAN_FIRE_RL_mb_metronome_counter_2 ;
  assign WILL_FIRE_RL_mb_tick_pulse_off_2 =
	     CAN_FIRE_RL_mb_metronome_counter_2 ;

  // rule RL_mb_metronome_counter_3
  assign CAN_FIRE_RL_mb_metronome_counter_3 = mb_valid_3 && mb_tick_pulse_3 ;
  assign WILL_FIRE_RL_mb_metronome_counter_3 =
	     CAN_FIRE_RL_mb_metronome_counter_3 &&
	     !WILL_FIRE_RL_beat_injector_cont ;

  // rule RL_mb_tick_pulse_off_3
  assign CAN_FIRE_RL_mb_tick_pulse_off_3 =
	     CAN_FIRE_RL_mb_metronome_counter_3 ;
  assign WILL_FIRE_RL_mb_tick_pulse_off_3 =
	     CAN_FIRE_RL_mb_metronome_counter_3 ;

  // rule RL_init
  assign CAN_FIRE_RL_init = !init_done ;
  assign WILL_FIRE_RL_init = CAN_FIRE_RL_init ;

  // inputs to muxes for submodule ports
  assign MUX_mb_counter$write_1__SEL_1 =
	     WILL_FIRE_RL_beat_injector_cont && mb_out_count == 3'd1 ;
  assign MUX_mb_counter_1$write_1__SEL_1 =
	     WILL_FIRE_RL_beat_injector_cont && mb_out_count == 3'd2 ;
  assign MUX_mb_counter_2$write_1__SEL_1 =
	     WILL_FIRE_RL_beat_injector_cont && mb_out_count == 3'd3 ;
  assign MUX_mb_counter_3$write_1__SEL_1 =
	     WILL_FIRE_RL_beat_injector_cont && mb_out_count == 3'd4 ;
  assign MUX_mb_tick_pulse$write_1__SEL_1 =
	     WILL_FIRE_RL_pulser && mpc == 11'd2047 ;
  assign MUX_mb_counter$write_1__VAL_2 = mb_counter + mb_increment ;
  assign MUX_mb_counter_1$write_1__VAL_2 = mb_counter_1 + mb_increment_1 ;
  assign MUX_mb_counter_2$write_1__VAL_2 = mb_counter_2 + mb_increment_2 ;
  assign MUX_mb_counter_3$write_1__VAL_2 = mb_counter_3 + mb_increment_3 ;
  assign MUX_mb_out_count$write_1__VAL_1 =
	     (mb_out_count == 3'd4) ? 3'd0 : mb_out_count + 3'd1 ;

  // register bc_counter
  assign bc_counter$D_IN = bc_counter + bc_increment ;
  assign bc_counter$EN = CAN_FIRE_RL_bc_metronome_counter ;

  // register bc_increment
  assign bc_increment$D_IN = 20'h0 ;
  assign bc_increment$EN = 1'b0 ;

  // register bc_mpc
  assign bc_mpc$D_IN = (bc_mpc == 11'd2047) ? 11'd0 : bc_mpc + 11'd1 ;
  assign bc_mpc$EN = 1'd1 ;

  // register bc_tick
  assign bc_tick$D_IN = bc_mpc == 11'd2047 ;
  assign bc_tick$EN = 1'd1 ;

  // register beat_guess
  assign beat_guess$D_IN = bc_outfifo$D_OUT ;
  assign beat_guess$EN = WILL_FIRE_RL_beat_injector_start ;

  // register init_done
  assign init_done$D_IN = 1'd1 ;
  assign init_done$EN = CAN_FIRE_RL_init ;

  // register mb_counter
  assign mb_counter$D_IN =
	     MUX_mb_counter$write_1__SEL_1 ?
	       20'd0 :
	       MUX_mb_counter$write_1__VAL_2 ;
  assign mb_counter$EN =
	     WILL_FIRE_RL_beat_injector_cont && mb_out_count == 3'd1 ||
	     WILL_FIRE_RL_mb_metronome_counter ;

  // register mb_counter_1
  assign mb_counter_1$D_IN =
	     MUX_mb_counter_1$write_1__SEL_1 ?
	       20'd0 :
	       MUX_mb_counter_1$write_1__VAL_2 ;
  assign mb_counter_1$EN =
	     WILL_FIRE_RL_beat_injector_cont && mb_out_count == 3'd2 ||
	     WILL_FIRE_RL_mb_metronome_counter_1 ;

  // register mb_counter_2
  assign mb_counter_2$D_IN =
	     MUX_mb_counter_2$write_1__SEL_1 ?
	       20'd0 :
	       MUX_mb_counter_2$write_1__VAL_2 ;
  assign mb_counter_2$EN =
	     WILL_FIRE_RL_beat_injector_cont && mb_out_count == 3'd3 ||
	     WILL_FIRE_RL_mb_metronome_counter_2 ;

  // register mb_counter_3
  assign mb_counter_3$D_IN =
	     MUX_mb_counter_3$write_1__SEL_1 ?
	       20'd0 :
	       MUX_mb_counter_3$write_1__VAL_2 ;
  assign mb_counter_3$EN =
	     WILL_FIRE_RL_beat_injector_cont && mb_out_count == 3'd4 ||
	     WILL_FIRE_RL_mb_metronome_counter_3 ;

  // register mb_increment
  assign mb_increment$D_IN = 20'd172 ;
  assign mb_increment$EN = CAN_FIRE_RL_init ;

  // register mb_increment_1
  assign mb_increment_1$D_IN = 20'd186 ;
  assign mb_increment_1$EN = CAN_FIRE_RL_init ;

  // register mb_increment_2
  assign mb_increment_2$D_IN = 20'd200 ;
  assign mb_increment_2$EN = CAN_FIRE_RL_init ;

  // register mb_increment_3
  assign mb_increment_3$D_IN = 20'd215 ;
  assign mb_increment_3$EN = CAN_FIRE_RL_init ;

  // register mb_last_counter
  assign mb_last_counter$D_IN = MUX_mb_counter$write_1__VAL_2 ;
  assign mb_last_counter$EN = WILL_FIRE_RL_mb_metronome_counter ;

  // register mb_last_counter_1
  assign mb_last_counter_1$D_IN = MUX_mb_counter_1$write_1__VAL_2 ;
  assign mb_last_counter_1$EN = WILL_FIRE_RL_mb_metronome_counter_1 ;

  // register mb_last_counter_2
  assign mb_last_counter_2$D_IN = MUX_mb_counter_2$write_1__VAL_2 ;
  assign mb_last_counter_2$EN = WILL_FIRE_RL_mb_metronome_counter_2 ;

  // register mb_last_counter_3
  assign mb_last_counter_3$D_IN = MUX_mb_counter_3$write_1__VAL_2 ;
  assign mb_last_counter_3$EN = WILL_FIRE_RL_mb_metronome_counter_3 ;

  // register mb_out_count
  assign mb_out_count$D_IN =
	     WILL_FIRE_RL_beat_injector_cont ?
	       MUX_mb_out_count$write_1__VAL_1 :
	       3'd1 ;
  assign mb_out_count$EN =
	     WILL_FIRE_RL_beat_injector_cont ||
	     WILL_FIRE_RL_beat_injector_start ;

  // register mb_tick_pulse
  assign mb_tick_pulse$D_IN = MUX_mb_tick_pulse$write_1__SEL_1 ;
  assign mb_tick_pulse$EN =
	     WILL_FIRE_RL_pulser && mpc == 11'd2047 ||
	     WILL_FIRE_RL_mb_tick_pulse_off ;

  // register mb_tick_pulse_1
  assign mb_tick_pulse_1$D_IN = MUX_mb_tick_pulse$write_1__SEL_1 ;
  assign mb_tick_pulse_1$EN =
	     WILL_FIRE_RL_pulser && mpc == 11'd2047 ||
	     WILL_FIRE_RL_mb_tick_pulse_off_1 ;

  // register mb_tick_pulse_2
  assign mb_tick_pulse_2$D_IN = MUX_mb_tick_pulse$write_1__SEL_1 ;
  assign mb_tick_pulse_2$EN =
	     WILL_FIRE_RL_pulser && mpc == 11'd2047 ||
	     WILL_FIRE_RL_mb_tick_pulse_off_2 ;

  // register mb_tick_pulse_3
  assign mb_tick_pulse_3$D_IN = MUX_mb_tick_pulse$write_1__SEL_1 ;
  assign mb_tick_pulse_3$EN =
	     WILL_FIRE_RL_pulser && mpc == 11'd2047 ||
	     WILL_FIRE_RL_mb_tick_pulse_off_3 ;

  // register mb_valid
  assign mb_valid$D_IN = 1'd1 ;
  assign mb_valid$EN = CAN_FIRE_RL_init ;

  // register mb_valid_1
  assign mb_valid_1$D_IN = 1'd1 ;
  assign mb_valid_1$EN = CAN_FIRE_RL_init ;

  // register mb_valid_2
  assign mb_valid_2$D_IN = 1'd1 ;
  assign mb_valid_2$EN = CAN_FIRE_RL_init ;

  // register mb_valid_3
  assign mb_valid_3$D_IN = 1'd1 ;
  assign mb_valid_3$EN = CAN_FIRE_RL_init ;

  // register mpc
  assign mpc$D_IN = (mpc == 11'd2047) ? 11'd0 : mpc + 11'd1 ;
  assign mpc$EN = CAN_FIRE_RL_pulser ;

  // register sync_next
  assign sync_next$D_IN = !WILL_FIRE_RL_beat_injector_start ;
  assign sync_next$EN = WILL_FIRE_RL_beat_injector_start || EN_q_sync ;

  // register sync_this
  assign sync_this$D_IN = sync_next ;
  assign sync_this$EN = WILL_FIRE_RL_beat_injector_start ;

  // submodule bc_infifo
  assign bc_infifo$D_IN = putSampleInput_in ;
  assign bc_infifo$ENQ = EN_putSampleInput ;
  assign bc_infifo$DEQ = bc_infifo$EMPTY_N ;
  assign bc_infifo$CLR = 1'b0 ;

  // submodule bc_outfifo
  assign bc_outfifo$D_IN = 28'd0 ;
  assign bc_outfifo$ENQ =
	     WILL_FIRE_RL_bc_metronome_counter &&
	     bc_counter + bc_increment < bc_counter ;
  assign bc_outfifo$DEQ = WILL_FIRE_RL_beat_injector_start ;
  assign bc_outfifo$CLR = 1'b0 ;

  // submodule bt_info
  assign bt_info$D_IN =
	     IF_mb_out_count_6_EQ_1_8_THEN_mb_last_counter__ETC___d79[19:12] ;
  assign bt_info$ENQ = CAN_FIRE_RL_beat_injector_cont ;
  assign bt_info$DEQ = EN_getBeatInfo ;
  assign bt_info$CLR = 1'b0 ;

  // remaining internal signals
  assign mb_valid_1_9_AND_NOT_mb_tick_pulse_1_0_1_2_AND_ETC___d48 =
	     mb_valid_1 && !mb_tick_pulse_1 && mb_valid_2 &&
	     !mb_tick_pulse_2 &&
	     mb_valid_3 &&
	     !mb_tick_pulse_3 ;
  always@(mb_out_count or
	  mb_last_counter_3 or
	  mb_last_counter or mb_last_counter_1 or mb_last_counter_2)
  begin
    case (mb_out_count)
      3'd1:
	  IF_mb_out_count_6_EQ_1_8_THEN_mb_last_counter__ETC___d79 =
	      mb_last_counter;
      3'd2:
	  IF_mb_out_count_6_EQ_1_8_THEN_mb_last_counter__ETC___d79 =
	      mb_last_counter_1;
      3'd3:
	  IF_mb_out_count_6_EQ_1_8_THEN_mb_last_counter__ETC___d79 =
	      mb_last_counter_2;
      default: IF_mb_out_count_6_EQ_1_8_THEN_mb_last_counter__ETC___d79 =
		   mb_last_counter_3;
    endcase
  end

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        bc_counter <= `BSV_ASSIGNMENT_DELAY 20'd0;
	bc_increment <= `BSV_ASSIGNMENT_DELAY 20'd172;
	bc_mpc <= `BSV_ASSIGNMENT_DELAY 11'd0;
	bc_tick <= `BSV_ASSIGNMENT_DELAY 1'd0;
	beat_guess <= `BSV_ASSIGNMENT_DELAY 28'd0;
	init_done <= `BSV_ASSIGNMENT_DELAY 1'd0;
	mb_counter <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_counter_1 <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_counter_2 <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_counter_3 <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_increment <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_increment_1 <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_increment_2 <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_increment_3 <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_last_counter <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_last_counter_1 <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_last_counter_2 <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_last_counter_3 <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_out_count <= `BSV_ASSIGNMENT_DELAY 3'd0;
	mb_tick_pulse <= `BSV_ASSIGNMENT_DELAY 1'd0;
	mb_tick_pulse_1 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	mb_tick_pulse_2 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	mb_tick_pulse_3 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	mb_valid <= `BSV_ASSIGNMENT_DELAY 1'd0;
	mb_valid_1 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	mb_valid_2 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	mb_valid_3 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	mpc <= `BSV_ASSIGNMENT_DELAY 11'd0;
	sync_next <= `BSV_ASSIGNMENT_DELAY 1'd0;
	sync_this <= `BSV_ASSIGNMENT_DELAY 1'd0;
      end
    else
      begin
        if (bc_counter$EN)
	  bc_counter <= `BSV_ASSIGNMENT_DELAY bc_counter$D_IN;
	if (bc_increment$EN)
	  bc_increment <= `BSV_ASSIGNMENT_DELAY bc_increment$D_IN;
	if (bc_mpc$EN) bc_mpc <= `BSV_ASSIGNMENT_DELAY bc_mpc$D_IN;
	if (bc_tick$EN) bc_tick <= `BSV_ASSIGNMENT_DELAY bc_tick$D_IN;
	if (beat_guess$EN)
	  beat_guess <= `BSV_ASSIGNMENT_DELAY beat_guess$D_IN;
	if (init_done$EN) init_done <= `BSV_ASSIGNMENT_DELAY init_done$D_IN;
	if (mb_counter$EN)
	  mb_counter <= `BSV_ASSIGNMENT_DELAY mb_counter$D_IN;
	if (mb_counter_1$EN)
	  mb_counter_1 <= `BSV_ASSIGNMENT_DELAY mb_counter_1$D_IN;
	if (mb_counter_2$EN)
	  mb_counter_2 <= `BSV_ASSIGNMENT_DELAY mb_counter_2$D_IN;
	if (mb_counter_3$EN)
	  mb_counter_3 <= `BSV_ASSIGNMENT_DELAY mb_counter_3$D_IN;
	if (mb_increment$EN)
	  mb_increment <= `BSV_ASSIGNMENT_DELAY mb_increment$D_IN;
	if (mb_increment_1$EN)
	  mb_increment_1 <= `BSV_ASSIGNMENT_DELAY mb_increment_1$D_IN;
	if (mb_increment_2$EN)
	  mb_increment_2 <= `BSV_ASSIGNMENT_DELAY mb_increment_2$D_IN;
	if (mb_increment_3$EN)
	  mb_increment_3 <= `BSV_ASSIGNMENT_DELAY mb_increment_3$D_IN;
	if (mb_last_counter$EN)
	  mb_last_counter <= `BSV_ASSIGNMENT_DELAY mb_last_counter$D_IN;
	if (mb_last_counter_1$EN)
	  mb_last_counter_1 <= `BSV_ASSIGNMENT_DELAY mb_last_counter_1$D_IN;
	if (mb_last_counter_2$EN)
	  mb_last_counter_2 <= `BSV_ASSIGNMENT_DELAY mb_last_counter_2$D_IN;
	if (mb_last_counter_3$EN)
	  mb_last_counter_3 <= `BSV_ASSIGNMENT_DELAY mb_last_counter_3$D_IN;
	if (mb_out_count$EN)
	  mb_out_count <= `BSV_ASSIGNMENT_DELAY mb_out_count$D_IN;
	if (mb_tick_pulse$EN)
	  mb_tick_pulse <= `BSV_ASSIGNMENT_DELAY mb_tick_pulse$D_IN;
	if (mb_tick_pulse_1$EN)
	  mb_tick_pulse_1 <= `BSV_ASSIGNMENT_DELAY mb_tick_pulse_1$D_IN;
	if (mb_tick_pulse_2$EN)
	  mb_tick_pulse_2 <= `BSV_ASSIGNMENT_DELAY mb_tick_pulse_2$D_IN;
	if (mb_tick_pulse_3$EN)
	  mb_tick_pulse_3 <= `BSV_ASSIGNMENT_DELAY mb_tick_pulse_3$D_IN;
	if (mb_valid$EN) mb_valid <= `BSV_ASSIGNMENT_DELAY mb_valid$D_IN;
	if (mb_valid_1$EN)
	  mb_valid_1 <= `BSV_ASSIGNMENT_DELAY mb_valid_1$D_IN;
	if (mb_valid_2$EN)
	  mb_valid_2 <= `BSV_ASSIGNMENT_DELAY mb_valid_2$D_IN;
	if (mb_valid_3$EN)
	  mb_valid_3 <= `BSV_ASSIGNMENT_DELAY mb_valid_3$D_IN;
	if (mpc$EN) mpc <= `BSV_ASSIGNMENT_DELAY mpc$D_IN;
	if (sync_next$EN) sync_next <= `BSV_ASSIGNMENT_DELAY sync_next$D_IN;
	if (sync_this$EN) sync_this <= `BSV_ASSIGNMENT_DELAY sync_this$D_IN;
      end
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    bc_counter = 20'hAAAAA;
    bc_increment = 20'hAAAAA;
    bc_mpc = 11'h2AA;
    bc_tick = 1'h0;
    beat_guess = 28'hAAAAAAA;
    init_done = 1'h0;
    mb_counter = 20'hAAAAA;
    mb_counter_1 = 20'hAAAAA;
    mb_counter_2 = 20'hAAAAA;
    mb_counter_3 = 20'hAAAAA;
    mb_increment = 20'hAAAAA;
    mb_increment_1 = 20'hAAAAA;
    mb_increment_2 = 20'hAAAAA;
    mb_increment_3 = 20'hAAAAA;
    mb_last_counter = 20'hAAAAA;
    mb_last_counter_1 = 20'hAAAAA;
    mb_last_counter_2 = 20'hAAAAA;
    mb_last_counter_3 = 20'hAAAAA;
    mb_out_count = 3'h2;
    mb_tick_pulse = 1'h0;
    mb_tick_pulse_1 = 1'h0;
    mb_tick_pulse_2 = 1'h0;
    mb_tick_pulse_3 = 1'h0;
    mb_valid = 1'h0;
    mb_valid_1 = 1'h0;
    mb_valid_2 = 1'h0;
    mb_valid_3 = 1'h0;
    mpc = 11'h2AA;
    sync_next = 1'h0;
    sync_this = 1'h0;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on
endmodule  // mkBeatTracker


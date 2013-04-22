//
// Generated by Bluespec Compiler, version 2012.10.beta2 (build 29674, 2012-10.10)
//
// On Sun Apr 21 19:39:28 EDT 2013
//
// Method conflict info:
// Method: putSampleInput
// Conflict-free: getBeatInfo
// Conflicts: putSampleInput
//
// Method: getBeatInfo
// Conflict-free: putSampleInput
// Conflicts: getBeatInfo
//
//
// Ports:
// Name                         I/O  size props
// RDY_putSampleInput             O     1 reg
// getBeatInfo                    O    20 reg
// RDY_getBeatInfo                O     1 reg
// CLK                            I     1 clock
// RST_N                          I     1 reset
// putSampleInput_in              I    14 reg
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

		     putSampleInput_in,
		     EN_putSampleInput,
		     RDY_putSampleInput,

		     EN_getBeatInfo,
		     getBeatInfo,
		     RDY_getBeatInfo);
  input  CLK;
  input  RST_N;

  // action method putSampleInput
  input  [13 : 0] putSampleInput_in;
  input  EN_putSampleInput;
  output RDY_putSampleInput;

  // actionvalue method getBeatInfo
  input  EN_getBeatInfo;
  output [19 : 0] getBeatInfo;
  output RDY_getBeatInfo;

  // signals for module outputs
  wire [19 : 0] getBeatInfo;
  wire RDY_getBeatInfo, RDY_putSampleInput;

  // register bc_avg_energy
  reg [27 : 0] bc_avg_energy;
  wire [27 : 0] bc_avg_energy$D_IN;
  wire bc_avg_energy$EN;

  // register bc_cur_energy
  reg [27 : 0] bc_cur_energy;
  wire [27 : 0] bc_cur_energy$D_IN;
  wire bc_cur_energy$EN;

  // register bc_sample_count
  reg [11 : 0] bc_sample_count;
  wire [11 : 0] bc_sample_count$D_IN;
  wire bc_sample_count$EN;

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
  reg [11 : 0] mpc;
  wire [11 : 0] mpc$D_IN;
  wire mpc$EN;

  // ports of submodule bc_infifo
  wire [13 : 0] bc_infifo$D_IN, bc_infifo$D_OUT;
  wire bc_infifo$CLR,
       bc_infifo$DEQ,
       bc_infifo$EMPTY_N,
       bc_infifo$ENQ,
       bc_infifo$FULL_N;

  // ports of submodule bc_outfifo
  wire [27 : 0] bc_outfifo$D_IN;
  wire bc_outfifo$CLR,
       bc_outfifo$DEQ,
       bc_outfifo$EMPTY_N,
       bc_outfifo$ENQ,
       bc_outfifo$FULL_N;

  // ports of submodule bt_info
  wire [19 : 0] bt_info$D_IN, bt_info$D_OUT;
  wire bt_info$CLR, bt_info$DEQ, bt_info$EMPTY_N, bt_info$ENQ, bt_info$FULL_N;

  // rule scheduling signals
  wire CAN_FIRE_RL_bc_compare_energies,
       CAN_FIRE_RL_bc_inject_sample,
       CAN_FIRE_RL_beat_injector,
       CAN_FIRE_RL_init,
       CAN_FIRE_RL_mb_metronome_counter,
       CAN_FIRE_RL_mb_metronome_counter_1,
       CAN_FIRE_RL_mb_metronome_counter_2,
       CAN_FIRE_RL_mb_metronome_counter_3,
       CAN_FIRE_RL_mb_tick_pulse_off,
       CAN_FIRE_RL_mb_tick_pulse_off_1,
       CAN_FIRE_RL_mb_tick_pulse_off_2,
       CAN_FIRE_RL_mb_tick_pulse_off_3,
       CAN_FIRE_RL_metronome_pulser,
       CAN_FIRE_getBeatInfo,
       CAN_FIRE_putSampleInput,
       WILL_FIRE_RL_bc_compare_energies,
       WILL_FIRE_RL_bc_inject_sample,
       WILL_FIRE_RL_beat_injector,
       WILL_FIRE_RL_init,
       WILL_FIRE_RL_mb_metronome_counter,
       WILL_FIRE_RL_mb_metronome_counter_1,
       WILL_FIRE_RL_mb_metronome_counter_2,
       WILL_FIRE_RL_mb_metronome_counter_3,
       WILL_FIRE_RL_mb_tick_pulse_off,
       WILL_FIRE_RL_mb_tick_pulse_off_1,
       WILL_FIRE_RL_mb_tick_pulse_off_2,
       WILL_FIRE_RL_mb_tick_pulse_off_3,
       WILL_FIRE_RL_metronome_pulser,
       WILL_FIRE_getBeatInfo,
       WILL_FIRE_putSampleInput;

  // inputs to muxes for submodule ports
  wire [27 : 0] MUX_bc_cur_energy$write_1__VAL_1;
  wire [19 : 0] MUX_mb_counter$write_1__VAL_1,
		MUX_mb_counter_1$write_1__VAL_2,
		MUX_mb_counter_2$write_1__VAL_2,
		MUX_mb_counter_3$write_1__VAL_2;
  wire [11 : 0] MUX_bc_sample_count$write_1__VAL_1;
  wire MUX_mb_tick_pulse$write_1__SEL_1;

  // remaining internal signals
  wire [55 : 0] SEXT_bc_infifo_first_MUL_SEXT_bc_infifo_first___d87;
  wire [27 : 0] IF_SEXT_bc_infifo_first_MUL_SEXT_bc_infifo_fir_ETC___d89,
		IF_bc_avg_energy_1_BIT_27_2_THEN_NEG_IF_bc_avg_ETC___d86,
		IF_bc_avg_energy_1_BIT_27_2_THEN_NEG_bc_avg_en_ETC___d90,
		IF_bc_cur_energy_BIT_27_3_THEN_NEG_bc_cur_ener_ETC___d91,
		SEXT_bc_infifo_first_____d88;
  wire NOT_bc_cur_energy_SLE_bc_avg_energy_1_PLUS_IF__ETC___d30,
       mb_valid_1_6_AND_NOT_mb_tick_pulse_1_0_8_9_AND_ETC___d75;

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
						     .D_OUT(bc_infifo$D_OUT),
						     .FULL_N(bc_infifo$FULL_N),
						     .EMPTY_N(bc_infifo$EMPTY_N));

  // submodule bc_outfifo
  FIFO1 #(.width(32'd28), .guarded(32'd1)) bc_outfifo(.RST(RST_N),
						      .CLK(CLK),
						      .D_IN(bc_outfifo$D_IN),
						      .ENQ(bc_outfifo$ENQ),
						      .DEQ(bc_outfifo$DEQ),
						      .CLR(bc_outfifo$CLR),
						      .D_OUT(),
						      .FULL_N(bc_outfifo$FULL_N),
						      .EMPTY_N(bc_outfifo$EMPTY_N));

  // submodule bt_info
  FIFO1 #(.width(32'd20), .guarded(32'd1)) bt_info(.RST(RST_N),
						   .CLK(CLK),
						   .D_IN(bt_info$D_IN),
						   .ENQ(bt_info$ENQ),
						   .DEQ(bt_info$DEQ),
						   .CLR(bt_info$CLR),
						   .D_OUT(bt_info$D_OUT),
						   .FULL_N(bt_info$FULL_N),
						   .EMPTY_N(bt_info$EMPTY_N));

  // rule RL_metronome_pulser
  assign CAN_FIRE_RL_metronome_pulser =
	     mb_valid && !mb_tick_pulse &&
	     mb_valid_1_6_AND_NOT_mb_tick_pulse_1_0_8_9_AND_ETC___d75 &&
	     init_done ;
  assign WILL_FIRE_RL_metronome_pulser = CAN_FIRE_RL_metronome_pulser ;

  // rule RL_bc_inject_sample
  assign CAN_FIRE_RL_bc_inject_sample =
	     bc_infifo$EMPTY_N && bc_sample_count != 12'd4095 ;
  assign WILL_FIRE_RL_bc_inject_sample = CAN_FIRE_RL_bc_inject_sample ;

  // rule RL_bc_compare_energies
  assign CAN_FIRE_RL_bc_compare_energies =
	     bc_outfifo$FULL_N && bc_sample_count == 12'd4095 ;
  assign WILL_FIRE_RL_bc_compare_energies = CAN_FIRE_RL_bc_compare_energies ;

  // rule RL_mb_metronome_counter
  assign CAN_FIRE_RL_mb_metronome_counter = mb_valid ;
  assign WILL_FIRE_RL_mb_metronome_counter =
	     mb_valid && !WILL_FIRE_RL_beat_injector ;

  // rule RL_mb_tick_pulse_off
  assign CAN_FIRE_RL_mb_tick_pulse_off = mb_valid && mb_tick_pulse ;
  assign WILL_FIRE_RL_mb_tick_pulse_off = CAN_FIRE_RL_mb_tick_pulse_off ;

  // rule RL_mb_metronome_counter_1
  assign CAN_FIRE_RL_mb_metronome_counter_1 = mb_valid_1 ;
  assign WILL_FIRE_RL_mb_metronome_counter_1 = mb_valid_1 ;

  // rule RL_mb_tick_pulse_off_1
  assign CAN_FIRE_RL_mb_tick_pulse_off_1 = mb_valid_1 && mb_tick_pulse_1 ;
  assign WILL_FIRE_RL_mb_tick_pulse_off_1 = CAN_FIRE_RL_mb_tick_pulse_off_1 ;

  // rule RL_mb_metronome_counter_2
  assign CAN_FIRE_RL_mb_metronome_counter_2 = mb_valid_2 ;
  assign WILL_FIRE_RL_mb_metronome_counter_2 = mb_valid_2 ;

  // rule RL_mb_tick_pulse_off_2
  assign CAN_FIRE_RL_mb_tick_pulse_off_2 = mb_valid_2 && mb_tick_pulse_2 ;
  assign WILL_FIRE_RL_mb_tick_pulse_off_2 = CAN_FIRE_RL_mb_tick_pulse_off_2 ;

  // rule RL_mb_metronome_counter_3
  assign CAN_FIRE_RL_mb_metronome_counter_3 = mb_valid_3 ;
  assign WILL_FIRE_RL_mb_metronome_counter_3 = mb_valid_3 ;

  // rule RL_beat_injector
  assign CAN_FIRE_RL_beat_injector =
	     bc_outfifo$EMPTY_N && bt_info$FULL_N && init_done ;
  assign WILL_FIRE_RL_beat_injector = CAN_FIRE_RL_beat_injector ;

  // rule RL_mb_tick_pulse_off_3
  assign CAN_FIRE_RL_mb_tick_pulse_off_3 = mb_valid_3 && mb_tick_pulse_3 ;
  assign WILL_FIRE_RL_mb_tick_pulse_off_3 = CAN_FIRE_RL_mb_tick_pulse_off_3 ;

  // rule RL_init
  assign CAN_FIRE_RL_init = !init_done ;
  assign WILL_FIRE_RL_init = CAN_FIRE_RL_init ;

  // inputs to muxes for submodule ports
  assign MUX_mb_tick_pulse$write_1__SEL_1 =
	     WILL_FIRE_RL_metronome_pulser && mpc == 12'd4095 ;
  assign MUX_bc_cur_energy$write_1__VAL_1 =
	     bc_cur_energy +
	     (SEXT_bc_infifo_first_MUL_SEXT_bc_infifo_first___d87[27] ?
		-IF_SEXT_bc_infifo_first_MUL_SEXT_bc_infifo_fir_ETC___d89 :
		IF_SEXT_bc_infifo_first_MUL_SEXT_bc_infifo_fir_ETC___d89) ;
  assign MUX_bc_sample_count$write_1__VAL_1 = bc_sample_count + 12'd1 ;
  assign MUX_mb_counter$write_1__VAL_1 = mb_counter + mb_increment ;
  assign MUX_mb_counter_1$write_1__VAL_2 = mb_counter_1 + mb_increment_1 ;
  assign MUX_mb_counter_2$write_1__VAL_2 = mb_counter_2 + mb_increment_2 ;
  assign MUX_mb_counter_3$write_1__VAL_2 = mb_counter_3 + mb_increment_3 ;

  // register bc_avg_energy
  assign bc_avg_energy$D_IN =
	     IF_bc_avg_energy_1_BIT_27_2_THEN_NEG_IF_bc_avg_ETC___d86 +
	     (bc_cur_energy[27] ?
		-IF_bc_cur_energy_BIT_27_3_THEN_NEG_bc_cur_ener_ETC___d91 :
		IF_bc_cur_energy_BIT_27_3_THEN_NEG_bc_cur_ener_ETC___d91) ;
  assign bc_avg_energy$EN = CAN_FIRE_RL_bc_compare_energies ;

  // register bc_cur_energy
  assign bc_cur_energy$D_IN =
	     WILL_FIRE_RL_bc_inject_sample ?
	       MUX_bc_cur_energy$write_1__VAL_1 :
	       28'd0 ;
  assign bc_cur_energy$EN =
	     WILL_FIRE_RL_bc_inject_sample ||
	     WILL_FIRE_RL_bc_compare_energies ;

  // register bc_sample_count
  assign bc_sample_count$D_IN =
	     WILL_FIRE_RL_bc_inject_sample ?
	       MUX_bc_sample_count$write_1__VAL_1 :
	       12'd0 ;
  assign bc_sample_count$EN =
	     WILL_FIRE_RL_bc_inject_sample ||
	     WILL_FIRE_RL_bc_compare_energies ;

  // register init_done
  assign init_done$D_IN = 1'd1 ;
  assign init_done$EN = CAN_FIRE_RL_init ;

  // register mb_counter
  assign mb_counter$D_IN =
	     WILL_FIRE_RL_mb_metronome_counter ?
	       MUX_mb_counter$write_1__VAL_1 :
	       20'd0 ;
  assign mb_counter$EN =
	     WILL_FIRE_RL_mb_metronome_counter || WILL_FIRE_RL_beat_injector ;

  // register mb_counter_1
  assign mb_counter_1$D_IN =
	     WILL_FIRE_RL_beat_injector ?
	       20'd0 :
	       MUX_mb_counter_1$write_1__VAL_2 ;
  assign mb_counter_1$EN = mb_valid_1 || WILL_FIRE_RL_beat_injector ;

  // register mb_counter_2
  assign mb_counter_2$D_IN =
	     WILL_FIRE_RL_beat_injector ?
	       20'd0 :
	       MUX_mb_counter_2$write_1__VAL_2 ;
  assign mb_counter_2$EN = mb_valid_2 || WILL_FIRE_RL_beat_injector ;

  // register mb_counter_3
  assign mb_counter_3$D_IN =
	     WILL_FIRE_RL_beat_injector ?
	       20'd0 :
	       MUX_mb_counter_3$write_1__VAL_2 ;
  assign mb_counter_3$EN = mb_valid_3 || WILL_FIRE_RL_beat_injector ;

  // register mb_increment
  assign mb_increment$D_IN = 20'd172 ;
  assign mb_increment$EN = CAN_FIRE_RL_init ;

  // register mb_increment_1
  assign mb_increment_1$D_IN = 20'd200 ;
  assign mb_increment_1$EN = CAN_FIRE_RL_init ;

  // register mb_increment_2
  assign mb_increment_2$D_IN = 20'd115 ;
  assign mb_increment_2$EN = CAN_FIRE_RL_init ;

  // register mb_increment_3
  assign mb_increment_3$D_IN = 20'd129 ;
  assign mb_increment_3$EN = CAN_FIRE_RL_init ;

  // register mb_tick_pulse
  assign mb_tick_pulse$D_IN = MUX_mb_tick_pulse$write_1__SEL_1 ;
  assign mb_tick_pulse$EN =
	     WILL_FIRE_RL_metronome_pulser && mpc == 12'd4095 ||
	     WILL_FIRE_RL_mb_tick_pulse_off ;

  // register mb_tick_pulse_1
  assign mb_tick_pulse_1$D_IN = MUX_mb_tick_pulse$write_1__SEL_1 ;
  assign mb_tick_pulse_1$EN =
	     WILL_FIRE_RL_metronome_pulser && mpc == 12'd4095 ||
	     WILL_FIRE_RL_mb_tick_pulse_off_1 ;

  // register mb_tick_pulse_2
  assign mb_tick_pulse_2$D_IN = MUX_mb_tick_pulse$write_1__SEL_1 ;
  assign mb_tick_pulse_2$EN =
	     WILL_FIRE_RL_metronome_pulser && mpc == 12'd4095 ||
	     WILL_FIRE_RL_mb_tick_pulse_off_2 ;

  // register mb_tick_pulse_3
  assign mb_tick_pulse_3$D_IN = MUX_mb_tick_pulse$write_1__SEL_1 ;
  assign mb_tick_pulse_3$EN =
	     WILL_FIRE_RL_metronome_pulser && mpc == 12'd4095 ||
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
  assign mpc$D_IN = (mpc == 12'd4095) ? 12'd0 : mpc + 12'd1 ;
  assign mpc$EN = CAN_FIRE_RL_metronome_pulser ;

  // submodule bc_infifo
  assign bc_infifo$D_IN = putSampleInput_in ;
  assign bc_infifo$ENQ = EN_putSampleInput ;
  assign bc_infifo$DEQ = CAN_FIRE_RL_bc_inject_sample ;
  assign bc_infifo$CLR = 1'b0 ;

  // submodule bc_outfifo
  assign bc_outfifo$D_IN = bc_avg_energy ;
  assign bc_outfifo$ENQ =
	     WILL_FIRE_RL_bc_compare_energies &&
	     NOT_bc_cur_energy_SLE_bc_avg_energy_1_PLUS_IF__ETC___d30 ;
  assign bc_outfifo$DEQ = CAN_FIRE_RL_beat_injector ;
  assign bc_outfifo$CLR = 1'b0 ;

  // submodule bt_info
  assign bt_info$D_IN = mb_counter ;
  assign bt_info$ENQ = CAN_FIRE_RL_beat_injector ;
  assign bt_info$DEQ = EN_getBeatInfo ;
  assign bt_info$CLR = 1'b0 ;

  // remaining internal signals
  assign IF_SEXT_bc_infifo_first_MUL_SEXT_bc_infifo_fir_ETC___d89 =
	     (SEXT_bc_infifo_first_MUL_SEXT_bc_infifo_first___d87[27] ?
		-SEXT_bc_infifo_first_MUL_SEXT_bc_infifo_first___d87[27:0] :
		SEXT_bc_infifo_first_MUL_SEXT_bc_infifo_first___d87[27:0]) >>
	     12 ;
  assign IF_bc_avg_energy_1_BIT_27_2_THEN_NEG_IF_bc_avg_ETC___d86 =
	     bc_avg_energy[27] ?
	       -IF_bc_avg_energy_1_BIT_27_2_THEN_NEG_bc_avg_en_ETC___d90 :
	       IF_bc_avg_energy_1_BIT_27_2_THEN_NEG_bc_avg_en_ETC___d90 ;
  assign IF_bc_avg_energy_1_BIT_27_2_THEN_NEG_bc_avg_en_ETC___d90 =
	     (bc_avg_energy[27] ? -bc_avg_energy : bc_avg_energy) >> 1 ;
  assign IF_bc_cur_energy_BIT_27_3_THEN_NEG_bc_cur_ener_ETC___d91 =
	     (bc_cur_energy[27] ? -bc_cur_energy : bc_cur_energy) >> 1 ;
  assign NOT_bc_cur_energy_SLE_bc_avg_energy_1_PLUS_IF__ETC___d30 =
	     (bc_cur_energy ^ 28'h8000000) >
	     (bc_avg_energy +
	      IF_bc_avg_energy_1_BIT_27_2_THEN_NEG_IF_bc_avg_ETC___d86 ^
	      28'h8000000) ;
  assign SEXT_bc_infifo_first_MUL_SEXT_bc_infifo_first___d87 =
	     SEXT_bc_infifo_first_____d88 * SEXT_bc_infifo_first_____d88 ;
  assign SEXT_bc_infifo_first_____d88 =
	     { {14{bc_infifo$D_OUT[13]}}, bc_infifo$D_OUT } ;
  assign mb_valid_1_6_AND_NOT_mb_tick_pulse_1_0_8_9_AND_ETC___d75 =
	     mb_valid_1 && !mb_tick_pulse_1 && mb_valid_2 &&
	     !mb_tick_pulse_2 &&
	     mb_valid_3 &&
	     !mb_tick_pulse_3 ;

  // handling of inlined registers

  always@(posedge CLK)
  begin
    if (RST_N == `BSV_RESET_VALUE)
      begin
        bc_avg_energy <= `BSV_ASSIGNMENT_DELAY 28'd0;
	bc_cur_energy <= `BSV_ASSIGNMENT_DELAY 28'd0;
	bc_sample_count <= `BSV_ASSIGNMENT_DELAY 12'd0;
	init_done <= `BSV_ASSIGNMENT_DELAY 1'd0;
	mb_counter <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_counter_1 <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_counter_2 <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_counter_3 <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_increment <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_increment_1 <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_increment_2 <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_increment_3 <= `BSV_ASSIGNMENT_DELAY 20'd0;
	mb_tick_pulse <= `BSV_ASSIGNMENT_DELAY 1'd0;
	mb_tick_pulse_1 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	mb_tick_pulse_2 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	mb_tick_pulse_3 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	mb_valid <= `BSV_ASSIGNMENT_DELAY 1'd0;
	mb_valid_1 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	mb_valid_2 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	mb_valid_3 <= `BSV_ASSIGNMENT_DELAY 1'd0;
	mpc <= `BSV_ASSIGNMENT_DELAY 12'd0;
      end
    else
      begin
        if (bc_avg_energy$EN)
	  bc_avg_energy <= `BSV_ASSIGNMENT_DELAY bc_avg_energy$D_IN;
	if (bc_cur_energy$EN)
	  bc_cur_energy <= `BSV_ASSIGNMENT_DELAY bc_cur_energy$D_IN;
	if (bc_sample_count$EN)
	  bc_sample_count <= `BSV_ASSIGNMENT_DELAY bc_sample_count$D_IN;
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
      end
  end

  // synopsys translate_off
  `ifdef BSV_NO_INITIAL_BLOCKS
  `else // not BSV_NO_INITIAL_BLOCKS
  initial
  begin
    bc_avg_energy = 28'hAAAAAAA;
    bc_cur_energy = 28'hAAAAAAA;
    bc_sample_count = 12'hAAA;
    init_done = 1'h0;
    mb_counter = 20'hAAAAA;
    mb_counter_1 = 20'hAAAAA;
    mb_counter_2 = 20'hAAAAA;
    mb_counter_3 = 20'hAAAAA;
    mb_increment = 20'hAAAAA;
    mb_increment_1 = 20'hAAAAA;
    mb_increment_2 = 20'hAAAAA;
    mb_increment_3 = 20'hAAAAA;
    mb_tick_pulse = 1'h0;
    mb_tick_pulse_1 = 1'h0;
    mb_tick_pulse_2 = 1'h0;
    mb_tick_pulse_3 = 1'h0;
    mb_valid = 1'h0;
    mb_valid_1 = 1'h0;
    mb_valid_2 = 1'h0;
    mb_valid_3 = 1'h0;
    mpc = 12'hAAA;
  end
  `endif // BSV_NO_INITIAL_BLOCKS
  // synopsys translate_on

  // handling of system tasks

  // synopsys translate_off
  always@(negedge CLK)
  begin
    #0;
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_bc_compare_energies &&
	  NOT_bc_cur_energy_SLE_bc_avg_energy_1_PLUS_IF__ETC___d30)
	$write("UNS ");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_bc_compare_energies &&
	  NOT_bc_cur_energy_SLE_bc_avg_energy_1_PLUS_IF__ETC___d30)
	$write("%d", $signed(bc_cur_energy));
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_bc_compare_energies &&
	  NOT_bc_cur_energy_SLE_bc_avg_energy_1_PLUS_IF__ETC___d30)
	$write("/");
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_bc_compare_energies &&
	  NOT_bc_cur_energy_SLE_bc_avg_energy_1_PLUS_IF__ETC___d30)
	$write("%d", $signed(bc_avg_energy));
    if (RST_N != `BSV_RESET_VALUE)
      if (WILL_FIRE_RL_bc_compare_energies &&
	  NOT_bc_cur_energy_SLE_bc_avg_energy_1_PLUS_IF__ETC___d30)
	$write("\n");
  end
  // synopsys translate_on
endmodule  // mkBeatTracker


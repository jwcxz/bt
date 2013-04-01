EESchema Schematic File Version 2  date Sun 31 Mar 2013 04:11:51 PM EDT
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:special
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:audioin-cache
EELAYER 25  0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date "18 mar 2013"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L CONN_6 P2
U 1 1 51477027
P 9250 1850
F 0 "P2" V 9200 1850 60  0000 C CNN
F 1 "ADC" V 9300 1850 60  0000 C CNN
	1    9250 1850
	1    0    0    -1  
$EndComp
Text Label 8850 1600 2    60   ~ 0
DAC_REF_AB
Text Label 8850 1700 2    60   ~ 0
DAC_REF_CD
Text Label 8850 1800 2    60   ~ 0
VINA
Text Label 8850 1900 2    60   ~ 0
VINB
$Comp
L VCC #PWR?
U 1 1 51477AA8
P 8800 2150
F 0 "#PWR?" H 8800 2250 30  0001 C CNN
F 1 "VCC" H 8800 2250 30  0000 C CNN
	1    8800 2150
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 51477AB7
P 8650 2100
F 0 "#PWR?" H 8650 2100 30  0001 C CNN
F 1 "GND" H 8650 2030 30  0001 C CNN
	1    8650 2100
	1    0    0    -1  
$EndComp
NoConn ~ 8250 1700
NoConn ~ 8250 1600
$Comp
L CONN_3 P1
U 1 1 51477F48
P 6550 1800
F 0 "P1" V 6500 1800 50  0000 C CNN
F 1 "AUDIO" V 6600 1800 40  0000 C CNN
	1    6550 1800
	-1   0    0    -1  
$EndComp
$Comp
L R R3
U 1 1 5147914F
P 8150 2400
F 0 "R3" V 8250 2400 50  0000 C CNN
F 1 "47K" V 8150 2400 50  0000 C CNN
	1    8150 2400
	1    0    0    -1  
$EndComp
$Comp
L R R4
U 1 1 51479168
P 8150 3000
F 0 "R4" V 8250 3000 50  0000 C CNN
F 1 "47K" V 8150 3000 50  0000 C CNN
	1    8150 3000
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR?
U 1 1 51479177
P 8150 2100
F 0 "#PWR?" H 8150 2200 30  0001 C CNN
F 1 "VCC" H 8150 2200 30  0000 C CNN
	1    8150 2100
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 514791C4
P 8150 3350
F 0 "#PWR?" H 8150 3350 30  0001 C CNN
F 1 "GND" H 8150 3280 30  0001 C CNN
	1    8150 3350
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 51479270
P 7400 1700
F 0 "C1" V 7450 1750 50  0000 L CNN
F 1 "1u" V 7450 1550 50  0000 L CNN
	1    7400 1700
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR?
U 1 1 5147931C
P 7050 1700
F 0 "#PWR?" H 7050 1700 30  0001 C CNN
F 1 "GND" H 7050 1630 30  0001 C CNN
	1    7050 1700
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 5147934E
P 7700 2350
F 0 "R1" V 7780 2350 50  0000 C CNN
F 1 "100K" V 7700 2350 50  0000 C CNN
	1    7700 2350
	1    0    0    -1  
$EndComp
$Comp
L R R2
U 1 1 514793DC
P 7900 2350
F 0 "R2" V 8000 2350 50  0000 C CNN
F 1 "100K" V 7900 2350 50  0000 C CNN
	1    7900 2350
	1    0    0    -1  
$EndComp
$Comp
L C C2
U 1 1 51479570
P 7400 2000
F 0 "C2" V 7450 2050 50  0000 L CNN
F 1 "1u" V 7450 1850 50  0000 L CNN
	1    7400 2000
	0    -1   -1   0   
$EndComp
$Comp
L C C3
U 1 1 5147957D
P 7900 3000
F 0 "C3" H 7950 3100 50  0000 L CNN
F 1 "1u" H 7950 2900 50  0000 L CNN
	1    7900 3000
	1    0    0    -1  
$EndComp
Connection ~ 8150 3300
Wire Wire Line
	7900 3300 8150 3300
Wire Wire Line
	7900 3200 7900 3300
Wire Wire Line
	8150 3250 8150 3350
Connection ~ 7900 2700
Wire Wire Line
	7900 2600 7900 2800
Connection ~ 8150 2700
Wire Wire Line
	7700 2700 8150 2700
Wire Wire Line
	7700 2600 7700 2700
Connection ~ 7900 2000
Connection ~ 7900 2000
Wire Wire Line
	7900 2000 7900 2100
Wire Wire Line
	8050 2000 8050 1900
Wire Wire Line
	7600 2000 8050 2000
Connection ~ 7700 1700
Connection ~ 7700 1700
Wire Wire Line
	7700 1700 7700 2100
Wire Wire Line
	8050 1700 8050 1800
Wire Wire Line
	7600 1700 8050 1700
Wire Wire Line
	6900 1600 6900 1700
Wire Wire Line
	7050 1600 6900 1600
Wire Wire Line
	7050 1700 7050 1600
Wire Wire Line
	7200 1900 7200 2000
Wire Wire Line
	6900 1900 7200 1900
Wire Wire Line
	7200 1800 7200 1700
Wire Wire Line
	6900 1800 7200 1800
Wire Wire Line
	8650 2000 8900 2000
Wire Wire Line
	8650 2100 8650 2000
Wire Wire Line
	8900 2200 8900 2100
Wire Wire Line
	8800 2200 8900 2200
Wire Wire Line
	8800 2150 8800 2200
Wire Wire Line
	8150 2150 8150 2100
Wire Wire Line
	8150 2650 8150 2750
Wire Wire Line
	8250 1600 8900 1600
Wire Wire Line
	8250 1700 8900 1700
Wire Wire Line
	8900 1800 8050 1800
Wire Wire Line
	8900 1900 8050 1900
$EndSCHEMATC

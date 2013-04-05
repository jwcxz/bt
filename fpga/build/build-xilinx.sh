#!/bin/bash

set -o pipefail

basedir="`realpath $(dirname \"$0\")/..`"

starttime=`date`
startsecs=`date +"%s"`

# router effort level
OL=high

printsep () {
    echo ""
    for i in `seq $(stty size | cut -d' ' -f2)`; do echo -n "#"; done
    echo "$1"
    for i in `seq $(stty size | cut -d' ' -f2)`; do echo -n "#"; done
    echo ""
}

printsep BUILD SCRIPT
echo "basedir: $basedir"
#echo "Press enter to begin"
#read

cd $basedir

. ./build/license.sh

########################################################
printsep SETUP

mkdir -p xil/{bitgen,map,ngdbuild,par,reports,trce,xst}
mkdir -p xil/xst/tmp
mkdir -p xil/reports/{bitgen,coregen,impact,map,ngdbuild,par,psm,trce,xmsgs,xst}
mkdir -p fw/gen


########################################################
printsep "Loading Xilinx Environment"
. /opt/Xilinx/13.2/ISE_DS/settings64.sh /opt/Xilinx/13.2/ISE_DS


########################################################
printsep XST

xst -intstyle xflow \
    -ifn "build/project.xst" \
    -ofn "xil/reports/xst/project.syr" \
    | tee xil/reports/xst/cmd.log || exit 1


########################################################
printsep NGDBUILD

ngdbuild -intstyle xflow \
        -aul \
        -aut \
        -dd xil/ngdbuild/tmp \
        -nt timestamp \
        -uc build/constraints.ucf \
        -sd "hdl/ext" \
        -sd "hdl/pkg" \
        -sd "hdl/cs" \
        xil/xst/project.ngc \
        xil/ngdbuild/project.ngd \
        | tee xil/reports/ngdbuild/cmd.log || exit 1

    # copy build log
    cp xil/ngdbuild/project.bld xil/reports/ngdbuild


########################################################
printsep MAP

map -intstyle xflow \
    -detail \
    -w \
    -logic_opt off \
    -ol $OL \
    -t 1 \
    -register_duplication off \
    -r 4 \
    -global_opt off \
    -ir off \
    -pr b \
    -timing \
    -o xil/map/project_map.ncd \
    xil/ngdbuild/project.ngd \
    xil/map/project.pcf \
    | tee xil/reports/map/cmd.log || exit 1


# copy build log
cp xil/map/project_map.mrp xil/reports/map

# move xrpt
mv project_map.xrpt xil/map/


########################################################
printsep PAR

par -intstyle xflow \
    -w \
    -ol $OL \
    xil/map/project_map.ncd \
    xil/par/project.ncd \
    xil/map/project.pcf \
    | tee xil/reports/par/cmd.log || exit 1

# copy build log
cp xil/par/project.par xil/reports/par

# move xrpt
mv project_par.xrpt xil/par/


########################################################
printsep TRCE

trce -intstyle xflow \
    -v 3 \
    -s 4 \
    -n 3 \
    -fastpaths \
    -xml xil/reports/trce/project.twx \
    -o xil/reports/trce/project.twr \
    xil/par/project.ncd \
    xil/map/project.pcf \
    | tee xil/reports/trce/cmd.log || exit 1


########################################################
printsep BITGEN

bitgen -intstyle xflow \
    -w \
    -g compress \
    -g configrate:8 \
    -g next_config_addr:0x000000 \
    -g en_suspend:yes \
    -g sw_clk:internalclk \
    -g drive_awake:yes \
    -g startupclk:cclk \
    xil/par/project.ncd \
    xil/bitgen/project.bit \
    xil/map/project.pcf \
    | tee xil/reports/bitgen/cmd.log || exit 1

# copy build log
cp xil/bitgen/project.bgn xil/reports/bitgen


########################################################
printsep IMPACT

echo "READY TO PROGRAM"
echo -ne "\a"
#read NOPE
NOPE=n

if [[ "$NOPE" != "n" ]]; then
    impact -batch build/impactcmds \
        | tee xil/reports/impact/cmd.log # || exit 1

    # move log
    mv _impactbatch.log xil/reports/impact/impactbatch.log
fi


########################################################
printsep CLEANUP

rm -rf xil/xlnx_auto_0_xdb
mv xlnx_auto_0_xdb xil
rm -rf xil/reports/xmsgs
mv _xmsgs xil/reports/xmsgs
rm xilinx_device_details.xml


########################################################
printsep SUMMARY

stopsecs=`date +"%s"`
timediff=$(($stopsecs-$startsecs))

echo "Start : $starttime"
echo "Finish: `date`"
echo "Duration: $timediff secs (about $(($timediff/60)) minutes)"

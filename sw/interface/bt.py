#!/usr/bin/env python2

import argparse, re, serial, time

import bsvparse
import interface as ifc
import console


DEF_DECAY = 0.15;


if __name__ == "__main__":
    p = argparse.ArgumentParser(description="bt analyzer interface");

    p.add_argument('-p', '--port', dest='port', type=str,
            action='store', default=ifc.DEF_PORT, help='serial port');

    p.add_argument('-b', '--baud', dest='baud', type=int,
            action='store', default=ifc.DEF_BAUD, help='baud rate');


    p.add_argument('-d', '--decay', dest='decay', type=float,
            action='store', default=DEF_DECAY, help='averager decay');


    p.add_argument('-B', '--base-tempo', dest='basetempo', type=int,
            action='store', default=ifc.DEF_BASE, help='manually set base tempo');

    p.add_argument('-n', '--num-metronomes', dest='nummetronomes', type=int,
            action='store', default=ifc.DEF_NUM,
            help='manually set number of metronomes');

    p.add_argument('-a', '--auto', dest='auto', type=str,
            action='store', default=None,
            help='automatically get number of metronomes and base tempo from a BSV file');

    args = p.parse_args();

    decay = args.decay;


    if args.auto != None:
        num, base = bsvparse.get_num_base(args.auto);
    else:
        num = args.nummetronomes;
        base = args.basetempo;


    print "Grabbing data from %d metronomes with base tempo %d..." % (num, base);

    cs = console.Console();
    controller = ifc.BTInterface(args.port, args.baud, num, base);
    printer = ifc.BTPrinter(cs);

    average = controller.get();

    while True:
        data = controller.get();

        best = None;
        for tempo in sorted(data.keys()):
            average[tempo] = (1 - decay) * average[tempo] + (decay) * data[tempo];

            if best == None or abs(average[tempo]) < abs(average[best]):
                best = tempo;

        printer.disp(data, average, best);

        time.sleep(0);

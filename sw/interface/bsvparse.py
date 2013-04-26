import re

re_met  = re.compile('.*typedef\s+(?P<num>\d+)\s+NumMetronomes;.*');
re_base = re.compile('.*Real\s+min_tempo\s+=\s+(?P<base>\d+)\s*;.*');

def get_num_base(fname):
    f = open(fname, 'r');

    num  = None;
    base = None;

    for line in f:
        if re_met.search(line):
            num = int(re_met.search(line).groupdict()['num']);
        elif re_base.search(line):
            base = int(re_base.search(line).groupdict()['base']);

        if num != None and base != None:
            break;

    f.close();

    return (num, base);

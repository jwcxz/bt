import serial

DEF_PORT = '/dev/ttyUSB0';
DEF_BAUD = 115200;

DEF_NUM  = 60;
DEF_BASE = 120;

class BTInterface:
    def __init__(self, port=DEF_PORT, baud=DEF_BAUD, num=DEF_NUM, base=DEF_BASE):

        self.cxn = serial.Serial(port, baud);
        self.num = num;
        self.base = base;

    def get(self):
        out = {};

        self.cxn.write('!');
        data = self.cxn.read(self.num);
        
        tempo = self.base;
        for c in data:
            out[tempo] = self.__convt(ord(c));
            tempo += 1;

        return out;

    def __convt(self, x):
        # get real phase
        if (x & 0x80):
            return -(((~x)&0x7F)+1)
        else:
            return x;


class BTPrinter:
    def __init__(self, console, orientation='h'):
        self.c = console;
        self.set_orientation(orientation);

    def set_orientation(self, o):
        if o == 'h':
            self.disp = self.disp_h;
        else:
            self.disp = self.disp_v;

    def disp_h(self, cur, avg, best):
        ch = self.c.chars;

        #out = self.c.clear_screen();
        out = self.c.go_to(0,0);

        out += ch['tl'] + ch['-']*5 + ch['mb'] + (ch['-']*6 + ch['mb'])*2 + \
                ch['-']*61 + ch['tr'] + "\n";

        out += "%c BPM %c  cur %c  avg %c " %(
                    ch['|'], ch['|'],
                    ch['|'], ch['|']) + \
                " "*60 + ch['|'] + "\n";

        out += ch['ml'] + ch['-']*5 + ch['mm'] + (ch['-']*6 + ch['mm'])*2 + \
                ch['-']*30 + ch['mb'] + ch['-']*30 + ch['mr'] + "\n";


        for tempo in sorted(cur.keys()):
            lc = self.c.line_color(avg[tempo]);

            out += "%s%c %3d %c %4d %c %4d %c%s%c%s\n" % (
                    lc[0],
                    ch['|'],
                    tempo,
                    ch['|'],
                    cur[tempo],
                    ch['|'],
                    avg[tempo],
                    ch['|'],
                    self.c.histogram_h(avg[tempo]),
                    ch['|'],
                    lc[1]
                    );


        out += ch['ml'] + ch['-']*5 + ch['mt'] + (ch['-']*6 + ch['mt'])*2 + \
                ch['-']*30 + ch['mt'] + ch['-']*30 + ch['mr'] + "\n";

        out += "%c Best Tempo Estimate: %3d BPM  [%4d / %4d]" % (
                    ch['|'], best, cur[best], avg[best]) + \
                " "*37 + ch['|'] + "\n";

        out += ch['bl'] + ch['-']*81 + ch['br'];

        print out

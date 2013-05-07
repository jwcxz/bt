unicodechars = {
        '#': u'\u2588',
        '|': u'\u2502',
        '-': u'\u2500',
        'tl': u'\u250c',
        'tr': u'\u2510',
        'bl': u'\u2514',
        'br': u'\u2518',
        'ml': u'\u251c',
        'mr': u'\u2524',
        'mt': u'\u2534',
        'mb': u'\u252c',
        'mm': u'\u253c',
        }


consolecolors = {
        'clear':  '\033[0m',
        'green':  '\033[92m',
        'yellow': '\033[93m',
        'red':    '\033[91m'
        }


class Console:
    def __init__(self):
        self.set_chars(unicodechars);
        self.set_colors(consolecolors);


    def set_chars(self, chars):
        self.chars = chars;

    def set_colors(self, colors):
        self.colors = colors;


    def line_color(self, val, maxval=128):
        cc = self.colors['clear'];

        if abs(val) <= maxval * 0.25:
            c = self.colors['green'];
        elif abs(val) <= maxval * 0.5:
            c = self.colors['yellow'];
        else:
            c = self.colors['red'];

        return (c,cc);


    def histogram_h(self, val, maxval=128, half_width=30):
        bar_sz = int(round(half_width*abs(val)/float(maxval)));

        out = " "*half_width;
        out += self.chars['|'];
        out += self.chars['#']*bar_sz;
        out += " "*(half_width-bar_sz);

        if val < 0: out = out[::-1];

        return out;


    def clear_screen(self):
        return chr(27) + "[2J";

    def go_to(self, x, y):
        return "\033[%d;%dH" %(x, y);


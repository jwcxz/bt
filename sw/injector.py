import struct, threading, time, wave

class SampleInjector(threading.Thread):
    enabled = False;

    afname = None;
    afile = None;
    params = None;
    injfn = None;
    unpacker = None;
    timestep = None;

    def __init__(self, afname, injfn):
        threading.Thread.__init__(self);
        self.afname = afname;
        self.injfn = injfn;

        self.afile = wave.open(afname, 'r');
        self.timestep = 1/(self.afile.framerate());

        self.unpacker = "<%s" % ("H"*self.afile.getnchannels());


    def run(self):
        self.enabled = True;

        while self.enabled:
            framedata = self.afile.readframes(1);

            # loop if we hit the end of the song
            if framedata == '':
                self.afile.rewind();
                framedata = self.afile.readframes(1);
                if framedata == '':
                    print "MY MIND IS FULL OF FUCK";
                    self.enabled = False;
                    break;

            sample = struct.unpack(self.unpacker, framedata);
            self.injfn(sample);

            time.sleep(self.timestep);


    def stop(self):
        self.enabled = False;


    def destroy(self):
        self.afile.close();

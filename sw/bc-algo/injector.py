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
        self.timestep = 1/(float(self.afile.getframerate()));

        self.unpacker = "<%s" % ("H"*self.afile.getnchannels());


    def get_framerate(self):
        if self.afile:
            return self.afile.getframerate();
        else:
            return 0;


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

            sample = [self.__twoscomp(s) for s in struct.unpack(self.unpacker, framedata)];

            self.injfn(sample);

            time.sleep(self.timestep);


    def stop(self):
        self.enabled = False;


    def destroy(self):
        if self.afile:
            self.afile.close();


    def __twoscomp(self, sample):
        if (sample >> 15) == 1:
            # negative
            return -( (sample ^ 0xFFFF) + 1);
        else:
            # positive
            return sample;

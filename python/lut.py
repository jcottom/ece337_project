import numpy as np
import time

def sig(x):
    return 1/(1 + np.exp(-x))

def genLUT():
    '''This function generates a look-up table for the sigmoid function, for use with fixed-point inputs/outputs
        '''
    # scaling factor s
    # maps 2**15 - 1 -> 100
    s = 100/(2**15 - 1)
    # To convert from scaling factor r to scaling factor s:
    # new = old/r * s
    # Here, r = 1
    for i in range(-2**15, 2**15):
        o = np.int16(np.round(sig(i*s)/s))
        outs = "16'b{:+017b} : out = 16'b{:016b};".format(i,o)
        if outs[4] == '+':
            t = '0'
        elif outs[4] == '-':
            t = '1'
        outs = outs[0:4] + t + outs[6:]
        print(outs)
    return

def genLUTPat():
    s = 100/(2**15 - 1)

    for i in range(-2**15, 2**15):
        o = np.int16(np.round(sig(i*s)/s))
        outs = "{:016b} {:016b}".format(i%2**16,o%2**16)
        print(outs)
    return

def genLUTArray():
    s = 100/(2**15 - 1)

    outs = ""
    for idx, i in  enumerate(range(0, 2**15)):
        if(idx % 8 == 0):
            outs = outs + '\n'
        o = np.int16(np.round(sig(i*s)/s))
        outs = outs + "16'h{:04X}, ".format(o)

    for idx, i in  enumerate(range(-2**15, 0)):
        if(idx % 8 == 0):
            outs = outs + '\n'
        o = np.int16(np.round(sig(i*s)/s))
        outs = outs + "16'h{:04X}, ".format(o)

    print(outs)

    return

if __name__ == "__main__":
    genLUTPat()

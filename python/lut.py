import numpy as np
import time

def sig(x):
    '''
    This is the sigmoid function, f(x) = (1 + e^-x)^-1
    '''
    return 1/(1 + np.exp(-x))

def genLUT():
    '''
    Originally, the output of this function was to sit between a case(in) and
    endcase in the activation.sv function. This approach didn't work for a
    poorly understood reason (the questasim output was something like "INTERNAL
    ERROR: case offset too large"). Anyway, I decided to go with an array of
    16bit values instead of a case statement, so this function doesn't really
    serve a purpose any longer.

    This function generates a look-up table for the sigmoid function, for use
    with fixed-point inputs/outputs
    '''
    # scaling factor s
    # maps 2**15 - 1 -> 100
    s = 100/(2**15 - 1)

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
    '''
    This function generates the output for testing the module in activation.sv,
    used by tb_activation.sv. If genLUTPat() is in main(), just run
    python3 lut.py > lut.pat, and make sure lut.pat is in
    ece337_project/python/, as that is where tb_activation.sv will be expecting
    it. Note that for these values to be useful, the variable "s" must be the
    same as used in genLUTArray().
    '''
    si = 1/(2**8)
    so = 1/(2**12)

    # Positive numbers
    for i in range(0, 2**15):
        o = np.int16(np.round(sig(i*si)/so))
        outs = "{:016b} {:016b}".format(i%2**16,o%2**16)
        print(outs)

    # Negative numbers
    for i in range(0, 2**15):
        o = np.int16(np.round(sig(-1*i*si)/so))
        outs = "{:016b} {:016b}".format((2**15+ i)%2**16,o%2**16)
        print(outs)
    return

def genLUTNums():
    '''
    This function generates the output for testing the module in activation.sv,
    used by tb_activation.sv. If genLUTPat() is in main(), just run
    python3 lut.py > lut.pat, and make sure lut.pat is in
    ece337_project/python/, as that is where tb_activation.sv will be expecting
    it. Note that for these values to be useful, the variable "s" must be the
    same as used in genLUTArray().
    '''
    si = 1/(2**8)
    so = 1/(2**12)

    # Positive numbers
    for i in range(0, 2**15):
        o = np.int16(np.round(sig(i*si)/so))
        outs = "{:f} {:f}".format(((2**15+ i)*si)%2**16,(o*so)%2**16)
        print(outs)

    # Negative numbers
    for i in range(0, 2**15):
        o = np.int16(np.round(sig(-1*i*si)/so))
        outs = "{:f} {:f}".format(((2**15+ i)*si)%2**16,(o*so)%2**16)
        print(outs)
    return

def genLUTArray():
    '''
    This function generates the values of the lookup table used in
    activation.sv. These values are meant to be placed the following two lines:

   reg [15:0]                       lut [0:65535] = '{
    .
    .
    .
                                                      };

    The fixed-point encoding used by this design is set by the variable "s",
    where if s = x/(2**15 - 1), then the max signed 16 bit integer,
    0111 1111 1111 1111, will be encoded to the value "x". Note, of course, that
    if s = 1, then the sigmoid function will output only either 0 or 1 for all
    values, which doesn't do our neural network any good, but if x is too high,
    we cannot represent larger numbers with our encoding.
    '''
    si = 1/(2**8)
    so = 1/(2**12)

    outs = ""

    # Positive numbers first
    for idx, i in  enumerate(range(0, 2**15)):
        if(idx % 8 == 0):
            outs = outs + '\n'
        o = np.int16(np.round(sig(i*si)/so))
        outs = outs + "16'h{:04X}, ".format(o)

    # Negative numbers next
    for idx, i in  enumerate(range(-2**15+1, 1)[::-1]):
        if(idx % 8 == 0):
            outs = outs + '\n'
        o = np.int16(np.round(sig(i*si)/so))
        outs = outs + "16'h{:04X}, ".format(o)

    print(outs)

    return

if __name__ == "__main__":
    genLUTNums()

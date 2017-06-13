#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""Try to crunch curves by compting there derivatives

"""

# imports
import numpy as np
import sys

def derivative(curve):
    curve = np.asarray(curve)
    first = curve[0]
    delta = curve[1:] - curve[:-1]

    return first, delta



def crunch(data, level):
    first, data = derivative(data)
    print "\tdb 0x%x" % first

    if level==1:
        print "\tdb " + ",".join("%d"%val for val in data)
    else:
        crunch(data, level-1)

def main():
    fname = sys.argv[1]
    with open(fname, 'rb') as f:
        data = [ord(_) for _ in f.read()]

    if len(sys.argv) == 3:
        crunch(data[::2], level=1)
  #      crunch(data[1::2], level=1) skip this one
    else:
        crunch(data, level=1)


if __name__ == "__main__":
    main()

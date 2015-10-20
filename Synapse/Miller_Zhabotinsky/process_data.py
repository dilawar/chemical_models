import numpy as np
import pylab
import sys

def process_data(header, filename):
    data = np.genfromtxt(filename, delimiter=',', skiprows=1).T
    row = data[header.index('Sp.N'), :]
    time = data[header.index('time'), :]
    maxIndex = np.argmax(row)
    rs = row[maxIndex:]
    #pylab.plot(time[maxIndex:], rs)
    poly = np.polyfit(time[maxIndex:], rs, 1)
    print("Poly mx + x: %s" % poly)

def main():
    filename = sys.argv[1]
    with open(filename, "r") as f:
        lines = f.read().split('\n')
        header = lines[0].split(',')
    process_data(header, filename)

if __name__ == '__main__':
    main()

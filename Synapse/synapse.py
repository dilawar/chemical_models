"""synapse.py: 

Create a synapse with chemical models in it.

"""
    
__author__           = "Dilawar Singh"
__copyright__        = "Copyright 2015, Dilawar Singh and NCBS Bangalore"
__credits__          = ["NCBS Bangalore"]
__license__          = "GNU GPL"
__version__          = "1.0.0"
__maintainer__       = "Dilawar Singh"
__email__            = "dilawars@ncbs.res.in"
__status__           = "Development"

import moose
import moose.utils as mu
import yacml
import sys

ncompts = 3

def load_model( modelFile ):
    print("[INFO] Loading model %s" % modelFile)
    moose.Compartment('/synapse')
    compts = []
    for i in range(ncompts):
        model = yacml.loadYACML( modelFile, path = '/synapse/psd%s' % i )
        compts.append( model )
    
def create_interconnection():
    """Add connection among different compartments """
    Sps = moose.wildcardFind( '/synapse/psd#/PSD/Sp' )
    for sp in Sps:
        print sp

def create_network( model ):
    print("[INFO] Creating network using the chemical network: %s" %
            model.G.name
            )
    global ncompts

def main():
    modelFile = sys.argv[1]
    load_model(modelFile)
    create_interconnection()


if __name__ == '__main__':
    main()

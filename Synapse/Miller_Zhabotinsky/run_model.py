#!/usr/bin/env python

"""run_model.py: 

"""
    
__author__           = "Dilawar Singh"
__copyright__        = "Copyright 2015, Dilawar Singh and NCBS Bangalore"
__credits__          = ["NCBS Bangalore"]
__license__          = "GNU GPL"
__version__          = "1.0.0"
__maintainer__       = "Dilawar Singh"
__email__            = "dilawars@ncbs.res.in"
__status__           = "Development"

import sys
sys.path.append('../../..')
import yacml
import moose

def main():
    modelfile = sys.argv[1]
    model = yacml.loadYACML(modelfile)
    model.run()

if __name__ == '__main__':
    main()

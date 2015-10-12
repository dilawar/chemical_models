"""
When setting up following model in YACML. rate-term assertion fails.

compartment PSD {

    volume = "5e-21"

    ca [ conc = "1e-4+1e-3*(t > 50 && t < 53 ?1:0)", plot = True ];

    S [ N = 20, plot = true ];

    S1 [N_init = 0, plot = true ];

    Sp [ N_init = 0, plot = true  ];

    r_p0_p1 [ kf =  "k1*(ca/kh1)^6/(1+(ca/kh1)^3)^2", kb = 0.0 
        kh1 = "0.7e-3", k1 = 1.5 ];

    S -> r_p0_p1 -> S1;

    r_p1_up [ kf = "k1*(ca/kh1)^3/(1+(ca/kh1)^3)", kb = 0.0, kh1 = "0.7e-3", k1 = 1.5 ];
    S1 -> r_p1_up -> Sp;

    //solver = gsolve
    dt = 0.005

    /* 2 second of Ca++ pulse [1 uM] phosphorylates 50% of CaMKII */
    sim_time = 1000
}

"""

import moose
import moose.utils as mu

compt = moose.CubeMesh('/compt')
compt.volume = 1e-20

molecules = [ 'ca', "S", "S1", "Sp" ]
pools = {}
tables = {}
for m in molecules:
    pools[m] = moose.Pool('/compt/%s' % m)
    t = moose.Table2("/table%s" % m)
    tables[m] = t
    moose.connect(t, 'requestOut', pools[m], 'getConc')

#pools['ca'] = moose.BufPool('/compt/ca')
pools['ca'].nInit = 20

r_p0_p1 = moose.Reac('/compt/reacA')
funA = moose.Function('/compt/funA')
funA.expr = "{0}*(y0/{1})^6/(1+(y0/{1})^3)^2".format("1.5", "0.7e-3")
moose.connect(funA, 'requestOut',  pools['ca'], 'getConc')
moose.connect(funA, 'valueOut', pools['S1'], 'setConc')
moose.connect(r_p0_p1, 'sub', pools['S'], 'reac')
moose.connect(r_p0_p1, 'prd', pools['S1'], 'reac')

r_p1_up = moose.Reac('/compt/reacB')
moose.connect(r_p1_up, 'sub', pools['S1'], 'reac')
moose.connect(r_p1_up, 'prd', pools['Sp'], 'reac')

# Disabling solver executes the model accurately.
k = moose.Ksolve('/compt/ksolve')
s = moose.Stoich('/compt/stoich')
s.compartment = compt
s.ksolve = k
s.path = '/compt/##'


moose.reinit()
moose.start(10)
mu.plotRecords(tables)

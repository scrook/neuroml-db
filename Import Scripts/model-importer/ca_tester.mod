TITLE Ca++ tester

NEURON {
	SUFFIX ca_tester
	USEION ca READ ica, cai, cao
}

UNITS {

}

CONSTANT {

}

PARAMETER {

}

STATE {
  test
}

INITIAL {

}

ASSIGNED {
 ica
 cai
 cao
}
	
BREAKPOINT {
	SOLVE state METHOD derivimplicit
}

DERIVATIVE state { 
   test' = 0
}


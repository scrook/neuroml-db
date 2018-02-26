import sciunit

from neuronunit.capabilities import spike_functions
from neuronunit.capabilities import *
from neuronunit.neuron.capabilities import *

from quantities import ms, mV, nA
from neo.core import AnalogSignal

class NeuronModel(sciunit.Model):
    """Model is a NEURON simulator model"""
    
    def __init__(self, hVar, name=None):
        
        self.setH(hVar)
        self.setIntegrationMethod()
        self.setTimeStep()
        self.setTolerance()
        self.setStopTime()
        
        super(NeuronModel,self).__init__(name=name)
    
        return
    
    def setH(self, hVariable):
        """Sets the NEURON h variable"""
        self.h = hVariable
        self.h.load_file("stdlib.hoc")
        self.h.load_file("stdgui.hoc")

    
    def setStopTime(self, stopTime = 1000*ms):
        """Sets the simulation duration"""
        """stopTimeMs: duration in milliseconds"""

        tstop = stopTime
        tstop.units = ms

        self.h.tstop = float(tstop)
    
    def setTimeStep(self, integrationTimeStep = 1/128.0 * ms):
        """Sets the simulation itegration fixed time step"""
        """integrationTimeStepMs: time step in milliseconds. Powers of two preferred. Defaults to 1/128.0"""

        dt = integrationTimeStep
        dt.units = ms

        self.h.dt = float(dt)
    
    def setTolerance(self, tolerance = 0.001):
        """Sets the variable time step integration method absolute tolerance """
        """tolerance: absolute tolerance value"""
        
        self.h.cvode.atol(tolerance)
    
    def setIntegrationMethod(self, method = "fixed"):
        """Sets the simulation itegration method"""
        """method: either "fixed" or "variable". Defaults to fixed. cvode is used when "variable" """
        
        self.h.cvode.active(1 if method == "variable" else 0)





class SingleCellModel(NeuronModel, \
                                    HasSegment, \
                                    ProducesMembranePotential, \
                                    ReceivesSquareCurrent, \
                                    ProducesActionPotentials, \
                                    ProducesSpikes):
    
    """A NEURON simulator model for an isolated single cell membrane"""
    
    def __init__(self, \
                 hVar, \
                 section, \
                 loc = 0.5, \
                 name=None):
        """
        hVar: the h variable of NEURON
        section: NEURON Section object of an isolated single cell into which current will be injected, and whose voltage will be observed.
        loc: the fraction along the Section object length that will be used for current injection and voltage observation.
        simDuration: the simulation length in ms
        name: Optional model name.
        """
        
        super(SingleCellModel,self).__init__(name=name, hVar=hVar)
    
        self.setSegment(section, loc)
        
        # Store voltage values
        self.vVector = self.h.Vector()
        self.vVector.record(self.getSegment()._ref_v)
        
        return

    def get_spike_train(self):
        """Gets computed spike times from the model.

        Arguments: None.
        Returns: a neo.core.SpikeTrain object.
        """

        return spike_functions.get_spike_train(self.get_membrane_potential())
    
    def get_APs(self):
        """Gets action potential waveform chunks from the model.
            
        Returns
        -------
        Must return a neo.core.AnalogSignalArray.
        Each neo.core.AnalogSignal in the array should be a spike waveform.
        """
        
        return spike_functions.get_spike_waveforms(self.get_membrane_potential())

    def get_membrane_potential(self):
        """Must return a neo.core.AnalogSignal."""
        
        return AnalogSignal( \
                 self.vVector.to_python(), \
                 units = mV, \
                 sampling_period = self.h.dt * ms \
        )

    def inject_square_current(self,current):
        """Injects somatic current into the model.

        Parameters
        ----------
        current : a dictionary like:
                        {'amplitude':-10.0*pq.pA,
                         'delay':100*pq.ms,
                         'duration':500*pq.ms}}
                  where 'pq' is the quantities package
        This describes the current to be injected.
        """

        # Set the units to those expected by NEURON IClamp
        amp = current['amplitude']
        amp.units = nA

        dur = current['duration']
        dur.units = ms

        delay = current['delay']
        delay.units = ms

        if not hasattr(self, 'iclamp'):
            self.iclamp = self.h.IClamp(self.getSegment())

        self.iclamp.delay = float(delay)
        self.iclamp.dur = float(dur)
        self.iclamp.amp = float(amp)

        self.h.run()


# Allen Institute Software License - This software license is the 2-clause BSD
# license plus a third clause that prohibits redistribution for commercial
# purposes without further permission.
#
# Copyright 2017. Allen Institute. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# 3. Redistributions for commercial purposes are not permitted without the
# Allen Institute's written permission.
# For purposes of this license, commercial purposes is the incorporation of the
# Allen Institute's software into anything for which you will charge fees or
# other compensation. Contact terms@alleninstitute.org for commercial licensing
# opportunities.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

'''
This code was written by Corinne Teeter with intellectual contributions from
Stefan Mihalas, Vilas Menon, Ramakrishnan Iyer, and Nicholas Cain.  This code creates the 
basic pink noise stimuli used in the noise1, noise2, and ramp to rheo stimulus used in the Allen 
Institute for Brain Science electrophysiology pipeline.
Note that the output trace created by this code may not exactly match
what was used in our stimulus due to the random seed.  Exact traces 
can be found in the experimental .nwb files.
'''


import numpy as np
import matplotlib.pylab as plt
import cPickle

np.random.seed(0)

import pydevd
pydevd.settrace('192.168.0.34', port=4200, suspend=False)

#--------------------------------------------------------------------
#--------Set these parameters----------------------------------------
#--------------------------------------------------------------------
stimTimeLength=3 #total time of the stimulus in seconds
sampleResolution=5.e-6 #sampling time step

# Set frequency bounds in Htz
fmin=1
fmax=100

#--------------------------------------------------------------------
#--------------------------------------------------------------------
#--------------------------------------------------------------------
totalNumOfPoints=stimTimeLength/sampleResolution
tvector=np.arange(0,totalNumOfPoints)*sampleResolution

# The pink noise is created by summing up sine waves at random phases 
# at frequencies in 1 Hz increments. 1 Hz increments were chosen  (as 
# opposed to doing it every 0.1 htz or some other value) because we wanted
# a waveform that was periodic at 1 Htz frequencies so that specific
# history dependent changes could be observed.
freqResolution=1

phaseVector1=np.random.rand(int(100*1/freqResolution))*2*np.pi
phaseVector2=np.random.rand(int(100*1/freqResolution))*2*np.pi

# The power spectrum for the pink noise should fall off as 1/freq.   
# Since power ~ amplitude^2, the amplitude should fall off as 1/(freq^2)
# Since the noise is later scaled to make the Coefficient of Variation (CV) 
# equal to 0.2, a normalization factor is irrelevant. 
freq=np.arange(fmin, fmax+1, freqResolution)  #frequency in Htz
pinkAmp=1./(np.sqrt(freq))

pinkwaves1=[]
pinkwaves2=[]
for i in range(len(freq)):
    pinkwaves1.append(pinkAmp[i]*np.sin(2*np.pi*tvector*freq[i]+phaseVector1[i]))
    pinkwaves2.append(pinkAmp[i]*np.sin(2*np.pi*tvector*freq[i]+phaseVector2[i]))
sumpinkwaves1=reduce(lambda x,y:x+y,pinkwaves1) #summing up the waves
sumpinkwaves2=reduce(lambda x,y:x+y,pinkwaves2) #summing up the waves

# Take Fourier Transform to check power spectrum
fftPinkNoise1=abs(np.fft.fft(sumpinkwaves1))/stimTimeLength
fftPinkNoise2=abs(np.fft.fft(sumpinkwaves2))/stimTimeLength

plt.figure()
plt.plot(abs(fftPinkNoise1)[0:fmax]/np.max(fftPinkNoise1)) 
plt.plot(abs(fftPinkNoise2)[0:fmax]/np.max(fftPinkNoise2)) 
plt.title('Power Spectrum Pink Noise')
plt.xlabel('Frequency')
plt.ylabel('Power')
plt.ylim([0,1])

# Find scale factor to give a coefficient of variation =0.2
CV=.2
scaleFactPink1=CV/np.std(sumpinkwaves1)
scaleFactPink2=CV/np.std(sumpinkwaves2)
print 'CV pink 1', np.std(sumpinkwaves1*scaleFactPink1)
print 'CV pink 2', np.std(sumpinkwaves2*scaleFactPink2)

# Shifting the noise so that the mean is zero
meanPink1=np.mean(sumpinkwaves1)
zeroMeanPink1=sumpinkwaves1-meanPink1 
meanPink2=np.mean(sumpinkwaves2)
zeroMeanPink2=sumpinkwaves2-meanPink2 

# Now shift the noise so that the mean =1 so that it can easily be scaled by some current.  
# I.e say rheobase is at 500 pA; the waveform created here can now be multiplied 
# by 500 pA and the noise will have a CV of 0.2 centered around rheobase.
finalPink1=zeroMeanPink1*scaleFactPink1+1
finalPink2=zeroMeanPink2*scaleFactPink2+1

# as a sanity check make sure the when this noise is scaled by an arbitrary current injection that the CV=0.2
arbitraryNumber=300
print 'CV of pink noise when arbitrarily scaled by ', arbitraryNumber, ': ', np.std(arbitraryNumber*finalPink1)/np.mean(arbitraryNumber*finalPink1)

# put it all together to so that 3 second noise ephocs will be centered around 75%, 100%, and 125% rheobase
noStim=np.zeros(int(5/sampleResolution)) #5 seconds no stimulation

noise1=np.concatenate([noStim, 0.75*finalPink1, noStim, finalPink1, noStim, 1.25*finalPink1, noStim])
noise2=np.concatenate([noStim, 0.75*finalPink2, noStim, finalPink2, noStim, 1.25*finalPink2, noStim])

plt.figure()
plt.plot(np.arange(len(noise1))*sampleResolution, noise1)
plt.xlabel('time (s)')
plt.ylabel('% rheobase')
plt.title('Noise 1')

plt.figure()
plt.plot(np.arange(len(noise2))*sampleResolution, noise2)
plt.xlabel('time (s)')
plt.ylabel('% rheobase')
plt.title('Noise 2')


#-------------------------------------------------------------------------------------------------
#-- Create ramp to rheobase noise stimulus---------------------------------------------------------
#-- Here 1 second epochs of the two different noise stimuli are alternated-------------------------
#-------------------------------------------------------------------------------------------------

# find epochs where noise crosses zero so that epochs can be smoothly stitched together at zero crossings
a=np.where(zeroMeanPink1<.005)[0]
b=np.where(zeroMeanPink1>-.005)[0]
startPink1Index=np.intersect1d(a,b)[0]

a=np.where(zeroMeanPink2<.005)[0]
b=np.where(zeroMeanPink2>-.005)[0]
startPink2Index=np.intersect1d(a,b)[0]

# Define 1 second epochs with end points close to zero. Note that noise oscillates in 1 second 
# bouts as defined by our chosen frequencies (lowest frequency 1 Htz). Thus if a point 
# that crosses zero is found, it will also cross zero 1 second later. 
timeVec_1sec=np.arange(0,1,sampleResolution)
pink1=zeroMeanPink1[startPink1Index:startPink1Index+int(1./sampleResolution)+1]
pink2=zeroMeanPink2[startPink2Index:startPink2Index+int(1./sampleResolution)+1]

# Make a ramp 14 seconds long that ends up at one
sec_of_ramp=14
t_ramp=np.arange(0, sec_of_ramp, sampleResolution)
y=(1./sec_of_ramp)*t_ramp

# Underlying shape of entire ramp to rheobase stimulus
shapeSkeleton=np.append(y, np.ones(int(18/sampleResolution)+1))

# CV scale factors used during 14 s ramp
scaleFactPink1_p1=.1/np.std(zeroMeanPink1)
scaleFactPink2_p1=.1/np.std(zeroMeanPink2)

# CV scale factors used during oscillating stimulus at rheobase
scaleFactPink1_p2=.2/np.std(zeroMeanPink1)
scaleFactPink2_p2=.2/np.std(zeroMeanPink2)

scaleFactPink1_p4=.4/np.std(zeroMeanPink1)
scaleFactPink2_p4=.4/np.std(zeroMeanPink2)

scaleFactPink1_p6=.6/np.std(zeroMeanPink1)
scaleFactPink2_p6=.6/np.std(zeroMeanPink2)

timeVec_14sec=np.arange(0,14,sampleResolution)

# Scale and concatenate noise for ramp section
noiseRampSetCVp1=np.concatenate((pink1*scaleFactPink1_p1, pink2*scaleFactPink2_p1,
                          pink1*scaleFactPink1_p1, pink2*scaleFactPink2_p1,
                          pink1*scaleFactPink1_p1, pink2*scaleFactPink2_p1,
                          pink1*scaleFactPink1_p1, pink2*scaleFactPink2_p1,
                          pink1*scaleFactPink1_p1, pink2*scaleFactPink2_p1,
                          pink1*scaleFactPink1_p1, pink2*scaleFactPink2_p1,
                          pink1*scaleFactPink1_p1, pink2*scaleFactPink2_p1))

# Scale noise for CV oscillating section at rheobase.
# Noise oscillates with noise set to 0.2, 0.4, 0.6, 0.6, 0.4, 0.2 for noise 1, noise 2, and noise 1 
noise1set=np.concatenate((pink1*scaleFactPink1_p2, pink1*scaleFactPink1_p4, pink1*scaleFactPink1_p6,pink1*scaleFactPink1_p6, pink1*scaleFactPink1_p4, pink1*scaleFactPink1_p2))
noise2set=np.concatenate((pink2*scaleFactPink2_p2, pink2*scaleFactPink2_p4, pink2*scaleFactPink2_p6,pink1*scaleFactPink2_p6, pink2*scaleFactPink2_p4, pink2*scaleFactPink2_p2))

# Stitch noise together for entire stimulus
allNoise=np.concatenate((noiseRampSetCVp1, noise1set, noise2set, noise1set))

# Add noise to the shape skeleton to get final ramp to rheobase stimulus
RampRheoPinkCVp1=allNoise+shapeSkeleton

plt.figure()
plt.plot(np.arange(len(RampRheoPinkCVp1))*sampleResolution, RampRheoPinkCVp1)
plt.xlabel('time (s)')
plt.title('Ramp to Rheobase')

# plt.show()


def current_to_pickle(file_name, current_np):
    current = current_np.tolist()
    time = (np.arange(len(current_np)) * sampleResolution * 1000.0).tolist()

    obj = {"i": current, "t": time}

    with open(file_name, "wb") as f:
        cPickle.dump(obj, f)


current_to_pickle("noise1.pickle", finalPink1)
current_to_pickle("noise2.pickle", finalPink2)
current_to_pickle("noisyRamp.pickle", RampRheoPinkCVp1)

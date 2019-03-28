#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This experiment was created using PsychoPy3 Experiment Builder (v3.0.5),
    on Tue Mar  5 23:01:50 2019
If you publish work using this script please cite the PsychoPy publications:
    Peirce, JW (2007) PsychoPy - Psychophysics software in Python.
        Journal of Neuroscience Methods, 162(1-2), 8-13.
    Peirce, JW (2009) Generating stimuli for neuroscience using PsychoPy.
        Frontiers in Neuroinformatics, 2:10. doi: 10.3389/neuro.11.010.2008
"""

from __future__ import absolute_import, division

import psychopy
psychopy.useVersion('3.0.5')

from psychopy import locale_setup, sound, gui, visual, core, data, event, logging, clock
from psychopy.constants import (NOT_STARTED, STARTED, PLAYING, PAUSED,
                                STOPPED, FINISHED, PRESSED, RELEASED, FOREVER)
import numpy as np  # whole numpy lib is available, prepend 'np.'
from numpy import (sin, cos, tan, log, log10, pi, average,
                   sqrt, std, deg2rad, rad2deg, linspace, asarray)
from numpy.random import random, randint, normal, shuffle
import os  # handy system and path functions
import sys  # to get file system encoding


# Ensure that relative paths start from the same directory as this script
_thisDir = os.path.dirname(os.path.abspath(__file__))
os.chdir(_thisDir)

# Store info about the experiment session
psychopyVersion = '3.0.5'
expName = 'Syllabification'  # from the Builder filename that created this script
expInfo = {'participant': 'part001', 'session': 'A', 'Name': ''}
dlg = gui.DlgFromDict(dictionary=expInfo, title=expName)
if dlg.OK == False:
    core.quit()  # user pressed cancel
expInfo['date'] = data.getDateStr()  # add a simple timestamp
expInfo['expName'] = expName
expInfo['psychopyVersion'] = psychopyVersion

# Data file name stem = absolute path + name; later add .psyexp, .csv, .log, etc
filename = _thisDir + os.sep + u'data/%s_%s_%s' % (expInfo['participant'], expInfo['session'], expName)

# An ExperimentHandler isn't essential but helps with data saving
thisExp = data.ExperimentHandler(name=expName, version='',
    extraInfo=expInfo, runtimeInfo=None,
    originPath='/Users/drakeasberry/github/Dissertation/Dissertation_Experiments/segmentation/Segmentation.py',
    savePickle=True, saveWideText=True,
    dataFileName=filename)
# save a log file for detail verbose info
logFile = logging.LogFile(filename+'.log', level=logging.EXP)
logging.console.setLevel(logging.WARNING)  # this outputs to the screen, not a file

endExpNow = False  # flag for 'escape' or other condition => quit the exp

# Start Code - component code to be run before the window creation

# Setup the Window
win = visual.Window(
    size=[1280, 800], fullscr=True, screen=0,
    allowGUI=False, allowStencil=False,
    monitor='testMonitor', color=[0,0,0], colorSpace='rgb',
    blendMode='avg', useFBO=True)
# store frame rate of monitor if we can measure it
expInfo['frameRate'] = win.getActualFrameRate()
if expInfo['frameRate'] != None:
    frameDur = 1.0 / round(expInfo['frameRate'])
else:
    frameDur = 1.0 / 60.0  # could not measure, so guess

# Initialize components for Routine "pracIns"
pracInsClock = core.Clock()
initialIns = visual.TextStim(win=win, name='initialIns',
    text="Usted va a completar un experimento.\n\nVa a ver un target\n\nDespués, verá otras palabras.\n\nSi ve el target, presione el botón 'y'.\n\nSi no ve el target, no haga nada.\n\nPresione 'la barra' para empezar las pruebas de práctica.",
    font='Arial',
    pos=(0, 0), height=0.075, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

# Initialize components for Routine "target"
targetClock = core.Clock()
pracLoopCount=0
practiceTargets = []
practiceCarriers ={}
experimentTargets = {}
experimentCarriers = {}

if expInfo['session'] == 'A':
    condition="data/processed_data/exp_files/pracCondA.csv"
    practice = "practiceListA"
    experiment = "stimuliListA"
    #targetExp="stimuliListA"
    #carrierP = "practiceListA"
    carrier = "stimuliListA"
elif expInfo['session'] == 'B':
    condition="data/processed_data/exp_files/pracCondB.csv"
    targetExp="stimuliB"
elif expInfo['session'] == 'C':
    condition="data/processed_data/exp_files/pracCondC.csv"
    targetExp="stimuliC"
else:
    condition="data/processed_data/exp_files/pracCondD.csv"
    targetExp="stimuliD"

pracTarget = visual.TextStim(win=win, name='pracTarget',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);

# Initialize components for Routine "trial"
trialClock = core.Clock()

pracCarrier = visual.TextStim(win=win, name='pracCarrier',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);

# Initialize components for Routine "expIns"
expInsClock = core.Clock()
startExp = visual.TextStim(win=win, name='startExp',
    text="Usted acaba de completar las pruebas.\n\nRecuerde:\nSi ve el target, presione el botón 'y'.\n\nSi no ve el target, no haga nada.\n\n\nPresione 'la barra' para empezar el experimento.",
    font='Arial',
    pos=(0, 0), height=0.075, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

# Initialize components for Routine "targetExp"
targetExpClock = core.Clock()

expTarget = visual.TextStim(win=win, name='expTarget',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);

# Initialize components for Routine "trialExp"
trialExpClock = core.Clock()

expCarrier = visual.TextStim(win=win, name='expCarrier',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);

# Initialize components for Routine "syllablePracIns"
syllablePracInsClock = core.Clock()
instructionSyl = visual.TextStim(win=win, name='instructionSyl',
    text="Ahora, verá varias palabras y selecionará la primera sílaba.\n\nPresione '1' si su respuesta está a la izqueirda.\n\nPresione '2' si su respuesta está a la derecha.\n\nPresione 'la barra' para empezar las pruebas de práctica.",
    font='Arial',
    pos=(0, 0), height=0.075, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

# Initialize components for Routine "syllablePracTrial"
syllablePracTrialClock = core.Clock()
PracSylTarget = visual.TextStim(win=win, name='PracSylTarget',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);
PracSylAnsCVC = visual.TextStim(win=win, name='PracSylAnsCVC',
    text='default text',
    font='Arial',
    pos=(-.5, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);
PracSylAnsCV = visual.TextStim(win=win, name='PracSylAnsCV',
    text='default text',
    font='Arial',
    pos=(.5, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-2.0);

# Initialize components for Routine "syllableExpIns"
syllableExpInsClock = core.Clock()
SyllableExpInsText = visual.TextStim(win=win, name='SyllableExpInsText',
    text="Ahora, verá varias palabras y selecionará la primera sílaba.\n\nRecuerde:\nPresione '1' si su respuesta está a la izqueirda.\n\nPresione '2' si su respuesta está a la derecha.\n\nPresione 'la barra' para empezar el experimento.",
    font='Arial',
    pos=(0, 0), height=0.075, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

# Initialize components for Routine "trialSyllable"
trialSyllableClock = core.Clock()
if expInfo['session'] == 'A':
    syllable="data/processed_data/exp_files/sylexpCondA.csv"
elif expInfo['session'] == 'B':
    syllable="syllableB.xlsx"
elif expInfo['session'] == 'C':
    syllable="syllableC.xlsx"
else:
    syllable="syllableD.xlsx"
AnswerCVC = visual.TextStim(win=win, name='AnswerCVC',
    text='default text',
    font='Arial',
    pos=(-.5, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);
AnswerCV = visual.TextStim(win=win, name='AnswerCV',
    text='default text',
    font='Arial',
    pos=(.5,0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-2.0);
Syllable_Target = visual.TextStim(win=win, name='Syllable_Target',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-3.0);

# Initialize components for Routine "thankYou"
thankYouClock = core.Clock()
Gracias = visual.TextStim(win=win, name='Gracias',
    text='¡Muchas Gracias!',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

# Create some handy timers
globalClock = core.Clock()  # to track the time since experiment started
routineTimer = core.CountdownTimer()  # to track time remaining of each (non-slip) routine 

# ------Prepare to start Routine "pracIns"-------
t = 0
pracInsClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
startPrac = event.BuilderKeyResponse()
# keep track of which components have finished
pracInsComponents = [initialIns, startPrac]
for thisComponent in pracInsComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "pracIns"-------
while continueRoutine:
    # get current time
    t = pracInsClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *initialIns* updates
    if t >= 0.0 and initialIns.status == NOT_STARTED:
        # keep track of start time/frame for later
        initialIns.tStart = t
        initialIns.frameNStart = frameN  # exact frame index
        initialIns.setAutoDraw(True)
    
    # *startPrac* updates
    if t >= 0.0 and startPrac.status == NOT_STARTED:
        # keep track of start time/frame for later
        startPrac.tStart = t
        startPrac.frameNStart = frameN  # exact frame index
        startPrac.status = STARTED
        # keyboard checking is just starting
        event.clearEvents(eventType='keyboard')
    if startPrac.status == STARTED:
        theseKeys = event.getKeys(keyList=['space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            # a response ends the routine
            continueRoutine = False
    
    # check for quit (typically the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in pracInsComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "pracIns"-------
for thisComponent in pracInsComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# the Routine "pracIns" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
pracTarLoop = data.TrialHandler(nReps=8, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions(condition, selection=[1]),
    seed=None, name='pracTarLoop')
thisExp.addLoop(pracTarLoop)  # add the loop to the experiment
thisPracTarLoop = pracTarLoop.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisPracTarLoop.rgb)
if thisPracTarLoop != None:
    for paramName in thisPracTarLoop:
        exec('{} = thisPracTarLoop[paramName]'.format(paramName))

for thisPracTarLoop in pracTarLoop:
    currentLoop = pracTarLoop
    # abbreviate parameter names if possible (e.g. rgb = thisPracTarLoop.rgb)
    if thisPracTarLoop != None:
        for paramName in thisPracTarLoop:
            exec('{} = thisPracTarLoop[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "target"-------
    t = 0
    targetClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    routineTimer.add(0.500000)
    # update component parameters for each repeat
    targetPrac = practice + "%i" %pracTarLoop.thisN
    
    
    
    #if targetP == str(pracTarLoop.thisTrial):
    #print(str(pracTarLoop.thisTrial) + ' %i' %pracTarLoop.thisN)
    
    
    
    
    #if targetP == 'stimuliPracitce1':
    #    trialTarget = pracTarget.setText("Find  " + eval(targetP))
    #else: 
    #    trialTarget = pracTarget.setText("")
    pracTarget.setText("Encuentre    " + eval(targetPrac)
)
    # keep track of which components have finished
    targetComponents = [pracTarget]
    for thisComponent in targetComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "target"-------
    while continueRoutine and routineTimer.getTime() > 0:
        # get current time
        t = targetClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        
        # *pracTarget* updates
        if t >= 0.0 and pracTarget.status == NOT_STARTED:
            # keep track of start time/frame for later
            pracTarget.tStart = t
            pracTarget.frameNStart = frameN  # exact frame index
            pracTarget.setAutoDraw(True)
        frameRemains = 0.0 + .5- win.monitorFramePeriod * 0.75  # most of one frame period left
        if pracTarget.status == STARTED and t >= frameRemains:
            pracTarget.setAutoDraw(False)
        
        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in targetComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "target"-------
    for thisComponent in targetComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    #if pracTarLoop.thisN != 0:
    #    pracLoopCount +=1
    
    
    #practiceTargets = practiceTargets.append(pracTarLoop.thisTrial)
    #print('Dictionary maybe?')
    #print(practiceTargets) 
    
    # set up handler to look after randomisation of conditions etc
    pracTrialLoop = data.TrialHandler(nReps=1, method='random', 
        extraInfo=expInfo, originPath=-1,
        trialList=data.importConditions(condition, selection=[2,3,4,5,6,7,8,9,10,11]),
        seed=None, name='pracTrialLoop')
    thisExp.addLoop(pracTrialLoop)  # add the loop to the experiment
    thisPracTrialLoop = pracTrialLoop.trialList[0]  # so we can initialise stimuli with some values
    # abbreviate parameter names if possible (e.g. rgb = thisPracTrialLoop.rgb)
    if thisPracTrialLoop != None:
        for paramName in thisPracTrialLoop:
            exec('{} = thisPracTrialLoop[paramName]'.format(paramName))
    
    for thisPracTrialLoop in pracTrialLoop:
        currentLoop = pracTrialLoop
        # abbreviate parameter names if possible (e.g. rgb = thisPracTrialLoop.rgb)
        if thisPracTrialLoop != None:
            for paramName in thisPracTrialLoop:
                exec('{} = thisPracTrialLoop[paramName]'.format(paramName))
        
        # ------Prepare to start Routine "trial"-------
        t = 0
        trialClock.reset()  # clock
        frameN = -1
        continueRoutine = True
        routineTimer.add(0.500000)
        # update component parameters for each repeat
        carrierPrac = practice + "%i" %pracTarLoop.thisN
        
        
        #for paramName in thisPracTrialLoop.keys():
            #if paramName == carrier:
                #print(paramName + ' round %i' %pracTrialLoop.thisN)
            #else:
                #print(paramName + ' round %i' %pracTrialLoop.thisN)
                #exec(paramName + '=thisPracTrialLoop.' + paramName)
        
        
        
        #if paramName != carrier:
            
        #thisPracTrialLoop = pracTrialLoop.trialList[0]  # so we can initialise stimuli with some values
        # abbreviate parameter names if possible (e.g. rgb = thisPracTrialLoop.rgb)
        #if thisPracTrialLoop != None:
        #    for paramName in thisPracTrialLoop:
                #print(paramName)
        #        if paramName == carrier:
        #            exec('{} = thisPracTrialLoop[paramName]'.format(paramName))
                    #print("still here " + paramName)
                #else: 
                    #print("deleted " + paramName)
        
        pracCarrier.setText(eval(carrierPrac))
        prac_key_resp = event.BuilderKeyResponse()
        # keep track of which components have finished
        trialComponents = [pracCarrier, prac_key_resp]
        for thisComponent in trialComponents:
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        
        # -------Start Routine "trial"-------
        while continueRoutine and routineTimer.getTime() > 0:
            # get current time
            t = trialClock.getTime()
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            
            # *pracCarrier* updates
            if t >= 0.0 and pracCarrier.status == NOT_STARTED:
                # keep track of start time/frame for later
                pracCarrier.tStart = t
                pracCarrier.frameNStart = frameN  # exact frame index
                pracCarrier.setAutoDraw(True)
            frameRemains = 0.0 + .5- win.monitorFramePeriod * 0.75  # most of one frame period left
            if pracCarrier.status == STARTED and t >= frameRemains:
                pracCarrier.setAutoDraw(False)
            
            # *prac_key_resp* updates
            if t >= 0.0 and prac_key_resp.status == NOT_STARTED:
                # keep track of start time/frame for later
                prac_key_resp.tStart = t
                prac_key_resp.frameNStart = frameN  # exact frame index
                prac_key_resp.status = STARTED
                # keyboard checking is just starting
                event.clearEvents(eventType='keyboard')
            frameRemains = 0.0 + .5- win.monitorFramePeriod * 0.75  # most of one frame period left
            if prac_key_resp.status == STARTED and t >= frameRemains:
                prac_key_resp.status = FINISHED
            if prac_key_resp.status == STARTED:
                theseKeys = event.getKeys(keyList=['y'])
                
                # check for quit:
                if "escape" in theseKeys:
                    endExpNow = True
                if len(theseKeys) > 0:  # at least one key was pressed
                    # a response ends the routine
                    continueRoutine = False
            
            # check for quit (typically the Esc key)
            if endExpNow or event.getKeys(keyList=["escape"]):
                core.quit()
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in trialComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # -------Ending Routine "trial"-------
        for thisComponent in trialComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        #if pracTrialLoop.thisN != 0:
        #    pracLoopCount +=1
        #targetP="pracLists%" %
        thisExp.nextEntry()
        
    # completed 1 repeats of 'pracTrialLoop'
    
    thisExp.nextEntry()
    
# completed 8 repeats of 'pracTarLoop'


# ------Prepare to start Routine "expIns"-------
t = 0
expInsClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
startExpTrials = event.BuilderKeyResponse()
# keep track of which components have finished
expInsComponents = [startExp, startExpTrials]
for thisComponent in expInsComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "expIns"-------
while continueRoutine:
    # get current time
    t = expInsClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *startExp* updates
    if t >= 0.0 and startExp.status == NOT_STARTED:
        # keep track of start time/frame for later
        startExp.tStart = t
        startExp.frameNStart = frameN  # exact frame index
        startExp.setAutoDraw(True)
    
    # *startExpTrials* updates
    if t >= 0.0 and startExpTrials.status == NOT_STARTED:
        # keep track of start time/frame for later
        startExpTrials.tStart = t
        startExpTrials.frameNStart = frameN  # exact frame index
        startExpTrials.status = STARTED
        # keyboard checking is just starting
        event.clearEvents(eventType='keyboard')
    if startExpTrials.status == STARTED:
        theseKeys = event.getKeys(keyList=['space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            # a response ends the routine
            continueRoutine = False
    
    # check for quit (typically the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in expInsComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "expIns"-------
for thisComponent in expInsComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# the Routine "expIns" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
expTarLoop = data.TrialHandler(nReps=0, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions(condition, selection=[0]),
    seed=None, name='expTarLoop')
thisExp.addLoop(expTarLoop)  # add the loop to the experiment
thisExpTarLoop = expTarLoop.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisExpTarLoop.rgb)
if thisExpTarLoop != None:
    for paramName in thisExpTarLoop:
        exec('{} = thisExpTarLoop[paramName]'.format(paramName))

for thisExpTarLoop in expTarLoop:
    currentLoop = expTarLoop
    # abbreviate parameter names if possible (e.g. rgb = thisExpTarLoop.rgb)
    if thisExpTarLoop != None:
        for paramName in thisExpTarLoop:
            exec('{} = thisExpTarLoop[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "targetExp"-------
    t = 0
    targetExpClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    routineTimer.add(0.500000)
    # update component parameters for each repeat
    targetExp= experiment + "%i" %expTarLoop.thisN
    
    expTarget.setText("Encuentre    " + eval(targetExp))
    # keep track of which components have finished
    targetExpComponents = [expTarget]
    for thisComponent in targetExpComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "targetExp"-------
    while continueRoutine and routineTimer.getTime() > 0:
        # get current time
        t = targetExpClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        
        # *expTarget* updates
        if t >= 0.0 and expTarget.status == NOT_STARTED:
            # keep track of start time/frame for later
            expTarget.tStart = t
            expTarget.frameNStart = frameN  # exact frame index
            expTarget.setAutoDraw(True)
        frameRemains = 0.0 + .5- win.monitorFramePeriod * 0.75  # most of one frame period left
        if expTarget.status == STARTED and t >= frameRemains:
            expTarget.setAutoDraw(False)
        
        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in targetExpComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "targetExp"-------
    for thisComponent in targetExpComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    
    
    # set up handler to look after randomisation of conditions etc
    expTrialLoop = data.TrialHandler(nReps=0, method='random', 
        extraInfo=expInfo, originPath=-1,
        trialList=data.importConditions(condition, selection=[1,2,3,4,5,6,7,8,9,10,11,12]),
        seed=None, name='expTrialLoop')
    thisExp.addLoop(expTrialLoop)  # add the loop to the experiment
    thisExpTrialLoop = expTrialLoop.trialList[0]  # so we can initialise stimuli with some values
    # abbreviate parameter names if possible (e.g. rgb = thisExpTrialLoop.rgb)
    if thisExpTrialLoop != None:
        for paramName in thisExpTrialLoop:
            exec('{} = thisExpTrialLoop[paramName]'.format(paramName))
    
    for thisExpTrialLoop in expTrialLoop:
        currentLoop = expTrialLoop
        # abbreviate parameter names if possible (e.g. rgb = thisExpTrialLoop.rgb)
        if thisExpTrialLoop != None:
            for paramName in thisExpTrialLoop:
                exec('{} = thisExpTrialLoop[paramName]'.format(paramName))
        
        # ------Prepare to start Routine "trialExp"-------
        t = 0
        trialExpClock.reset()  # clock
        frameN = -1
        continueRoutine = True
        routineTimer.add(0.500000)
        # update component parameters for each repeat
        carrierExp= experiment + "%i" %expTarLoop.thisN
        expCarrier.setText(eval(carrier2))
        exp_key_resp = event.BuilderKeyResponse()
        # keep track of which components have finished
        trialExpComponents = [expCarrier, exp_key_resp]
        for thisComponent in trialExpComponents:
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        
        # -------Start Routine "trialExp"-------
        while continueRoutine and routineTimer.getTime() > 0:
            # get current time
            t = trialExpClock.getTime()
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            
            # *expCarrier* updates
            if t >= 0.0 and expCarrier.status == NOT_STARTED:
                # keep track of start time/frame for later
                expCarrier.tStart = t
                expCarrier.frameNStart = frameN  # exact frame index
                expCarrier.setAutoDraw(True)
            frameRemains = 0.0 + .5- win.monitorFramePeriod * 0.75  # most of one frame period left
            if expCarrier.status == STARTED and t >= frameRemains:
                expCarrier.setAutoDraw(False)
            
            # *exp_key_resp* updates
            if t >= 0.0 and exp_key_resp.status == NOT_STARTED:
                # keep track of start time/frame for later
                exp_key_resp.tStart = t
                exp_key_resp.frameNStart = frameN  # exact frame index
                exp_key_resp.status = STARTED
                # keyboard checking is just starting
                win.callOnFlip(exp_key_resp.clock.reset)  # t=0 on next screen flip
                event.clearEvents(eventType='keyboard')
            frameRemains = 0.0 + .5- win.monitorFramePeriod * 0.75  # most of one frame period left
            if exp_key_resp.status == STARTED and t >= frameRemains:
                exp_key_resp.status = FINISHED
            if exp_key_resp.status == STARTED:
                theseKeys = event.getKeys(keyList=['y'])
                
                # check for quit:
                if "escape" in theseKeys:
                    endExpNow = True
                if len(theseKeys) > 0:  # at least one key was pressed
                    exp_key_resp.keys = theseKeys[-1]  # just the last key pressed
                    exp_key_resp.rt = exp_key_resp.clock.getTime()
                    # a response ends the routine
                    continueRoutine = False
            
            # check for quit (typically the Esc key)
            if endExpNow or event.getKeys(keyList=["escape"]):
                core.quit()
            
            # check if all components have finished
            if not continueRoutine:  # a component has requested a forced-end of Routine
                break
            continueRoutine = False  # will revert to True if at least one component still running
            for thisComponent in trialExpComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # -------Ending Routine "trialExp"-------
        for thisComponent in trialExpComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
        
        # check responses
        if exp_key_resp.keys in ['', [], None]:  # No response was made
            exp_key_resp.keys=None
        expTrialLoop.addData('exp_key_resp.keys',exp_key_resp.keys)
        if exp_key_resp.keys != None:  # we had a response
            expTrialLoop.addData('exp_key_resp.rt', exp_key_resp.rt)
        thisExp.nextEntry()
        
    # completed 0 repeats of 'expTrialLoop'
    
    thisExp.nextEntry()
    
# completed 0 repeats of 'expTarLoop'


# ------Prepare to start Routine "syllablePracIns"-------
t = 0
syllablePracInsClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
sylPracStart = event.BuilderKeyResponse()
# keep track of which components have finished
syllablePracInsComponents = [instructionSyl, sylPracStart]
for thisComponent in syllablePracInsComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "syllablePracIns"-------
while continueRoutine:
    # get current time
    t = syllablePracInsClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *instructionSyl* updates
    if t >= 0.0 and instructionSyl.status == NOT_STARTED:
        # keep track of start time/frame for later
        instructionSyl.tStart = t
        instructionSyl.frameNStart = frameN  # exact frame index
        instructionSyl.setAutoDraw(True)
    
    # *sylPracStart* updates
    if t >= 0.0 and sylPracStart.status == NOT_STARTED:
        # keep track of start time/frame for later
        sylPracStart.tStart = t
        sylPracStart.frameNStart = frameN  # exact frame index
        sylPracStart.status = STARTED
        # keyboard checking is just starting
        event.clearEvents(eventType='keyboard')
    if sylPracStart.status == STARTED:
        theseKeys = event.getKeys(keyList=['space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            # a response ends the routine
            continueRoutine = False
    
    # check for quit (typically the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in syllablePracInsComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "syllablePracIns"-------
for thisComponent in syllablePracInsComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# the Routine "syllablePracIns" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
sylPracLoop = data.TrialHandler(nReps=0, method='random', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('data/processed_data/exp_files/sylprac.csv'),
    seed=None, name='sylPracLoop')
thisExp.addLoop(sylPracLoop)  # add the loop to the experiment
thisSylPracLoop = sylPracLoop.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisSylPracLoop.rgb)
if thisSylPracLoop != None:
    for paramName in thisSylPracLoop:
        exec('{} = thisSylPracLoop[paramName]'.format(paramName))

for thisSylPracLoop in sylPracLoop:
    currentLoop = sylPracLoop
    # abbreviate parameter names if possible (e.g. rgb = thisSylPracLoop.rgb)
    if thisSylPracLoop != None:
        for paramName in thisSylPracLoop:
            exec('{} = thisSylPracLoop[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "syllablePracTrial"-------
    t = 0
    syllablePracTrialClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    routineTimer.add(4.000000)
    # update component parameters for each repeat
    PracSylTarget.setText(syllabification)
    PracSylAnsCVC.setText(keyCVC)
    PracSylAnsCV.setText(keyCV)
    sylPrac_key_resp = event.BuilderKeyResponse()
    # keep track of which components have finished
    syllablePracTrialComponents = [PracSylTarget, PracSylAnsCVC, PracSylAnsCV, sylPrac_key_resp]
    for thisComponent in syllablePracTrialComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "syllablePracTrial"-------
    while continueRoutine and routineTimer.getTime() > 0:
        # get current time
        t = syllablePracTrialClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *PracSylTarget* updates
        if t >= 0.5 and PracSylTarget.status == NOT_STARTED:
            # keep track of start time/frame for later
            PracSylTarget.tStart = t
            PracSylTarget.frameNStart = frameN  # exact frame index
            PracSylTarget.setAutoDraw(True)
        frameRemains = 0.5 + 1.5- win.monitorFramePeriod * 0.75  # most of one frame period left
        if PracSylTarget.status == STARTED and t >= frameRemains:
            PracSylTarget.setAutoDraw(False)
        
        # *PracSylAnsCVC* updates
        if t >= 2 and PracSylAnsCVC.status == NOT_STARTED:
            # keep track of start time/frame for later
            PracSylAnsCVC.tStart = t
            PracSylAnsCVC.frameNStart = frameN  # exact frame index
            PracSylAnsCVC.setAutoDraw(True)
        frameRemains = 2 + 2- win.monitorFramePeriod * 0.75  # most of one frame period left
        if PracSylAnsCVC.status == STARTED and t >= frameRemains:
            PracSylAnsCVC.setAutoDraw(False)
        
        # *PracSylAnsCV* updates
        if t >= 2 and PracSylAnsCV.status == NOT_STARTED:
            # keep track of start time/frame for later
            PracSylAnsCV.tStart = t
            PracSylAnsCV.frameNStart = frameN  # exact frame index
            PracSylAnsCV.setAutoDraw(True)
        frameRemains = 2 + 2- win.monitorFramePeriod * 0.75  # most of one frame period left
        if PracSylAnsCV.status == STARTED and t >= frameRemains:
            PracSylAnsCV.setAutoDraw(False)
        
        # *sylPrac_key_resp* updates
        if t >= 2 and sylPrac_key_resp.status == NOT_STARTED:
            # keep track of start time/frame for later
            sylPrac_key_resp.tStart = t
            sylPrac_key_resp.frameNStart = frameN  # exact frame index
            sylPrac_key_resp.status = STARTED
            # keyboard checking is just starting
            event.clearEvents(eventType='keyboard')
        frameRemains = 2 + 2- win.monitorFramePeriod * 0.75  # most of one frame period left
        if sylPrac_key_resp.status == STARTED and t >= frameRemains:
            sylPrac_key_resp.status = FINISHED
        if sylPrac_key_resp.status == STARTED:
            theseKeys = event.getKeys(keyList=['1', '2'])
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                # a response ends the routine
                continueRoutine = False
        
        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in syllablePracTrialComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "syllablePracTrial"-------
    for thisComponent in syllablePracTrialComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    thisExp.nextEntry()
    
# completed 0 repeats of 'sylPracLoop'


# ------Prepare to start Routine "syllableExpIns"-------
t = 0
syllableExpInsClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
sylExpStart = event.BuilderKeyResponse()
# keep track of which components have finished
syllableExpInsComponents = [SyllableExpInsText, sylExpStart]
for thisComponent in syllableExpInsComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "syllableExpIns"-------
while continueRoutine:
    # get current time
    t = syllableExpInsClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *SyllableExpInsText* updates
    if t >= 0.0 and SyllableExpInsText.status == NOT_STARTED:
        # keep track of start time/frame for later
        SyllableExpInsText.tStart = t
        SyllableExpInsText.frameNStart = frameN  # exact frame index
        SyllableExpInsText.setAutoDraw(True)
    
    # *sylExpStart* updates
    if t >= 0.0 and sylExpStart.status == NOT_STARTED:
        # keep track of start time/frame for later
        sylExpStart.tStart = t
        sylExpStart.frameNStart = frameN  # exact frame index
        sylExpStart.status = STARTED
        # keyboard checking is just starting
        event.clearEvents(eventType='keyboard')
    if sylExpStart.status == STARTED:
        theseKeys = event.getKeys(keyList=['space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            # a response ends the routine
            continueRoutine = False
    
    # check for quit (typically the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in syllableExpInsComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "syllableExpIns"-------
for thisComponent in syllableExpInsComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# the Routine "syllableExpIns" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
syllableLoop = data.TrialHandler(nReps=0, method='random', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions(syllable),
    seed=None, name='syllableLoop')
thisExp.addLoop(syllableLoop)  # add the loop to the experiment
thisSyllableLoop = syllableLoop.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisSyllableLoop.rgb)
if thisSyllableLoop != None:
    for paramName in thisSyllableLoop:
        exec('{} = thisSyllableLoop[paramName]'.format(paramName))

for thisSyllableLoop in syllableLoop:
    currentLoop = syllableLoop
    # abbreviate parameter names if possible (e.g. rgb = thisSyllableLoop.rgb)
    if thisSyllableLoop != None:
        for paramName in thisSyllableLoop:
            exec('{} = thisSyllableLoop[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "trialSyllable"-------
    t = 0
    trialSyllableClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    routineTimer.add(4.000000)
    # update component parameters for each repeat
    
    AnswerCVC.setText(keyCVC)
    AnswerCV.setText(keyCV)
    Syllable_Target.setText(syllabification)
    sylExp_key_resp = event.BuilderKeyResponse()
    # keep track of which components have finished
    trialSyllableComponents = [AnswerCVC, AnswerCV, Syllable_Target, sylExp_key_resp]
    for thisComponent in trialSyllableComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "trialSyllable"-------
    while continueRoutine and routineTimer.getTime() > 0:
        # get current time
        t = trialSyllableClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        
        # *AnswerCVC* updates
        if t >= 2 and AnswerCVC.status == NOT_STARTED:
            # keep track of start time/frame for later
            AnswerCVC.tStart = t
            AnswerCVC.frameNStart = frameN  # exact frame index
            AnswerCVC.setAutoDraw(True)
        frameRemains = 2 + 2- win.monitorFramePeriod * 0.75  # most of one frame period left
        if AnswerCVC.status == STARTED and t >= frameRemains:
            AnswerCVC.setAutoDraw(False)
        
        # *AnswerCV* updates
        if t >= 2 and AnswerCV.status == NOT_STARTED:
            # keep track of start time/frame for later
            AnswerCV.tStart = t
            AnswerCV.frameNStart = frameN  # exact frame index
            AnswerCV.setAutoDraw(True)
        frameRemains = 2 + 2- win.monitorFramePeriod * 0.75  # most of one frame period left
        if AnswerCV.status == STARTED and t >= frameRemains:
            AnswerCV.setAutoDraw(False)
        
        # *Syllable_Target* updates
        if t >= 0.5 and Syllable_Target.status == NOT_STARTED:
            # keep track of start time/frame for later
            Syllable_Target.tStart = t
            Syllable_Target.frameNStart = frameN  # exact frame index
            Syllable_Target.setAutoDraw(True)
        frameRemains = 0.5 + 1.5- win.monitorFramePeriod * 0.75  # most of one frame period left
        if Syllable_Target.status == STARTED and t >= frameRemains:
            Syllable_Target.setAutoDraw(False)
        
        # *sylExp_key_resp* updates
        if t >= 2 and sylExp_key_resp.status == NOT_STARTED:
            # keep track of start time/frame for later
            sylExp_key_resp.tStart = t
            sylExp_key_resp.frameNStart = frameN  # exact frame index
            sylExp_key_resp.status = STARTED
            # keyboard checking is just starting
            win.callOnFlip(sylExp_key_resp.clock.reset)  # t=0 on next screen flip
            event.clearEvents(eventType='keyboard')
        frameRemains = 2 + 2- win.monitorFramePeriod * 0.75  # most of one frame period left
        if sylExp_key_resp.status == STARTED and t >= frameRemains:
            sylExp_key_resp.status = FINISHED
        if sylExp_key_resp.status == STARTED:
            theseKeys = event.getKeys(keyList=['1', '2'])
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                sylExp_key_resp.keys = theseKeys[-1]  # just the last key pressed
                sylExp_key_resp.rt = sylExp_key_resp.clock.getTime()
                # was this 'correct'?
                if (sylExp_key_resp.keys == str(corrAns)) or (sylExp_key_resp.keys == corrAns):
                    sylExp_key_resp.corr = 1
                else:
                    sylExp_key_resp.corr = 0
                # a response ends the routine
                continueRoutine = False
        
        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in trialSyllableComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "trialSyllable"-------
    for thisComponent in trialSyllableComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    
    # check responses
    if sylExp_key_resp.keys in ['', [], None]:  # No response was made
        sylExp_key_resp.keys=None
        # was no response the correct answer?!
        if str(corrAns).lower() == 'none':
           sylExp_key_resp.corr = 1;  # correct non-response
        else:
           sylExp_key_resp.corr = 0;  # failed to respond (incorrectly)
    # store data for syllableLoop (TrialHandler)
    syllableLoop.addData('sylExp_key_resp.keys',sylExp_key_resp.keys)
    syllableLoop.addData('sylExp_key_resp.corr', sylExp_key_resp.corr)
    if sylExp_key_resp.keys != None:  # we had a response
        syllableLoop.addData('sylExp_key_resp.rt', sylExp_key_resp.rt)
    thisExp.nextEntry()
    
# completed 0 repeats of 'syllableLoop'


# ------Prepare to start Routine "thankYou"-------
t = 0
thankYouClock.reset()  # clock
frameN = -1
continueRoutine = True
routineTimer.add(5.000000)
# update component parameters for each repeat
# keep track of which components have finished
thankYouComponents = [Gracias]
for thisComponent in thankYouComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "thankYou"-------
while continueRoutine and routineTimer.getTime() > 0:
    # get current time
    t = thankYouClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *Gracias* updates
    if t >= 0.0 and Gracias.status == NOT_STARTED:
        # keep track of start time/frame for later
        Gracias.tStart = t
        Gracias.frameNStart = frameN  # exact frame index
        Gracias.setAutoDraw(True)
    frameRemains = 0.0 + 5- win.monitorFramePeriod * 0.75  # most of one frame period left
    if Gracias.status == STARTED and t >= frameRemains:
        Gracias.setAutoDraw(False)
    
    # check for quit (typically the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in thankYouComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "thankYou"-------
for thisComponent in thankYouComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)





# these shouldn't be strictly necessary (should auto-save)
thisExp.saveAsWideText(filename+'.csv')
thisExp.saveAsPickle(filename)
logging.flush()
# make sure everything is closed down
thisExp.abort()  # or data files will save again on exit
win.close()
core.quit()

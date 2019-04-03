#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This experiment was created using PsychoPy3 Experiment Builder (v3.0.5),
    on Fri Mar 15 10:10:51 2019
If you publish work using this script please cite the PsychoPy publications:
    Peirce, JW (2007) PsychoPy - Psychophysics software in Python.
        Journal of Neuroscience Methods, 162(1-2), 8-13.
    Peirce, JW (2009) Generating stimuli for neuroscience using PsychoPy.
        Frontiers in Neuroinformatics, 2:10. doi: 10.3389/neuro.11.010.2008
"""

from __future__ import absolute_import, division
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
expName = 'decision_lexica_visual'  # from the Builder filename that created this script
expInfo = {'participant': ''}
dlg = gui.DlgFromDict(dictionary=expInfo, title=expName)
if dlg.OK == False:
    core.quit()  # user pressed cancel
expInfo['date'] = data.getDateStr()  # add a simple timestamp
expInfo['expName'] = expName
expInfo['psychopyVersion'] = psychopyVersion

# Data file name stem = absolute path + name; later add .psyexp, .csv, .log, etc
filename = _thisDir + os.sep + u'data' + os.sep + '%s_%s' %(expInfo['participant'], expInfo['date'])

# An ExperimentHandler isn't essential but helps with data saving
thisExp = data.ExperimentHandler(name=expName, version='',
    extraInfo=expInfo, runtimeInfo=None,
    originPath='/Users/drakeasberry/Desktop/psychoPyLexTALE-ENG/alextale_lastrun.py',
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
    monitor='testMonitor', color=[1.000,1.000,1.000], colorSpace='rgb',
    blendMode='avg', useFBO=True)
# store frame rate of monitor if we can measure it
expInfo['frameRate'] = win.getActualFrameRate()
if expInfo['frameRate'] != None:
    frameDur = 1.0 / round(expInfo['frameRate'])
else:
    frameDur = 1.0 / 60.0  # could not measure, so guess

# Initialize components for Routine "instrucciones"
instruccionesClock = core.Clock()
lexEsp_Instr = visual.TextStim(win=win, name='lexEsp_Instr',
    text="This test consists of 90 trials, in each of which you will see a string letters. \nYour task is to decide whether this is an existing Spanish word or not. \nIf you think it is an existing Spanish word, press 's' for 'yes' and if you think it is not an existing Spanish word, press 'n' for 'no'.\nIf you are sure that the word exists, even if you don't know its exact meaning, you may still respond 'yes'. \nBut if you are not sure if it is an existing word, you should respond 'no'. \nYou have as much time as you like for each decision. \nPress space bar to start. ",
    font='Arial',
    pos=[0, 0], height=0.05, wrapWidth=None, ori=0, 
    color='black', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);

# Initialize components for Routine "pruebas"
pruebasClock = core.Clock()
text_Word = visual.TextStim(win=win, name='text_Word',
    text='default text',
    font='Arial',
    pos=[0, 0.5], height=0.2, wrapWidth=None, ori=0, 
    color='black', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);
text_Si = visual.TextStim(win=win, name='text_Si',
    text='sí',
    font='Arial',
    pos=[-0.5, -0.5], height=0.2, wrapWidth=None, ori=0, 
    color='green', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);
text_No = visual.TextStim(win=win, name='text_No',
    text='no',
    font='Arial',
    pos=[0.5, -0.5], height=0.2, wrapWidth=None, ori=0, 
    color='red', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-2.0);

# Initialize components for Routine "cierre"
cierreClock = core.Clock()
text_Closing = visual.TextStim(win=win, name='text_Closing',
    text='gracias',
    font='Arial',
    pos=[0, 0], height=0.07, wrapWidth=None, ori=0, 
    color='black', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

# Create some handy timers
globalClock = core.Clock()  # to track the time since experiment started
routineTimer = core.CountdownTimer()  # to track time remaining of each (non-slip) routine 

# ------Prepare to start Routine "instrucciones"-------
t = 0
instruccionesClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
start_LexEsp = event.BuilderKeyResponse()
# keep track of which components have finished
instruccionesComponents = [start_LexEsp, lexEsp_Instr]
for thisComponent in instruccionesComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "instrucciones"-------
while continueRoutine:
    # get current time
    t = instruccionesClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *start_LexEsp* updates
    if t >= 0.0 and start_LexEsp.status == NOT_STARTED:
        # keep track of start time/frame for later
        start_LexEsp.tStart = t
        start_LexEsp.frameNStart = frameN  # exact frame index
        start_LexEsp.status = STARTED
        # keyboard checking is just starting
    if start_LexEsp.status == STARTED:
        theseKeys = event.getKeys(keyList=['space'])
        
        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            # a response ends the routine
            continueRoutine = False
    
    # *lexEsp_Instr* updates
    if t >= 0.0 and lexEsp_Instr.status == NOT_STARTED:
        # keep track of start time/frame for later
        lexEsp_Instr.tStart = t
        lexEsp_Instr.frameNStart = frameN  # exact frame index
        lexEsp_Instr.setAutoDraw(True)
    
    # check for quit (typically the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()
    
    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in instruccionesComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "instrucciones"-------
for thisComponent in instruccionesComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# the Routine "instrucciones" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
ciclo = data.TrialHandler(nReps=1, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('LexEng.csv'),
    seed=None, name='ciclo')
thisExp.addLoop(ciclo)  # add the loop to the experiment
thisCiclo = ciclo.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisCiclo.rgb)
if thisCiclo != None:
    for paramName in thisCiclo:
        exec('{} = thisCiclo[paramName]'.format(paramName))

for thisCiclo in ciclo:
    currentLoop = ciclo
    # abbreviate parameter names if possible (e.g. rgb = thisCiclo.rgb)
    if thisCiclo != None:
        for paramName in thisCiclo:
            exec('{} = thisCiclo[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "pruebas"-------
    t = 0
    pruebasClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    text_Word.setText(Word)
    lexEsp_key_resp = event.BuilderKeyResponse()
    # keep track of which components have finished
    pruebasComponents = [text_Word, text_Si, text_No, lexEsp_key_resp]
    for thisComponent in pruebasComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "pruebas"-------
    while continueRoutine:
        # get current time
        t = pruebasClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *text_Word* updates
        if t >= 0.2 and text_Word.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_Word.tStart = t
            text_Word.frameNStart = frameN  # exact frame index
            text_Word.setAutoDraw(True)
        
        # *text_Si* updates
        if t >= 0.2 and text_Si.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_Si.tStart = t
            text_Si.frameNStart = frameN  # exact frame index
            text_Si.setAutoDraw(True)
        
        # *text_No* updates
        if t >= 0.2 and text_No.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_No.tStart = t
            text_No.frameNStart = frameN  # exact frame index
            text_No.setAutoDraw(True)
        
        # *lexEsp_key_resp* updates
        if t >= 0.2 and lexEsp_key_resp.status == NOT_STARTED:
            # keep track of start time/frame for later
            lexEsp_key_resp.tStart = t
            lexEsp_key_resp.frameNStart = frameN  # exact frame index
            lexEsp_key_resp.status = STARTED
            # keyboard checking is just starting
            lexEsp_key_resp.clock.reset()  # now t=0
        if lexEsp_key_resp.status == STARTED:
            theseKeys = event.getKeys(keyList=['0', '1'])
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                if lexEsp_key_resp.keys == []:  # then this was the first keypress
                    lexEsp_key_resp.keys = theseKeys[0]  # just the first key pressed
                    lexEsp_key_resp.rt = lexEsp_key_resp.clock.getTime()
                    # was this 'correct'?
                    if (lexEsp_key_resp.keys == str(corrAnsEngV)) or (lexEsp_key_resp.keys == corrAnsEngV):
                        lexEsp_key_resp.corr = 1
                    else:
                        lexEsp_key_resp.corr = 0
                    # a response ends the routine
                    continueRoutine = False
        
        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in pruebasComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "pruebas"-------
    for thisComponent in pruebasComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # check responses
    if lexEsp_key_resp.keys in ['', [], None]:  # No response was made
        lexEsp_key_resp.keys=None
        # was no response the correct answer?!
        if str(corrAnsEngV).lower() == 'none':
           lexEsp_key_resp.corr = 1;  # correct non-response
        else:
           lexEsp_key_resp.corr = 0;  # failed to respond (incorrectly)
    # store data for ciclo (TrialHandler)
    ciclo.addData('lexEsp_key_resp.keys',lexEsp_key_resp.keys)
    ciclo.addData('lexEsp_key_resp.corr', lexEsp_key_resp.corr)
    if lexEsp_key_resp.keys != None:  # we had a response
        ciclo.addData('lexEsp_key_resp.rt', lexEsp_key_resp.rt)
    # the Routine "pruebas" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()
    
# completed 1 repeats of 'ciclo'

# get names of stimulus parameters
if ciclo.trialList in ([], [None], None):
    params = []
else:
    params = ciclo.trialList[0].keys()
# save data for this loop
ciclo.saveAsExcel(filename + '.xlsx', sheetName='ciclo',
    stimOut=params,
    dataOut=['n','all_mean','all_std', 'all_raw'])
ciclo.saveAsText(filename + 'ciclo.csv', delim=',',
    stimOut=params,
    dataOut=['n','all_mean','all_std', 'all_raw'])

# ------Prepare to start Routine "cierre"-------
t = 0
cierreClock.reset()  # clock
frameN = -1
continueRoutine = True
routineTimer.add(5.000000)
# update component parameters for each repeat
key_resp_3 = event.BuilderKeyResponse()
# keep track of which components have finished
cierreComponents = [text_Closing, key_resp_3]
for thisComponent in cierreComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "cierre"-------
while continueRoutine and routineTimer.getTime() > 0:
    # get current time
    t = cierreClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text_Closing* updates
    if t >= 0.0 and text_Closing.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_Closing.tStart = t
        text_Closing.frameNStart = frameN  # exact frame index
        text_Closing.setAutoDraw(True)
    frameRemains = 0.0 + 5.0- win.monitorFramePeriod * 0.75  # most of one frame period left
    if text_Closing.status == STARTED and t >= frameRemains:
        text_Closing.setAutoDraw(False)
    
    # *key_resp_3* updates
    if t >= 0.0 and key_resp_3.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_3.tStart = t
        key_resp_3.frameNStart = frameN  # exact frame index
        key_resp_3.status = STARTED
        # keyboard checking is just starting
    frameRemains = 0.0 + 5.0- win.monitorFramePeriod * 0.75  # most of one frame period left
    if key_resp_3.status == STARTED and t >= frameRemains:
        key_resp_3.status = FINISHED
    if key_resp_3.status == STARTED:
        theseKeys = event.getKeys(keyList=['y', 'n', 'left', 'right', 'space'])
        
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
    for thisComponent in cierreComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "cierre"-------
for thisComponent in cierreComponents:
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

#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This experiment was created using PsychoPy3 Experiment Builder (v3.0.5),
    on Mon Apr  8 16:12:50 2019
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
expName = 'blp'  # from the Builder filename that created this script
expInfo = {'Preferred Language': ['español', 'inglés'], 'Participant': '', 'Country': '', 'Age': '', 'Highest level of ed': '', 'Gender': '', 'Place of residence': 'city,state'}
dlg = gui.DlgFromDict(dictionary=expInfo, title=expName)
if dlg.OK == False:
    core.quit()  # user pressed cancel
expInfo['date'] = data.getDateStr()  # add a simple timestamp
expInfo['expName'] = expName
expInfo['psychopyVersion'] = psychopyVersion

# Data file name stem = absolute path + name; later add .psyexp, .csv, .log, etc
filename = _thisDir + os.sep + u'data/%s_%s_%s' % (expInfo['Participant'], expName, expInfo['date'])

# An ExperimentHandler isn't essential but helps with data saving
thisExp = data.ExperimentHandler(name=expName, version='',
    extraInfo=expInfo, runtimeInfo=None,
    originPath='/Users/drakeasberry/github/Dissertation/Dissertation_Experiments/basicLangProfile/blp_coder_lastrun.py',
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
    allowGUI=True, allowStencil=False,
    monitor='testMonitor', color=[0,0,0], colorSpace='rgb',
    blendMode='avg', useFBO=True)
# store frame rate of monitor if we can measure it
expInfo['frameRate'] = win.getActualFrameRate()
if expInfo['frameRate'] != None:
    frameDur = 1.0 / round(expInfo['frameRate'])
else:
    frameDur = 1.0 / 60.0  # could not measure, so guess

# Initialize components for Routine "instructions"
instructionsClock = core.Clock()
text_instructions = visual.TextStim(win=win, name='text_instructions',
    text='We would like to ask you to help us by answering the following questions concerning your language history, use, attitudes, and proficiency. This survey was created with support from the Center for Open Educational Resources and Language Learning at the University of Texas at Austin to better understand the profiles of bilingual speakers in diverse settings with diverse backgrounds. The survey consists of 19 questions and will take less than 10 minutes to complete. This is not a test, so there are no right or wrong answers. Please answer every question and give your answers sincerely. Thank you very much for your help.',
    font='Arial',
    pos=(0, 0), height=0.07, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);
'''from psychopy import gui

myDlg = gui.Dlg(title="JWP's experiment")
myDlg.addText('Subject info')
myDlg.addField('Name:')
myDlg.addField('Age:', 21)
myDlg.addText('Experiment Info')
myDlg.addField('Grating Ori:',45)
myDlg.addField('Group:', choices=["Test", "Control"])
ok_data = myDlg.show()  # show dialog and wait for OK or Cancel
if myDlg.OK:  # or if ok_data is not None
    print(ok_data)
else:
    print('user cancelled')'''

# Initialize components for Routine "lang_hist_ins"
lang_hist_insClock = core.Clock()
text_lang_his_ins = visual.TextStim(win=win, name='text_lang_his_ins',
    text='Language history\n\nIn this section, we would like you to answer some factual questions about your language history by placing a check in the appropriate box.\n\nPress the spacebar to begin.',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

# Initialize components for Routine "language_history"
language_historyClock = core.Clock()
text_section_lang_hist = visual.TextStim(win=win, name='text_section_lang_hist',
    text='default text',
    font='Arial',
    pos=(0, 0.75), height=0.1, wrapWidth=None, ori=0, 
    color='black', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);
text_lang_hist_question = visual.TextStim(win=win, name='text_lang_hist_question',
    text='default text',
    font='Arial',
    pos=(0, 0.4), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);
text_lang_hist_lang = visual.TextStim(win=win, name='text_lang_hist_lang',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='blue', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-2.0);
text_lang_hist_qnum = visual.TextStim(win=win, name='text_lang_hist_qnum',
    text='default text',
    font='Arial',
    pos=(-0.9, 0.9), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-3.0);
rating_lang_hist = visual.RatingScale(win=win, name='rating_lang_hist', marker='triangle', size=1.5, pos=[0.0, -0.3], choices=['Since Birth', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20+'], tickHeight=-1, markerStart='10')

# Initialize components for Routine "lang_use_ins"
lang_use_insClock = core.Clock()
text_lang_use_ins = visual.TextStim(win=win, name='text_lang_use_ins',
    text='Language use\n\nIn this section, we would like you to answer some questions about your language use by placing a check in the appropriate box. Total use for all languages in a given question should equal 100%.\n\nPress the spacebar to begin.',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

# Initialize components for Routine "language_use"
language_useClock = core.Clock()
text_section_lang_use = visual.TextStim(win=win, name='text_section_lang_use',
    text='default text',
    font='Arial',
    pos=(0, 0.75), height=0.1, wrapWidth=None, ori=0, 
    color='black', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);
text_lang_use_question = visual.TextStim(win=win, name='text_lang_use_question',
    text='default text',
    font='Arial',
    pos=(0, 0.4), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);
text_lang_use_lang = visual.TextStim(win=win, name='text_lang_use_lang',
    text='default text',
    font='Arial',
    pos=(0, 0.1), height=0.1, wrapWidth=None, ori=0, 
    color='blue', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-2.0);
text_lang_use_qnum = visual.TextStim(win=win, name='text_lang_use_qnum',
    text='default text',
    font='Arial',
    pos=(-0.9, 0.9), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-3.0);
rating_lang_use = visual.RatingScale(win=win, name='rating_lang_use', marker='triangle', size=1.5, pos=[0.0, -0.1], choices=['0', '10', '20', '40', '50', '60', '70', '80', '90', '100'], tickHeight=-1)

# Initialize components for Routine "lang_prof_ins"
lang_prof_insClock = core.Clock()
text_lang_prof_ins = visual.TextStim(win=win, name='text_lang_prof_ins',
    text='Language proficiency\n\nIn this section, we would like you to rate your language proficiency by giving marks from 0 to 6.\n\nPress the spacebar to begin',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

# Initialize components for Routine "language_proficiency"
language_proficiencyClock = core.Clock()
text_section_lang_prof = visual.TextStim(win=win, name='text_section_lang_prof',
    text='default text',
    font='Arial',
    pos=(0, 0.75), height=0.1, wrapWidth=None, ori=0, 
    color='black', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);
text_lang_prof_question = visual.TextStim(win=win, name='text_lang_prof_question',
    text='default text',
    font='Arial',
    pos=(0, 0.4), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);
text_lang_prof_lang = visual.TextStim(win=win, name='text_lang_prof_lang',
    text='default text',
    font='Arial',
    pos=(0.0, 0.1), height=0.1, wrapWidth=None, ori=0, 
    color='blue', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-2.0);
text_lang_prof_qnum = visual.TextStim(win=win, name='text_lang_prof_qnum',
    text='default text',
    font='Arial',
    pos=(-0.9, 0.9), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-3.0);
text_lang_prof_qmark = visual.TextStim(win=win, name='text_lang_prof_qmark',
    text='default text',
    font='Arial',
    pos=(0.17, 0.1), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-4.0);
rating_lang_prof = visual.RatingScale(win=win, name='rating_lang_prof', marker='triangle', size=1.5, pos=[0.0, -0.1], choices=['0', '1', '2', '3', '4', '5', '6'], tickHeight=-1)

# Initialize components for Routine "lang_att_ins"
lang_att_insClock = core.Clock()
text_lang_att_ins = visual.TextStim(win=win, name='text_lang_att_ins',
    text='Language attitudes\n\nIn this section, we would like you to respond to statements about language attitudes by giving marks from 0-6.\n\nPress the spacebar to begin.',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

# Initialize components for Routine "language_attitudes"
language_attitudesClock = core.Clock()
text_lang_att_section = visual.TextStim(win=win, name='text_lang_att_section',
    text='default text',
    font='Arial',
    pos=(0, 0.75), height=0.1, wrapWidth=None, ori=0, 
    color='black', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);
text_lang_att_ques = visual.TextStim(win=win, name='text_lang_att_ques',
    text='default text',
    font='Arial',
    pos=(0, .4), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);
text_lang_att_qnum = visual.TextStim(win=win, name='text_lang_att_qnum',
    text='default text',
    font='Arial',
    pos=(-0.9, 0.9), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-2.0);
rating_lang_att = visual.RatingScale(win=win, name='rating_lang_att', marker='triangle', size=1.5, pos=[0.0, 0.0], choices=['0', '1', '2', '3', '4', '5', '6'], tickHeight=-1)

# Create some handy timers
globalClock = core.Clock()  # to track the time since experiment started
routineTimer = core.CountdownTimer()  # to track time remaining of each (non-slip) routine 

# ------Prepare to start Routine "instructions"-------
t = 0
instructionsClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_instructions = event.BuilderKeyResponse()

# keep track of which components have finished
instructionsComponents = [text_instructions, key_resp_instructions]
for thisComponent in instructionsComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "instructions"-------
while continueRoutine:
    # get current time
    t = instructionsClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text_instructions* updates
    if t >= 0.0 and text_instructions.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_instructions.tStart = t
        text_instructions.frameNStart = frameN  # exact frame index
        text_instructions.setAutoDraw(True)
    
    # *key_resp_instructions* updates
    if t >= 0.0 and key_resp_instructions.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_instructions.tStart = t
        key_resp_instructions.frameNStart = frameN  # exact frame index
        key_resp_instructions.status = STARTED
        # keyboard checking is just starting
        event.clearEvents(eventType='keyboard')
    if key_resp_instructions.status == STARTED:
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
    for thisComponent in instructionsComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "instructions"-------
for thisComponent in instructionsComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)

# the Routine "instructions" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "lang_hist_ins"-------
t = 0
lang_hist_insClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_lang_hist = event.BuilderKeyResponse()
# keep track of which components have finished
lang_hist_insComponents = [text_lang_his_ins, key_resp_lang_hist]
for thisComponent in lang_hist_insComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "lang_hist_ins"-------
while continueRoutine:
    # get current time
    t = lang_hist_insClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text_lang_his_ins* updates
    if t >= 0.0 and text_lang_his_ins.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_lang_his_ins.tStart = t
        text_lang_his_ins.frameNStart = frameN  # exact frame index
        text_lang_his_ins.setAutoDraw(True)
    
    # *key_resp_lang_hist* updates
    if t >= 0.0 and key_resp_lang_hist.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_lang_hist.tStart = t
        key_resp_lang_hist.frameNStart = frameN  # exact frame index
        key_resp_lang_hist.status = STARTED
        # keyboard checking is just starting
        event.clearEvents(eventType='keyboard')
    if key_resp_lang_hist.status == STARTED:
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
    for thisComponent in lang_hist_insComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "lang_hist_ins"-------
for thisComponent in lang_hist_insComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# the Routine "lang_hist_ins" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
trials = data.TrialHandler(nReps=1, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('condition_file/sp_en_trials.csv', selection='0:12'),
    seed=None, name='trials')
thisExp.addLoop(trials)  # add the loop to the experiment
thisTrial = trials.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisTrial.rgb)
if thisTrial != None:
    for paramName in thisTrial:
        exec('{} = thisTrial[paramName]'.format(paramName))

for thisTrial in trials:
    currentLoop = trials
    # abbreviate parameter names if possible (e.g. rgb = thisTrial.rgb)
    if thisTrial != None:
        for paramName in thisTrial:
            exec('{} = thisTrial[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "language_history"-------
    t = 0
    language_historyClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    text_section_lang_hist.setText(sectionEng
)
    text_lang_hist_question.setText(questionTextEng)
    text_lang_hist_lang.setText(languageEng)
    text_lang_hist_qnum.setText(questionNum)
    rating_lang_hist.reset()
    # keep track of which components have finished
    language_historyComponents = [text_section_lang_hist, text_lang_hist_question, text_lang_hist_lang, text_lang_hist_qnum, rating_lang_hist]
    for thisComponent in language_historyComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "language_history"-------
    while continueRoutine:
        # get current time
        t = language_historyClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *text_section_lang_hist* updates
        if t >= 0.0 and text_section_lang_hist.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_section_lang_hist.tStart = t
            text_section_lang_hist.frameNStart = frameN  # exact frame index
            text_section_lang_hist.setAutoDraw(True)
        
        # *text_lang_hist_question* updates
        if t >= 0.0 and text_lang_hist_question.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_hist_question.tStart = t
            text_lang_hist_question.frameNStart = frameN  # exact frame index
            text_lang_hist_question.setAutoDraw(True)
        
        # *text_lang_hist_lang* updates
        if t >= 0.0 and text_lang_hist_lang.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_hist_lang.tStart = t
            text_lang_hist_lang.frameNStart = frameN  # exact frame index
            text_lang_hist_lang.setAutoDraw(True)
        
        # *text_lang_hist_qnum* updates
        if t >= 0.0 and text_lang_hist_qnum.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_hist_qnum.tStart = t
            text_lang_hist_qnum.frameNStart = frameN  # exact frame index
            text_lang_hist_qnum.setAutoDraw(True)
        # *rating_lang_hist* updates
        if t >= 0.0 and rating_lang_hist.status == NOT_STARTED:
            # keep track of start time/frame for later
            rating_lang_hist.tStart = t
            rating_lang_hist.frameNStart = frameN  # exact frame index
            rating_lang_hist.setAutoDraw(True)
        continueRoutine &= rating_lang_hist.noResponse  # a response ends the trial
        
        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in language_historyComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "language_history"-------
    for thisComponent in language_historyComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # store data for trials (TrialHandler)
    trials.addData('rating_lang_hist.response', rating_lang_hist.getRating())
    trials.addData('rating_lang_hist.rt', rating_lang_hist.getRT())
    # the Routine "language_history" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()
    
# completed 1 repeats of 'trials'


# ------Prepare to start Routine "lang_use_ins"-------
t = 0
lang_use_insClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_lang_use = event.BuilderKeyResponse()
# keep track of which components have finished
lang_use_insComponents = [text_lang_use_ins, key_resp_lang_use]
for thisComponent in lang_use_insComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "lang_use_ins"-------
while continueRoutine:
    # get current time
    t = lang_use_insClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text_lang_use_ins* updates
    if t >= 0.0 and text_lang_use_ins.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_lang_use_ins.tStart = t
        text_lang_use_ins.frameNStart = frameN  # exact frame index
        text_lang_use_ins.setAutoDraw(True)
    
    # *key_resp_lang_use* updates
    if t >= 0.0 and key_resp_lang_use.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_lang_use.tStart = t
        key_resp_lang_use.frameNStart = frameN  # exact frame index
        key_resp_lang_use.status = STARTED
        # keyboard checking is just starting
        event.clearEvents(eventType='keyboard')
    if key_resp_lang_use.status == STARTED:
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
    for thisComponent in lang_use_insComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "lang_use_ins"-------
for thisComponent in lang_use_insComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# the Routine "lang_use_ins" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
trials_use = data.TrialHandler(nReps=1, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('condition_file/sp_en_trials.csv', selection='12:27'),
    seed=None, name='trials_use')
thisExp.addLoop(trials_use)  # add the loop to the experiment
thisTrials_use = trials_use.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisTrials_use.rgb)
if thisTrials_use != None:
    for paramName in thisTrials_use:
        exec('{} = thisTrials_use[paramName]'.format(paramName))

for thisTrials_use in trials_use:
    currentLoop = trials_use
    # abbreviate parameter names if possible (e.g. rgb = thisTrials_use.rgb)
    if thisTrials_use != None:
        for paramName in thisTrials_use:
            exec('{} = thisTrials_use[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "language_use"-------
    t = 0
    language_useClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    text_section_lang_use.setText(section)
    text_lang_use_question.setText(questionText)
    text_lang_use_lang.setText(language)
    text_lang_use_qnum.setText(questionNum)
    rating_lang_use.reset()
    # keep track of which components have finished
    language_useComponents = [text_section_lang_use, text_lang_use_question, text_lang_use_lang, text_lang_use_qnum, rating_lang_use]
    for thisComponent in language_useComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "language_use"-------
    while continueRoutine:
        # get current time
        t = language_useClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *text_section_lang_use* updates
        if t >= 0.0 and text_section_lang_use.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_section_lang_use.tStart = t
            text_section_lang_use.frameNStart = frameN  # exact frame index
            text_section_lang_use.setAutoDraw(True)
        
        # *text_lang_use_question* updates
        if t >= 0.0 and text_lang_use_question.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_use_question.tStart = t
            text_lang_use_question.frameNStart = frameN  # exact frame index
            text_lang_use_question.setAutoDraw(True)
        
        # *text_lang_use_lang* updates
        if t >= 0.0 and text_lang_use_lang.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_use_lang.tStart = t
            text_lang_use_lang.frameNStart = frameN  # exact frame index
            text_lang_use_lang.setAutoDraw(True)
        
        # *text_lang_use_qnum* updates
        if t >= 0.0 and text_lang_use_qnum.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_use_qnum.tStart = t
            text_lang_use_qnum.frameNStart = frameN  # exact frame index
            text_lang_use_qnum.setAutoDraw(True)
        # *rating_lang_use* updates
        if t >= 0.0 and rating_lang_use.status == NOT_STARTED:
            # keep track of start time/frame for later
            rating_lang_use.tStart = t
            rating_lang_use.frameNStart = frameN  # exact frame index
            rating_lang_use.setAutoDraw(True)
        continueRoutine &= rating_lang_use.noResponse  # a response ends the trial
        
        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in language_useComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "language_use"-------
    for thisComponent in language_useComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # store data for trials_use (TrialHandler)
    trials_use.addData('rating_lang_use.response', rating_lang_use.getRating())
    trials_use.addData('rating_lang_use.rt', rating_lang_use.getRT())
    # the Routine "language_use" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()
    
# completed 1 repeats of 'trials_use'


# ------Prepare to start Routine "lang_prof_ins"-------
t = 0
lang_prof_insClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_lang_prof_ins = event.BuilderKeyResponse()
# keep track of which components have finished
lang_prof_insComponents = [text_lang_prof_ins, key_resp_lang_prof_ins]
for thisComponent in lang_prof_insComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "lang_prof_ins"-------
while continueRoutine:
    # get current time
    t = lang_prof_insClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text_lang_prof_ins* updates
    if t >= 0.0 and text_lang_prof_ins.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_lang_prof_ins.tStart = t
        text_lang_prof_ins.frameNStart = frameN  # exact frame index
        text_lang_prof_ins.setAutoDraw(True)
    
    # *key_resp_lang_prof_ins* updates
    if t >= 0.0 and key_resp_lang_prof_ins.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_lang_prof_ins.tStart = t
        key_resp_lang_prof_ins.frameNStart = frameN  # exact frame index
        key_resp_lang_prof_ins.status = STARTED
        # keyboard checking is just starting
        event.clearEvents(eventType='keyboard')
    if key_resp_lang_prof_ins.status == STARTED:
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
    for thisComponent in lang_prof_insComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "lang_prof_ins"-------
for thisComponent in lang_prof_insComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# the Routine "lang_prof_ins" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
trials_prof = data.TrialHandler(nReps=1, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('condition_file/sp_en_trials.csv', selection='27:35'),
    seed=None, name='trials_prof')
thisExp.addLoop(trials_prof)  # add the loop to the experiment
thisTrials_prof = trials_prof.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisTrials_prof.rgb)
if thisTrials_prof != None:
    for paramName in thisTrials_prof:
        exec('{} = thisTrials_prof[paramName]'.format(paramName))

for thisTrials_prof in trials_prof:
    currentLoop = trials_prof
    # abbreviate parameter names if possible (e.g. rgb = thisTrials_prof.rgb)
    if thisTrials_prof != None:
        for paramName in thisTrials_prof:
            exec('{} = thisTrials_prof[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "language_proficiency"-------
    t = 0
    language_proficiencyClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    text_section_lang_prof.setText(section)
    text_lang_prof_question.setText(questionText)
    text_lang_prof_lang.setText(language)
    text_lang_prof_qnum.setText(questionNum)
    text_lang_prof_qmark.setText('?')
    rating_lang_prof.reset()
    # keep track of which components have finished
    language_proficiencyComponents = [text_section_lang_prof, text_lang_prof_question, text_lang_prof_lang, text_lang_prof_qnum, text_lang_prof_qmark, rating_lang_prof]
    for thisComponent in language_proficiencyComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "language_proficiency"-------
    while continueRoutine:
        # get current time
        t = language_proficiencyClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *text_section_lang_prof* updates
        if t >= 0.0 and text_section_lang_prof.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_section_lang_prof.tStart = t
            text_section_lang_prof.frameNStart = frameN  # exact frame index
            text_section_lang_prof.setAutoDraw(True)
        
        # *text_lang_prof_question* updates
        if t >= 0.0 and text_lang_prof_question.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_prof_question.tStart = t
            text_lang_prof_question.frameNStart = frameN  # exact frame index
            text_lang_prof_question.setAutoDraw(True)
        
        # *text_lang_prof_lang* updates
        if t >= 0.0 and text_lang_prof_lang.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_prof_lang.tStart = t
            text_lang_prof_lang.frameNStart = frameN  # exact frame index
            text_lang_prof_lang.setAutoDraw(True)
        
        # *text_lang_prof_qnum* updates
        if t >= 0.0 and text_lang_prof_qnum.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_prof_qnum.tStart = t
            text_lang_prof_qnum.frameNStart = frameN  # exact frame index
            text_lang_prof_qnum.setAutoDraw(True)
        
        # *text_lang_prof_qmark* updates
        if t >= 0.0 and text_lang_prof_qmark.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_prof_qmark.tStart = t
            text_lang_prof_qmark.frameNStart = frameN  # exact frame index
            text_lang_prof_qmark.setAutoDraw(True)
        # *rating_lang_prof* updates
        if t >= 0.0 and rating_lang_prof.status == NOT_STARTED:
            # keep track of start time/frame for later
            rating_lang_prof.tStart = t
            rating_lang_prof.frameNStart = frameN  # exact frame index
            rating_lang_prof.setAutoDraw(True)
        continueRoutine &= rating_lang_prof.noResponse  # a response ends the trial
        
        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in language_proficiencyComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "language_proficiency"-------
    for thisComponent in language_proficiencyComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # store data for trials_prof (TrialHandler)
    trials_prof.addData('rating_lang_prof.response', rating_lang_prof.getRating())
    trials_prof.addData('rating_lang_prof.rt', rating_lang_prof.getRT())
    # the Routine "language_proficiency" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()
    
# completed 1 repeats of 'trials_prof'


# ------Prepare to start Routine "lang_att_ins"-------
t = 0
lang_att_insClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_lang_att_ins = event.BuilderKeyResponse()
# keep track of which components have finished
lang_att_insComponents = [text_lang_att_ins, key_resp_lang_att_ins]
for thisComponent in lang_att_insComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "lang_att_ins"-------
while continueRoutine:
    # get current time
    t = lang_att_insClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *text_lang_att_ins* updates
    if t >= 0.0 and text_lang_att_ins.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_lang_att_ins.tStart = t
        text_lang_att_ins.frameNStart = frameN  # exact frame index
        text_lang_att_ins.setAutoDraw(True)
    
    # *key_resp_lang_att_ins* updates
    if t >= 0.0 and key_resp_lang_att_ins.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_lang_att_ins.tStart = t
        key_resp_lang_att_ins.frameNStart = frameN  # exact frame index
        key_resp_lang_att_ins.status = STARTED
        # keyboard checking is just starting
        event.clearEvents(eventType='keyboard')
    if key_resp_lang_att_ins.status == STARTED:
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
    for thisComponent in lang_att_insComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "lang_att_ins"-------
for thisComponent in lang_att_insComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# the Routine "lang_att_ins" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
trials_att = data.TrialHandler(nReps=1, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('condition_file/sp_en_trials.csv', selection='35:43'),
    seed=None, name='trials_att')
thisExp.addLoop(trials_att)  # add the loop to the experiment
thisTrials_att = trials_att.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisTrials_att.rgb)
if thisTrials_att != None:
    for paramName in thisTrials_att:
        exec('{} = thisTrials_att[paramName]'.format(paramName))

for thisTrials_att in trials_att:
    currentLoop = trials_att
    # abbreviate parameter names if possible (e.g. rgb = thisTrials_att.rgb)
    if thisTrials_att != None:
        for paramName in thisTrials_att:
            exec('{} = thisTrials_att[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "language_attitudes"-------
    t = 0
    language_attitudesClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    text_lang_att_section.setText(section)
    text_lang_att_ques.setText(questionText)
    text_lang_att_qnum.setText(questionNum)
    rating_lang_att.reset()
    # keep track of which components have finished
    language_attitudesComponents = [text_lang_att_section, text_lang_att_ques, text_lang_att_qnum, rating_lang_att]
    for thisComponent in language_attitudesComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "language_attitudes"-------
    while continueRoutine:
        # get current time
        t = language_attitudesClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *text_lang_att_section* updates
        if t >= 0.0 and text_lang_att_section.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_att_section.tStart = t
            text_lang_att_section.frameNStart = frameN  # exact frame index
            text_lang_att_section.setAutoDraw(True)
        
        # *text_lang_att_ques* updates
        if t >= 0.0 and text_lang_att_ques.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_att_ques.tStart = t
            text_lang_att_ques.frameNStart = frameN  # exact frame index
            text_lang_att_ques.setAutoDraw(True)
        
        # *text_lang_att_qnum* updates
        if t >= 0.0 and text_lang_att_qnum.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_att_qnum.tStart = t
            text_lang_att_qnum.frameNStart = frameN  # exact frame index
            text_lang_att_qnum.setAutoDraw(True)
        # *rating_lang_att* updates
        if t >= 0.0 and rating_lang_att.status == NOT_STARTED:
            # keep track of start time/frame for later
            rating_lang_att.tStart = t
            rating_lang_att.frameNStart = frameN  # exact frame index
            rating_lang_att.setAutoDraw(True)
        continueRoutine &= rating_lang_att.noResponse  # a response ends the trial
        
        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in language_attitudesComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "language_attitudes"-------
    for thisComponent in language_attitudesComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # store data for trials_att (TrialHandler)
    trials_att.addData('rating_lang_att.response', rating_lang_att.getRating())
    trials_att.addData('rating_lang_att.rt', rating_lang_att.getRT())
    # the Routine "language_attitudes" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()
    
# completed 1 repeats of 'trials_att'


# these shouldn't be strictly necessary (should auto-save)
thisExp.saveAsWideText(filename+'.csv')
thisExp.saveAsPickle(filename)
logging.flush()
# make sure everything is closed down
thisExp.abort()  # or data files will save again on exit
win.close()
core.quit()

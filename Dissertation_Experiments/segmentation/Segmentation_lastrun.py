#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This experiment was created using PsychoPy3 Experiment Builder (v3.0.7),
    on Tue Jun 18 09:14:50 2019
If you publish work using this script please cite the PsychoPy publications:
    Peirce, JW (2007) PsychoPy - Psychophysics software in Python.
        Journal of Neuroscience Methods, 162(1-2), 8-13.
    Peirce, JW (2009) Generating stimuli for neuroscience using PsychoPy.
        Frontiers in Neuroinformatics, 2:10. doi: 10.3389/neuro.11.010.2008
"""

from __future__ import absolute_import, division

import psychopy
psychopy.useVersion('3.0.7')

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
psychopyVersion = '3.0.7'
expName = 'Segmentation'  # from the Builder filename that created this script
expInfo = {'01_Participante (Participant):': 'part000', '02_Sesión (Session):': ['A', 'B', 'C', 'D'], '03_Nombre (First name):': '', '04_Apellido (Last name):': '', '05_Edad (Age):': '', '06_Sexo (Gender):': ['', 'Hombre', 'Mujer'], '07_País de nacimiento (Birth country):': ['', 'México', 'Estados Unidos'], '08_Lugar de residencia (Place of residence):': ['', 'Tucson', 'Hermosillo'], '09_Nivel más alto de formación académica (Highest level of formal education):': ['', 'Menos de la escuela secundaria', 'Escuela Secundaria', 'Un poco de universidad', 'Universidad (diplomatura, licenciatura)', 'Un poco de escuela graduada', 'Máster', 'Doctorado'], '10_Idioma preferido (Preferred language):': ['', 'español', 'inglés']}
dlg = gui.DlgFromDict(dictionary=expInfo, title=expName)
if dlg.OK == False:
    core.quit()  # user pressed cancel
expInfo['date'] = data.getDateStr()  # add a simple timestamp
expInfo['expName'] = expName
expInfo['psychopyVersion'] = psychopyVersion

# Data file name stem = absolute path + name; later add .psyexp, .csv, .log, etc
filename = _thisDir + os.sep + u'data/original_data/part_files/%s_%s_%s_%s' % (expInfo['01_Participante (Participant):'],expInfo['10_Idioma preferido (Preferred language):'], expInfo['02_Sesión (Session):'], expName)

# An ExperimentHandler isn't essential but helps with data saving
thisExp = data.ExperimentHandler(name=expName, version='',
    extraInfo=expInfo, runtimeInfo=None,
    originPath='/Users/drakeasberry/github/Dissertation/Dissertation_Experiments/segmentation/Segmentation_lastrun.py',
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

# Initialize components for Routine "lexEspInstrucciones"
lexEspInstruccionesClock = core.Clock()
if expInfo['02_Sesión (Session):'] == 'A':
    conditionPrac="data/processed_data/exp_files/pracCondA.csv"
    conditionExp="data/processed_data/exp_files/expCondA.csv"
    conditionSylPrac="data/processed_data/exp_files/sylpracCondA.csv"
    conditionSylExp="data/processed_data/exp_files/sylexpCondA.csv"
    practice = "practiceListA"
    experiment = "stimuliListA"
elif expInfo['02_Sesión (Session):'] == 'B':
    conditionPrac="data/processed_data/exp_files/pracCondB.csv"
    conditionExp="data/processed_data/exp_files/expCondB.csv"
    conditionSylPrac="data/processed_data/exp_files/sylpracCondB.csv"
    conditionSylExp="data/processed_data/exp_files/sylexpCondB.csv"
    practice = "practiceListB"
    experiment = "stimuliListB"
elif expInfo['02_Sesión (Session):'] == 'C':
    conditionPrac="data/processed_data/exp_files/pracCondC.csv"
    conditionExp="data/processed_data/exp_files/expCondC.csv"
    conditionSylPrac="data/processed_data/exp_files/sylpracCondC.csv"
    conditionSylExp="data/processed_data/exp_files/sylexpCondC.csv"
    practice = "practiceListC"
    experiment = "stimuliListC"
else:
    conditionPrac="data/processed_data/exp_files/pracCondD.csv"
    conditionExp="data/processed_data/exp_files/expCondD.csv"
    conditionSylPrac="data/processed_data/exp_files/sylpracCondD.csv"
    conditionSylExp="data/processed_data/exp_files/sylexpCondD.csv"
    practice = "practiceListD"
    experiment = "stimuliListD"


tmp = expInfo['10_Idioma preferido (Preferred language):']
lang = tmp[0]

if 'e' == lang:
    preferLang = 'spanish'
    section = 'sectionEsp'
    questionText = 'questionTextEsp'
    language = 'languageEsp'
    instructions = 'Nos gustaría pedir su ayuda para contestar a las siguientes preguntas sobre su historial lingüístico, uso, actitudes y competencia. Esta encuesta ha sido creada con el apoyo del "Center for Open Educational Resources and Language Learning" de la Universidad de Texas en Austin para poder tener un mayor conocimiento sobre los perfiles de hablantes bilingües independientemente de sus diversos orígenes y en diferentes contextos. La encuesta contiene 19 preguntas y le llevará menos de 10 minutos para completar. Esto no es una prueba, por tanto no hay respuestas correctas ni incorrectas. Por favor conteste cada pregunta y responda con sinceridad, ya que solamente así se podrá garantizar el éxito de esta investigación. Muchas gracias por su ayuda.\n\nPresione el botón blanco para continuar.'
    langHist = 'Historial lingüístico\n\nEn esta sección, nos gustaría que contestara algunas preguntas sobre su historial lingüístico marcando la escala según la leyenda.\n\nPresione el botón "blanco" para continuar.'
    langUse = 'Uso de lenguas\n\nEn esta sección, nos gustaría que contestara algunas preguntas sobre su uso de lenguas marcando la escala según la leyenda. El uso total de todas las preguntas en cada pregunta debe llegar al 100%.\n\nPresione el botón blanco para continuar.'
    langProf = 'Competencia\n\nEn esta sección, nos gustaría que considerara su competencia de lengua marcando en la escala de 0 a 6.\n\nPresione el botón blanco para continuar.'
    langAtt = 'Actitudes\n\nEn esta sección, nos gustaría que contestara a las siguientes afirmaciones sobre actitudes lingüísticas marcando en la escala de 0 a 6.\n\nPresione el botón blanco para continuar.'
    lexEsp = '''En este test, encontrará 90 secuencias de letras que parecen "españolas". Solo algunas de ellas son palabras de verdad.
                \nPor favor, señale las palabras que usted conoce (aquellas que está convencido que son palabras españolas, incluso aunque no seas capaz de dar el significado preciso).
                \nSi piensa que la es una palabra española, presione el botón verde para indicar "si" y si no, presione el botón rojo para indicar "no".
                \nTiene todo el tiempo que quiera para hacer cada decisión.
                \nPresione el botón blanco para empezar.'''
    lexEng = '''En este test, encontrará 60 secuencias de letras que parecen "inglesas". Solo algunas de ellas son palabras de verdad.
                \nPor favor, señale las palabras que usted conoce (aquellas que está convencido que son palabras inglesas, incluso aunque no seas capaz de dar el significado preciso).
                \nSi piensa que la es una palabra inglésa, presione el botón verde para indicar "si" y si no, presione el botón rojo para indicar "no".
                \nTiene todo el tiempo que quiera para hacer cada decisión.
                \nPresione el botón blanco para empezar.'''
    labHist1 = '0 = Desde al nacimiento     20+ = 20 o más años'
    labHist2 = '0 = Tan pronto como recuerdo     20+ = aún no'
    labHist3 = '0 = Nunca                          20+ = 20 o más años'
    labUse = 'El uso total de todas las lenguas en cada pregunta debe llegar al 100%'
    labProf = '0 = No muy bien                                   6 = muy bien'
    labAtt = '0 = No estoy de acuerdo                     6 = Estoy de acuerdo'
elif 'i' == lang:
    preferLang = 'english'
    section = 'sectionEng'
    questionText = 'questionTextEng'
    language = 'languageEng'
    instructions = '''We would like to ask you to help us by answering the following questions concerning your language history, use, 
attitudes, and proficiency. This survey was created with support from the Center for Open Educational Resources 
and Language Learning at the University of Texas at Austin 
to better understand the profiles of bilingual speakers in diverse settings with diverse backgrounds. The survey 
consists of 19 questions and will take less than 10 minutes to complete. This is not a test, so there are no right or 
wrong answers. Please answer every question and give your answers sincerely. Thank you very much for your help.
\nPress the white button to continue'''
    langHist = 'Language history\n\nIn this section, we would like you to answer some factual questions about your language history by marking the scale in the appropriate location.\n\nPress the white button to begin.'
    langUse = 'Language use\n\nIn this section, we would like you to answer some questions about your language use by marking the scale in the appropriate location. Total use for all languages in a given question should equal 100%.\n\nPress the white button to begin.'
    langProf = 'Language proficiency\n\nIn this section, we would like you to rate your language proficiency by marking the scale in the appropriate location from 0 to 6.\n\nPress the white button to begin.'
    langAtt = 'Language attitudes\n\nIn this section, we would like you to respond to statements about language attitudes by marking the scale in the appropriate location from 0-6.\n\nPress the white button to begin.'
    lexEsp = '''En este test, encontrará 90 secuencias de letras que parecen "españolas". Solo algunas de ellas son palabras de verdad.
                \nPor favor, señale las palabras que usted conoce (aquellas que está convencido que son palabras españolas, incluso aunque no seas capaz de dar el significado preciso).
                \nSi piensa que la es una palabra española, presione el botón verde para indicar "si" y si no, presione el botón rojo para indicar "no".
                \nTiene todo el tiempo que quiera para hacer cada decisión.
                \nPresione el botón blanco para empezar.'''
    lexEng = '''This test consists of 60 trials, in each of which you will see a string of letters.
                \nYour task is to decide whether this is an existing English word or not.
                \nIf you think it is an existing English word, press the green button for "sí" and if you think it is not an existing English word, press the red button for "no". If you are sure that the word exists, even if you do not know its exact meaning, you may still respond "sí". But if you are not sure if it is an existing word, you should respond "no".
                \nYou have as much time as you like for each decision.
                \nPress the white button to start.'''
    labHist1 = '0 = Since birth     20+ = 20 or more years'
    labHist2 = '0 = As long as I can remember     20+ = Not yet comfortable'
    labHist3 = '0 = Never                                20+ = 20 or more years'
    labUse = 'The total usage of all languages must equal 100%'
    labProf = '0 = Not very well                                   6 = Very well'
    labAtt = '0 = Disagree                                       6 = Agree'
else:
    instructions = 'Por favor, hable con el investigador.\n\nPlease talk to the experimenter.'

lexEsp_Instr = visual.TextStim(win=win, name='lexEsp_Instr',
    text=lexEsp,
    font='Arial',
    pos=[0, 0], height=0.09, wrapWidth=1.5, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);

# Initialize components for Routine "lexTaleEsp"
lexTaleEspClock = core.Clock()
esp_Word = visual.TextStim(win=win, name='esp_Word',
    text='default text',
    font='Arial',
    pos=[0, 0.5], height=0.2, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);
esp_Si = visual.TextStim(win=win, name='esp_Si',
    text='sí',
    font='Arial',
    pos=[-0.5, -0.5], height=0.2, wrapWidth=None, ori=0, 
    color='green', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);
esp_No = visual.TextStim(win=win, name='esp_No',
    text='no',
    font='Arial',
    pos=[0.5, -0.5], height=0.2, wrapWidth=None, ori=0, 
    color='red', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-2.0);

# Initialize components for Routine "pracIns"
pracInsClock = core.Clock()
pracSegInstr = visual.TextStim(win=win, name='pracSegInstr',
    text='Usted va a completar un experimento.\n\nVa a ver un fragmento.\n\nDespués, verá otras palabras.\n\nSi ve el fragmento, presione el botón verde.\n\nSi no ve el fragmento, no haga nada.\n\nPresione el botón blanco para empezar las pruebas de práctica.',
    font='Arial',
    pos=(0, 0), height=0.09, wrapWidth=1.5, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

# Initialize components for Routine "targetPrac"
targetPracClock = core.Clock()
pracSegTarget = visual.TextStim(win=win, name='pracSegTarget',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);

# Initialize components for Routine "isi_halfsec"
isi_halfsecClock = core.Clock()
text = visual.TextStim(win=win, name='text',
    text=None,
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

# Initialize components for Routine "trialPrac"
trialPracClock = core.Clock()
pracSegCarrier = visual.TextStim(win=win, name='pracSegCarrier',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);

# Initialize components for Routine "expIns"
expInsClock = core.Clock()
startExp = visual.TextStim(win=win, name='startExp',
    text='Usted acaba de completar las pruebas.\n\nRecuerde:\nSi ve el fragmento, presione el botón verde.\n\nSi no ve el fragmento, no haga nada.\n\n\nPresione el botón blanco para empezar el experimento.',
    font='Arial',
    pos=(0, 0), height=0.09, wrapWidth=1.5, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

# Initialize components for Routine "descanso"
descansoClock = core.Clock()
descansar = visual.TextStim(win=win, name='descansar',
    text='Tome un descanso de dos minutos.\n\nPara continuar sin descanso o uno más corto, presione el botón blanco!',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);

# Initialize components for Routine "targetExp"
targetExpClock = core.Clock()
expTarget = visual.TextStim(win=win, name='expTarget',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);

# Initialize components for Routine "isi_halfsec"
isi_halfsecClock = core.Clock()
text = visual.TextStim(win=win, name='text',
    text=None,
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

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
pracSyllableInstr = visual.TextStim(win=win, name='pracSyllableInstr',
    text='Ahora, verá varias palabras y selecionará la primera sílaba.\n\nPresione el botón azul si su respuesta está a la izqueirda.\n\nPresione el botón amarillo si su respuesta está a la derecha.\n\nPresione el botón blanco para empezar las pruebas de práctica.',
    font='Arial',
    pos=(0, 0), height=0.09, wrapWidth=1.5, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

# Initialize components for Routine "syllablePracTrial"
syllablePracTrialClock = core.Clock()
pracSylTarget = visual.TextStim(win=win, name='pracSylTarget',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);
pracSylAnsCVC = visual.TextStim(win=win, name='pracSylAnsCVC',
    text='default text',
    font='Arial',
    pos=(-.5, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);
pracSylAnsCV = visual.TextStim(win=win, name='pracSylAnsCV',
    text='default text',
    font='Arial',
    pos=(.5, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-2.0);

# Initialize components for Routine "syllableExpIns"
syllableExpInsClock = core.Clock()
expSyllableInstr = visual.TextStim(win=win, name='expSyllableInstr',
    text='Usted acaba de completar las pruebas.\n\nRecuerde:\nVerá varias palabras y selecionará la primera sílaba.\n\nPresione el botón azul si su respuesta está a la izqueirda.\n\nPresione el botón amarillo si su respuesta está a la derecha.\n\nPresione el botón blanco para empezar el experimento.',
    font='Arial',
    pos=(0, 0), height=0.09, wrapWidth=1.5, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

# Initialize components for Routine "trialSyllable"
trialSyllableClock = core.Clock()
expSylAnsCVC = visual.TextStim(win=win, name='expSylAnsCVC',
    text='default text',
    font='Arial',
    pos=(-.5, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);
expSylAnsCV = visual.TextStim(win=win, name='expSylAnsCV',
    text='default text',
    font='Arial',
    pos=(.5,0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);
expSylTarget = visual.TextStim(win=win, name='expSylTarget',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-2.0);

# Initialize components for Routine "lexTaleEngInstructions"
lexTaleEngInstructionsClock = core.Clock()
lexEng_Instr = visual.TextStim(win=win, name='lexEng_Instr',
    text=lexEng,
    font='Arial',
    pos=[0, 0], height=0.09, wrapWidth=1.5, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

# Initialize components for Routine "lexTaleEng"
lexTaleEngClock = core.Clock()
eng_Word = visual.TextStim(win=win, name='eng_Word',
    text='default text',
    font='Arial',
    pos=[0, 0.5], height=0.2, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);
eng_Yes = visual.TextStim(win=win, name='eng_Yes',
    text='sí',
    font='Arial',
    pos=[-0.5, -0.5], height=0.2, wrapWidth=None, ori=0, 
    color='green', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);
eng_No = visual.TextStim(win=win, name='eng_No',
    text='no',
    font='Arial',
    pos=[0.5, -0.5], height=0.2, wrapWidth=None, ori=0, 
    color='red', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-2.0);

# Initialize components for Routine "instructions_blp"
instructions_blpClock = core.Clock()
text_instructions = visual.TextStim(win=win, name='text_instructions',
    text=instructions,
    font='Arial',
    pos=(0, 0), height=0.09, wrapWidth=1.5, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

# Initialize components for Routine "lang_hist_ins"
lang_hist_insClock = core.Clock()
text_lang_his_ins = visual.TextStim(win=win, name='text_lang_his_ins',
    text=langHist,
    font='Arial',
    pos=(0, 0), height=0.09, wrapWidth=1.5, ori=0, 
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
    pos=(0, 0.4), height=0.1, wrapWidth=1.8, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);
text_lang_hist_lang = visual.TextStim(win=win, name='text_lang_hist_lang',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-2.0);
text_lang_hist_qnum = visual.TextStim(win=win, name='text_lang_hist_qnum',
    text='default text',
    font='Arial',
    pos=(-0.9, 0.9), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-3.0);
rating_lang_hist = visual.RatingScale(win=win, name='rating_lang_hist', marker='triangle', size=1.5, pos=[0.0, -0.4], low=0, high=20, labels=['0', ' 20+'], scale=labHist1, markerStart='10')

# Initialize components for Routine "language_history_2"
language_history_2Clock = core.Clock()
text_section_lang_hist_2 = visual.TextStim(win=win, name='text_section_lang_hist_2',
    text='default text',
    font='Arial',
    pos=(0, 0.75), height=0.1, wrapWidth=None, ori=0, 
    color='black', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);
text_lang_hist_question_2 = visual.TextStim(win=win, name='text_lang_hist_question_2',
    text='default text',
    font='Arial',
    pos=(0, 0.4), height=0.1, wrapWidth=1.8, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);
text_lang_hist_lang_2 = visual.TextStim(win=win, name='text_lang_hist_lang_2',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-2.0);
text_lang_hist_qnum_2 = visual.TextStim(win=win, name='text_lang_hist_qnum_2',
    text='default text',
    font='Arial',
    pos=(-0.9, 0.9), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-3.0);
rating_lang_hist_2 = visual.RatingScale(win=win, name='rating_lang_hist_2', marker='triangle', size=1.5, pos=[0.0, -0.4], low=0, high=20, labels=['0', ' 20+'], scale=labHist2, markerStart='10')

# Initialize components for Routine "language_history_3"
language_history_3Clock = core.Clock()
text_section_lang_hist_3 = visual.TextStim(win=win, name='text_section_lang_hist_3',
    text='default text',
    font='Arial',
    pos=(0, 0.75), height=0.1, wrapWidth=None, ori=0, 
    color='black', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);
text_lang_hist_question_3 = visual.TextStim(win=win, name='text_lang_hist_question_3',
    text='default text',
    font='Arial',
    pos=(0, 0.4), height=0.1, wrapWidth=1.8, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);
text_lang_hist_lang_3 = visual.TextStim(win=win, name='text_lang_hist_lang_3',
    text='default text',
    font='Arial',
    pos=(0, 0), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-2.0);
text_lang_hist_qnum_3 = visual.TextStim(win=win, name='text_lang_hist_qnum_3',
    text='default text',
    font='Arial',
    pos=(-0.9, 0.9), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-3.0);
rating_lang_hist_3 = visual.RatingScale(win=win, name='rating_lang_hist_3', marker='triangle', size=1.5, pos=[0.0, -0.4], low=0, high=20, labels=['0', ' 20+'], scale=labHist3, markerStart='10')

# Initialize components for Routine "lang_use_ins"
lang_use_insClock = core.Clock()
text_lang_use_ins = visual.TextStim(win=win, name='text_lang_use_ins',
    text=langUse,
    font='Arial',
    pos=(0, 0), height=0.09, wrapWidth=1.5, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);

# Initialize components for Routine "language_use"
language_useClock = core.Clock()
text_section_lang_use = visual.TextStim(win=win, name='text_section_lang_use',
    text='default text',
    font='Arial',
    pos=(0, 0.9), height=0.1, wrapWidth=None, ori=0, 
    color='black', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=0.0);
text_lang_use_question = visual.TextStim(win=win, name='text_lang_use_question',
    text='default text',
    font='Arial',
    pos=(0, 0.6), height=0.1, wrapWidth=1.8, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);
text_lang_use_lang = visual.TextStim(win=win, name='text_lang_use_lang',
    text='default text',
    font='Arial',
    pos=(0, 0.2), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-2.0);
text_lang_use_qnum = visual.TextStim(win=win, name='text_lang_use_qnum',
    text='default text',
    font='Arial',
    pos=(-0.9, 0.9), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-3.0);
rating_blp_use = visual.RatingScale(win=win, name='rating_blp_use', marker='triangle', size=1.5, pos=[0.0, -0.4], low=0, high=10, labels=['0%', '50%', '100%'], scale=labUse, markerStart='5')

# Initialize components for Routine "lang_prof_ins"
lang_prof_insClock = core.Clock()
text_lang_prof_ins = visual.TextStim(win=win, name='text_lang_prof_ins',
    text=langProf,
    font='Arial',
    pos=(0, 0), height=0.09, wrapWidth=1.5, ori=0, 
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
    pos=(0, 0.4), height=0.1, wrapWidth=1.8, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);
text_lang_prof_lang = visual.TextStim(win=win, name='text_lang_prof_lang',
    text='default text',
    font='Arial',
    pos=(0.0, 0.1), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-2.0);
text_lang_prof_qnum = visual.TextStim(win=win, name='text_lang_prof_qnum',
    text='default text',
    font='Arial',
    pos=(-0.9, 0.9), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-3.0);
rating_lang_prof = visual.RatingScale(win=win, name='rating_lang_prof', marker='triangle', size=1.5, pos=[0.0, -0.4], low=0, high=6, labels=['0', '3', '6'], scale=labProf, markerStart='3')

# Initialize components for Routine "lang_att_ins"
lang_att_insClock = core.Clock()
text_lang_att_ins = visual.TextStim(win=win, name='text_lang_att_ins',
    text=langAtt,
    font='Arial',
    pos=(0, 0), height=0.09, wrapWidth=1.5, ori=0, 
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
    pos=(0, .4), height=0.1, wrapWidth=1.8, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-1.0);
text_lang_prof_att = visual.TextStim(win=win, name='text_lang_prof_att',
    text='default text',
    font='Arial',
    pos=(0.0, 0.1), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-2.0);
text_lang_att_qnum = visual.TextStim(win=win, name='text_lang_att_qnum',
    text='default text',
    font='Arial',
    pos=(-0.9, 0.9), height=0.1, wrapWidth=None, ori=0, 
    color='white', colorSpace='rgb', opacity=1, 
    languageStyle='LTR',
    depth=-3.0);
rating_lang_att = visual.RatingScale(win=win, name='rating_lang_att', marker='triangle', size=1.5, pos=[0.0, -0.4], low=0, high=6, labels=['0', '3', '6'], scale=labAtt, markerStart='3')

# Initialize components for Routine "gracias"
graciasClock = core.Clock()
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

# ------Prepare to start Routine "lexEspInstrucciones"-------
t = 0
lexEspInstruccionesClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
start_LexEsp = event.BuilderKeyResponse()
# keep track of which components have finished
lexEspInstruccionesComponents = [lexEsp_Instr, start_LexEsp]
for thisComponent in lexEspInstruccionesComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "lexEspInstrucciones"-------
while continueRoutine:
    # get current time
    t = lexEspInstruccionesClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *lexEsp_Instr* updates
    if t >= 0.0 and lexEsp_Instr.status == NOT_STARTED:
        # keep track of start time/frame for later
        lexEsp_Instr.tStart = t
        lexEsp_Instr.frameNStart = frameN  # exact frame index
        lexEsp_Instr.setAutoDraw(True)
    
    # *start_LexEsp* updates
    if t >= 0.0 and start_LexEsp.status == NOT_STARTED:
        # keep track of start time/frame for later
        start_LexEsp.tStart = t
        start_LexEsp.frameNStart = frameN  # exact frame index
        start_LexEsp.status = STARTED
        # keyboard checking is just starting
    if start_LexEsp.status == STARTED:
        theseKeys = event.getKeys(keyList=['0'])
        
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
    for thisComponent in lexEspInstruccionesComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "lexEspInstrucciones"-------
for thisComponent in lexEspInstruccionesComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# the Routine "lexEspInstrucciones" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
lexEspLoop = data.TrialHandler(nReps=1, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('data/processed_data/exp_files/lexTaleListEsp.csv'),
    seed=None, name='lexEspLoop')
thisExp.addLoop(lexEspLoop)  # add the loop to the experiment
thisLexEspLoop = lexEspLoop.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisLexEspLoop.rgb)
if thisLexEspLoop != None:
    for paramName in thisLexEspLoop:
        exec('{} = thisLexEspLoop[paramName]'.format(paramName))

for thisLexEspLoop in lexEspLoop:
    currentLoop = lexEspLoop
    # abbreviate parameter names if possible (e.g. rgb = thisLexEspLoop.rgb)
    if thisLexEspLoop != None:
        for paramName in thisLexEspLoop:
            exec('{} = thisLexEspLoop[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "lexTaleEsp"-------
    t = 0
    lexTaleEspClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    esp_Word.setText(Word)
    lexEsp_key_resp = event.BuilderKeyResponse()
    # keep track of which components have finished
    lexTaleEspComponents = [esp_Word, esp_Si, esp_No, lexEsp_key_resp]
    for thisComponent in lexTaleEspComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "lexTaleEsp"-------
    while continueRoutine:
        # get current time
        t = lexTaleEspClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *esp_Word* updates
        if t >= 0.2 and esp_Word.status == NOT_STARTED:
            # keep track of start time/frame for later
            esp_Word.tStart = t
            esp_Word.frameNStart = frameN  # exact frame index
            esp_Word.setAutoDraw(True)
        
        # *esp_Si* updates
        if t >= 0.2 and esp_Si.status == NOT_STARTED:
            # keep track of start time/frame for later
            esp_Si.tStart = t
            esp_Si.frameNStart = frameN  # exact frame index
            esp_Si.setAutoDraw(True)
        
        # *esp_No* updates
        if t >= 0.2 and esp_No.status == NOT_STARTED:
            # keep track of start time/frame for later
            esp_No.tStart = t
            esp_No.frameNStart = frameN  # exact frame index
            esp_No.setAutoDraw(True)
        
        # *lexEsp_key_resp* updates
        if t >= 0.2 and lexEsp_key_resp.status == NOT_STARTED:
            # keep track of start time/frame for later
            lexEsp_key_resp.tStart = t
            lexEsp_key_resp.frameNStart = frameN  # exact frame index
            lexEsp_key_resp.status = STARTED
            # keyboard checking is just starting
            lexEsp_key_resp.clock.reset()  # now t=0
        if lexEsp_key_resp.status == STARTED:
            theseKeys = event.getKeys(keyList=['1', '4'])
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                if lexEsp_key_resp.keys == []:  # then this was the first keypress
                    lexEsp_key_resp.keys = theseKeys[0]  # just the first key pressed
                    lexEsp_key_resp.rt = lexEsp_key_resp.clock.getTime()
                    # was this 'correct'?
                    if (lexEsp_key_resp.keys == str(corrAnsEspV)) or (lexEsp_key_resp.keys == corrAnsEspV):
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
        for thisComponent in lexTaleEspComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "lexTaleEsp"-------
    for thisComponent in lexTaleEspComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # check responses
    if lexEsp_key_resp.keys in ['', [], None]:  # No response was made
        lexEsp_key_resp.keys=None
        # was no response the correct answer?!
        if str(corrAnsEspV).lower() == 'none':
           lexEsp_key_resp.corr = 1;  # correct non-response
        else:
           lexEsp_key_resp.corr = 0;  # failed to respond (incorrectly)
    # store data for lexEspLoop (TrialHandler)
    lexEspLoop.addData('lexEsp_key_resp.keys',lexEsp_key_resp.keys)
    lexEspLoop.addData('lexEsp_key_resp.corr', lexEsp_key_resp.corr)
    if lexEsp_key_resp.keys != None:  # we had a response
        lexEspLoop.addData('lexEsp_key_resp.rt', lexEsp_key_resp.rt)
    # the Routine "lexTaleEsp" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()
    
# completed 1 repeats of 'lexEspLoop'


# ------Prepare to start Routine "pracIns"-------
t = 0
pracInsClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
pracSeg_Start = event.BuilderKeyResponse()
# keep track of which components have finished
pracInsComponents = [pracSegInstr, pracSeg_Start]
for thisComponent in pracInsComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "pracIns"-------
while continueRoutine:
    # get current time
    t = pracInsClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *pracSegInstr* updates
    if t >= 0.0 and pracSegInstr.status == NOT_STARTED:
        # keep track of start time/frame for later
        pracSegInstr.tStart = t
        pracSegInstr.frameNStart = frameN  # exact frame index
        pracSegInstr.setAutoDraw(True)
    
    # *pracSeg_Start* updates
    if t >= 0.0 and pracSeg_Start.status == NOT_STARTED:
        # keep track of start time/frame for later
        pracSeg_Start.tStart = t
        pracSeg_Start.frameNStart = frameN  # exact frame index
        pracSeg_Start.status = STARTED
        # keyboard checking is just starting
        event.clearEvents(eventType='keyboard')
    if pracSeg_Start.status == STARTED:
        theseKeys = event.getKeys(keyList=['0'])
        
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
    trialList=data.importConditions(conditionPrac, selection=[1]),
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
    
    # ------Prepare to start Routine "targetPrac"-------
    t = 0
    targetPracClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    routineTimer.add(4.000000)
    # update component parameters for each repeat
    targetPrac = practice + "%i" %pracTarLoop.thisN
    pracSegTarget.setText("Encuentre    " + eval(targetPrac).upper()
)
    # keep track of which components have finished
    targetPracComponents = [pracSegTarget]
    for thisComponent in targetPracComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "targetPrac"-------
    while continueRoutine and routineTimer.getTime() > 0:
        # get current time
        t = targetPracClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *pracSegTarget* updates
        if t >= 0.0 and pracSegTarget.status == NOT_STARTED:
            # keep track of start time/frame for later
            pracSegTarget.tStart = t
            pracSegTarget.frameNStart = frameN  # exact frame index
            pracSegTarget.setAutoDraw(True)
        frameRemains = 0.0 + 4.0- win.monitorFramePeriod * 0.75  # most of one frame period left
        if pracSegTarget.status == STARTED and t >= frameRemains:
            pracSegTarget.setAutoDraw(False)
        
        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in targetPracComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "targetPrac"-------
    for thisComponent in targetPracComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    
    # ------Prepare to start Routine "isi_halfsec"-------
    t = 0
    isi_halfsecClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    routineTimer.add(0.500000)
    # update component parameters for each repeat
    # keep track of which components have finished
    isi_halfsecComponents = [text]
    for thisComponent in isi_halfsecComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "isi_halfsec"-------
    while continueRoutine and routineTimer.getTime() > 0:
        # get current time
        t = isi_halfsecClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *text* updates
        if t >= 0.0 and text.status == NOT_STARTED:
            # keep track of start time/frame for later
            text.tStart = t
            text.frameNStart = frameN  # exact frame index
            text.setAutoDraw(True)
        frameRemains = 0.0 + 0.5- win.monitorFramePeriod * 0.75  # most of one frame period left
        if text.status == STARTED and t >= frameRemains:
            text.setAutoDraw(False)
        
        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in isi_halfsecComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "isi_halfsec"-------
    for thisComponent in isi_halfsecComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    
    # set up handler to look after randomisation of conditions etc
    pracTrialLoop = data.TrialHandler(nReps=1, method='random', 
        extraInfo=expInfo, originPath=-1,
        trialList=data.importConditions(conditionPrac, selection=[2,3,4,5,6,7,8,9,10,11]),
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
        
        # ------Prepare to start Routine "trialPrac"-------
        t = 0
        trialPracClock.reset()  # clock
        frameN = -1
        continueRoutine = True
        routineTimer.add(2.000000)
        # update component parameters for each repeat
        carrierPrac = practice + "%i" %pracTarLoop.thisN
        pracSegCarrier.setText(eval(carrierPrac))
        pracSeg_key_resp = event.BuilderKeyResponse()
        # keep track of which components have finished
        trialPracComponents = [pracSegCarrier, pracSeg_key_resp]
        for thisComponent in trialPracComponents:
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
        
        # -------Start Routine "trialPrac"-------
        while continueRoutine and routineTimer.getTime() > 0:
            # get current time
            t = trialPracClock.getTime()
            frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
            # update/draw components on each frame
            
            # *pracSegCarrier* updates
            if t >= 0.0 and pracSegCarrier.status == NOT_STARTED:
                # keep track of start time/frame for later
                pracSegCarrier.tStart = t
                pracSegCarrier.frameNStart = frameN  # exact frame index
                pracSegCarrier.setAutoDraw(True)
            frameRemains = 0.0 + 2- win.monitorFramePeriod * 0.75  # most of one frame period left
            if pracSegCarrier.status == STARTED and t >= frameRemains:
                pracSegCarrier.setAutoDraw(False)
            
            # *pracSeg_key_resp* updates
            if t >= 0.0 and pracSeg_key_resp.status == NOT_STARTED:
                # keep track of start time/frame for later
                pracSeg_key_resp.tStart = t
                pracSeg_key_resp.frameNStart = frameN  # exact frame index
                pracSeg_key_resp.status = STARTED
                # keyboard checking is just starting
                event.clearEvents(eventType='keyboard')
            frameRemains = 0.0 + 2- win.monitorFramePeriod * 0.75  # most of one frame period left
            if pracSeg_key_resp.status == STARTED and t >= frameRemains:
                pracSeg_key_resp.status = FINISHED
            if pracSeg_key_resp.status == STARTED:
                theseKeys = event.getKeys(keyList=['1'])
                
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
            for thisComponent in trialPracComponents:
                if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                    continueRoutine = True
                    break  # at least one component has not yet finished
            
            # refresh the screen
            if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
                win.flip()
        
        # -------Ending Routine "trialPrac"-------
        for thisComponent in trialPracComponents:
            if hasattr(thisComponent, "setAutoDraw"):
                thisComponent.setAutoDraw(False)
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
        theseKeys = event.getKeys(keyList=['0'])
        
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
expTarLoop = data.TrialHandler(nReps=48, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions(conditionExp, selection=[1]),
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
    
    # ------Prepare to start Routine "descanso"-------
    t = 0
    descansoClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    if expTarLoop.thisN != 23:
        continueRoutine = False
    key_resp_continue = event.BuilderKeyResponse()
    # keep track of which components have finished
    descansoComponents = [descansar, key_resp_continue]
    for thisComponent in descansoComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "descanso"-------
    while continueRoutine:
        # get current time
        t = descansoClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *descansar* updates
        if t >= 0.0 and descansar.status == NOT_STARTED:
            # keep track of start time/frame for later
            descansar.tStart = t
            descansar.frameNStart = frameN  # exact frame index
            descansar.setAutoDraw(True)
        frameRemains = 0.0 + 120.0- win.monitorFramePeriod * 0.75  # most of one frame period left
        if descansar.status == STARTED and t >= frameRemains:
            descansar.setAutoDraw(False)
        
        # *key_resp_continue* updates
        if t >= 0.0 and key_resp_continue.status == NOT_STARTED:
            # keep track of start time/frame for later
            key_resp_continue.tStart = t
            key_resp_continue.frameNStart = frameN  # exact frame index
            key_resp_continue.status = STARTED
            # keyboard checking is just starting
            event.clearEvents(eventType='keyboard')
        if key_resp_continue.status == STARTED:
            theseKeys = event.getKeys(keyList=['0'])
            
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
        for thisComponent in descansoComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "descanso"-------
    for thisComponent in descansoComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # the Routine "descanso" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    
    # ------Prepare to start Routine "targetExp"-------
    t = 0
    targetExpClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    routineTimer.add(4.000000)
    # update component parameters for each repeat
    targetExp= experiment + "%i" %expTarLoop.thisN
    
    
    expTarget.setText("Encuentre    " + eval(targetExp).upper())
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
        frameRemains = 0.0 + 4.0- win.monitorFramePeriod * 0.75  # most of one frame period left
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
    
    # ------Prepare to start Routine "isi_halfsec"-------
    t = 0
    isi_halfsecClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    routineTimer.add(0.500000)
    # update component parameters for each repeat
    # keep track of which components have finished
    isi_halfsecComponents = [text]
    for thisComponent in isi_halfsecComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "isi_halfsec"-------
    while continueRoutine and routineTimer.getTime() > 0:
        # get current time
        t = isi_halfsecClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *text* updates
        if t >= 0.0 and text.status == NOT_STARTED:
            # keep track of start time/frame for later
            text.tStart = t
            text.frameNStart = frameN  # exact frame index
            text.setAutoDraw(True)
        frameRemains = 0.0 + 0.5- win.monitorFramePeriod * 0.75  # most of one frame period left
        if text.status == STARTED and t >= frameRemains:
            text.setAutoDraw(False)
        
        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in isi_halfsecComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "isi_halfsec"-------
    for thisComponent in isi_halfsecComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    
    # set up handler to look after randomisation of conditions etc
    expTrialLoop = data.TrialHandler(nReps=1, method='random', 
        extraInfo=expInfo, originPath=-1,
        trialList=data.importConditions(conditionExp, selection=[2,3,4,5,6,7,8,9,10,11]),
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
        routineTimer.add(2.000000)
        # update component parameters for each repeat
        carrierExp= experiment + "%i" %expTarLoop.thisN
        expCarrier.setText(eval(carrierExp))
        seg_key_resp = event.BuilderKeyResponse()
        # keep track of which components have finished
        trialExpComponents = [expCarrier, seg_key_resp]
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
            frameRemains = 0.0 + 2- win.monitorFramePeriod * 0.75  # most of one frame period left
            if expCarrier.status == STARTED and t >= frameRemains:
                expCarrier.setAutoDraw(False)
            
            # *seg_key_resp* updates
            if t >= 0.0 and seg_key_resp.status == NOT_STARTED:
                # keep track of start time/frame for later
                seg_key_resp.tStart = t
                seg_key_resp.frameNStart = frameN  # exact frame index
                seg_key_resp.status = STARTED
                # keyboard checking is just starting
                win.callOnFlip(seg_key_resp.clock.reset)  # t=0 on next screen flip
                event.clearEvents(eventType='keyboard')
            frameRemains = 0.0 + 2- win.monitorFramePeriod * 0.75  # most of one frame period left
            if seg_key_resp.status == STARTED and t >= frameRemains:
                seg_key_resp.status = FINISHED
            if seg_key_resp.status == STARTED:
                theseKeys = event.getKeys(keyList=['1'])
                
                # check for quit:
                if "escape" in theseKeys:
                    endExpNow = True
                if len(theseKeys) > 0:  # at least one key was pressed
                    seg_key_resp.keys = theseKeys[-1]  # just the last key pressed
                    seg_key_resp.rt = seg_key_resp.clock.getTime()
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
        if seg_key_resp.keys in ['', [], None]:  # No response was made
            seg_key_resp.keys=None
        expTrialLoop.addData('seg_key_resp.keys',seg_key_resp.keys)
        if seg_key_resp.keys != None:  # we had a response
            expTrialLoop.addData('seg_key_resp.rt', seg_key_resp.rt)
        thisExp.nextEntry()
        
    # completed 1 repeats of 'expTrialLoop'
    
    thisExp.nextEntry()
    
# completed 48 repeats of 'expTarLoop'


# ------Prepare to start Routine "syllablePracIns"-------
t = 0
syllablePracInsClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
pracSyllableStart = event.BuilderKeyResponse()
# keep track of which components have finished
syllablePracInsComponents = [pracSyllableInstr, pracSyllableStart]
for thisComponent in syllablePracInsComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "syllablePracIns"-------
while continueRoutine:
    # get current time
    t = syllablePracInsClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *pracSyllableInstr* updates
    if t >= 0.0 and pracSyllableInstr.status == NOT_STARTED:
        # keep track of start time/frame for later
        pracSyllableInstr.tStart = t
        pracSyllableInstr.frameNStart = frameN  # exact frame index
        pracSyllableInstr.setAutoDraw(True)
    
    # *pracSyllableStart* updates
    if t >= 0.0 and pracSyllableStart.status == NOT_STARTED:
        # keep track of start time/frame for later
        pracSyllableStart.tStart = t
        pracSyllableStart.frameNStart = frameN  # exact frame index
        pracSyllableStart.status = STARTED
        # keyboard checking is just starting
        event.clearEvents(eventType='keyboard')
    if pracSyllableStart.status == STARTED:
        theseKeys = event.getKeys(keyList=['0'])
        
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
sylPracLoop = data.TrialHandler(nReps=1, method='random', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions(conditionSylPrac),
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
    pracSylTarget.setText(syllabification)
    pracSylAnsCVC.setText(leftKey)
    pracSylAnsCV.setText(rightKey)
    pracSyl_key_resp = event.BuilderKeyResponse()
    # keep track of which components have finished
    syllablePracTrialComponents = [pracSylTarget, pracSylAnsCVC, pracSylAnsCV, pracSyl_key_resp]
    for thisComponent in syllablePracTrialComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "syllablePracTrial"-------
    while continueRoutine and routineTimer.getTime() > 0:
        # get current time
        t = syllablePracTrialClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *pracSylTarget* updates
        if t >= 0.5 and pracSylTarget.status == NOT_STARTED:
            # keep track of start time/frame for later
            pracSylTarget.tStart = t
            pracSylTarget.frameNStart = frameN  # exact frame index
            pracSylTarget.setAutoDraw(True)
        frameRemains = 0.5 + 1.5- win.monitorFramePeriod * 0.75  # most of one frame period left
        if pracSylTarget.status == STARTED and t >= frameRemains:
            pracSylTarget.setAutoDraw(False)
        
        # *pracSylAnsCVC* updates
        if t >= 2 and pracSylAnsCVC.status == NOT_STARTED:
            # keep track of start time/frame for later
            pracSylAnsCVC.tStart = t
            pracSylAnsCVC.frameNStart = frameN  # exact frame index
            pracSylAnsCVC.setAutoDraw(True)
        frameRemains = 2 + 2- win.monitorFramePeriod * 0.75  # most of one frame period left
        if pracSylAnsCVC.status == STARTED and t >= frameRemains:
            pracSylAnsCVC.setAutoDraw(False)
        
        # *pracSylAnsCV* updates
        if t >= 2 and pracSylAnsCV.status == NOT_STARTED:
            # keep track of start time/frame for later
            pracSylAnsCV.tStart = t
            pracSylAnsCV.frameNStart = frameN  # exact frame index
            pracSylAnsCV.setAutoDraw(True)
        frameRemains = 2 + 2- win.monitorFramePeriod * 0.75  # most of one frame period left
        if pracSylAnsCV.status == STARTED and t >= frameRemains:
            pracSylAnsCV.setAutoDraw(False)
        
        # *pracSyl_key_resp* updates
        if t >= 2 and pracSyl_key_resp.status == NOT_STARTED:
            # keep track of start time/frame for later
            pracSyl_key_resp.tStart = t
            pracSyl_key_resp.frameNStart = frameN  # exact frame index
            pracSyl_key_resp.status = STARTED
            # keyboard checking is just starting
            event.clearEvents(eventType='keyboard')
        frameRemains = 2 + 2- win.monitorFramePeriod * 0.75  # most of one frame period left
        if pracSyl_key_resp.status == STARTED and t >= frameRemains:
            pracSyl_key_resp.status = FINISHED
        if pracSyl_key_resp.status == STARTED:
            theseKeys = event.getKeys(keyList=['2', '3'])
            
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
    
# completed 1 repeats of 'sylPracLoop'


# ------Prepare to start Routine "syllableExpIns"-------
t = 0
syllableExpInsClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
expSyllableStart = event.BuilderKeyResponse()
# keep track of which components have finished
syllableExpInsComponents = [expSyllableInstr, expSyllableStart]
for thisComponent in syllableExpInsComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "syllableExpIns"-------
while continueRoutine:
    # get current time
    t = syllableExpInsClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *expSyllableInstr* updates
    if t >= 0.0 and expSyllableInstr.status == NOT_STARTED:
        # keep track of start time/frame for later
        expSyllableInstr.tStart = t
        expSyllableInstr.frameNStart = frameN  # exact frame index
        expSyllableInstr.setAutoDraw(True)
    
    # *expSyllableStart* updates
    if t >= 0.0 and expSyllableStart.status == NOT_STARTED:
        # keep track of start time/frame for later
        expSyllableStart.tStart = t
        expSyllableStart.frameNStart = frameN  # exact frame index
        expSyllableStart.status = STARTED
        # keyboard checking is just starting
        event.clearEvents(eventType='keyboard')
    if expSyllableStart.status == STARTED:
        theseKeys = event.getKeys(keyList=['0'])
        
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
syllableLoop = data.TrialHandler(nReps=1, method='random', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions(conditionSylExp),
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
    expSylAnsCVC.setText(leftKey)
    expSylAnsCV.setText(rightKey)
    expSylTarget.setText(syllabification)
    expSyl_key_resp = event.BuilderKeyResponse()
    # keep track of which components have finished
    trialSyllableComponents = [expSylAnsCVC, expSylAnsCV, expSylTarget, expSyl_key_resp]
    for thisComponent in trialSyllableComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "trialSyllable"-------
    while continueRoutine and routineTimer.getTime() > 0:
        # get current time
        t = trialSyllableClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *expSylAnsCVC* updates
        if t >= 2 and expSylAnsCVC.status == NOT_STARTED:
            # keep track of start time/frame for later
            expSylAnsCVC.tStart = t
            expSylAnsCVC.frameNStart = frameN  # exact frame index
            expSylAnsCVC.setAutoDraw(True)
        frameRemains = 2 + 2- win.monitorFramePeriod * 0.75  # most of one frame period left
        if expSylAnsCVC.status == STARTED and t >= frameRemains:
            expSylAnsCVC.setAutoDraw(False)
        
        # *expSylAnsCV* updates
        if t >= 2 and expSylAnsCV.status == NOT_STARTED:
            # keep track of start time/frame for later
            expSylAnsCV.tStart = t
            expSylAnsCV.frameNStart = frameN  # exact frame index
            expSylAnsCV.setAutoDraw(True)
        frameRemains = 2 + 2- win.monitorFramePeriod * 0.75  # most of one frame period left
        if expSylAnsCV.status == STARTED and t >= frameRemains:
            expSylAnsCV.setAutoDraw(False)
        
        # *expSylTarget* updates
        if t >= 0.5 and expSylTarget.status == NOT_STARTED:
            # keep track of start time/frame for later
            expSylTarget.tStart = t
            expSylTarget.frameNStart = frameN  # exact frame index
            expSylTarget.setAutoDraw(True)
        frameRemains = 0.5 + 1.5- win.monitorFramePeriod * 0.75  # most of one frame period left
        if expSylTarget.status == STARTED and t >= frameRemains:
            expSylTarget.setAutoDraw(False)
        
        # *expSyl_key_resp* updates
        if t >= 2 and expSyl_key_resp.status == NOT_STARTED:
            # keep track of start time/frame for later
            expSyl_key_resp.tStart = t
            expSyl_key_resp.frameNStart = frameN  # exact frame index
            expSyl_key_resp.status = STARTED
            # keyboard checking is just starting
            win.callOnFlip(expSyl_key_resp.clock.reset)  # t=0 on next screen flip
            event.clearEvents(eventType='keyboard')
        frameRemains = 2 + 2- win.monitorFramePeriod * 0.75  # most of one frame period left
        if expSyl_key_resp.status == STARTED and t >= frameRemains:
            expSyl_key_resp.status = FINISHED
        if expSyl_key_resp.status == STARTED:
            theseKeys = event.getKeys(keyList=['2', '3'])
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                if expSyl_key_resp.keys == []:  # then this was the first keypress
                    expSyl_key_resp.keys = theseKeys[0]  # just the first key pressed
                    expSyl_key_resp.rt = expSyl_key_resp.clock.getTime()
                    # was this 'correct'?
                    if (expSyl_key_resp.keys == str(corrAns)) or (expSyl_key_resp.keys == corrAns):
                        expSyl_key_resp.corr = 1
                    else:
                        expSyl_key_resp.corr = 0
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
    if expSyl_key_resp.keys in ['', [], None]:  # No response was made
        expSyl_key_resp.keys=None
        # was no response the correct answer?!
        if str(corrAns).lower() == 'none':
           expSyl_key_resp.corr = 1;  # correct non-response
        else:
           expSyl_key_resp.corr = 0;  # failed to respond (incorrectly)
    # store data for syllableLoop (TrialHandler)
    syllableLoop.addData('expSyl_key_resp.keys',expSyl_key_resp.keys)
    syllableLoop.addData('expSyl_key_resp.corr', expSyl_key_resp.corr)
    if expSyl_key_resp.keys != None:  # we had a response
        syllableLoop.addData('expSyl_key_resp.rt', expSyl_key_resp.rt)
    thisExp.nextEntry()
    
# completed 1 repeats of 'syllableLoop'


# ------Prepare to start Routine "lexTaleEngInstructions"-------
t = 0
lexTaleEngInstructionsClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
start_LexEng = event.BuilderKeyResponse()
# keep track of which components have finished
lexTaleEngInstructionsComponents = [lexEng_Instr, start_LexEng]
for thisComponent in lexTaleEngInstructionsComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "lexTaleEngInstructions"-------
while continueRoutine:
    # get current time
    t = lexTaleEngInstructionsClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame
    
    # *lexEng_Instr* updates
    if t >= 0.0 and lexEng_Instr.status == NOT_STARTED:
        # keep track of start time/frame for later
        lexEng_Instr.tStart = t
        lexEng_Instr.frameNStart = frameN  # exact frame index
        lexEng_Instr.setAutoDraw(True)
    
    # *start_LexEng* updates
    if t >= 0.0 and start_LexEng.status == NOT_STARTED:
        # keep track of start time/frame for later
        start_LexEng.tStart = t
        start_LexEng.frameNStart = frameN  # exact frame index
        start_LexEng.status = STARTED
        # keyboard checking is just starting
    if start_LexEng.status == STARTED:
        theseKeys = event.getKeys(keyList=['0'])
        
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
    for thisComponent in lexTaleEngInstructionsComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "lexTaleEngInstructions"-------
for thisComponent in lexTaleEngInstructionsComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# the Routine "lexTaleEngInstructions" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# set up handler to look after randomisation of conditions etc
lexEngLoop = data.TrialHandler(nReps=1, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('data/processed_data/exp_files/lexTaleListEng.csv'),
    seed=None, name='lexEngLoop')
thisExp.addLoop(lexEngLoop)  # add the loop to the experiment
thisLexEngLoop = lexEngLoop.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisLexEngLoop.rgb)
if thisLexEngLoop != None:
    for paramName in thisLexEngLoop:
        exec('{} = thisLexEngLoop[paramName]'.format(paramName))

for thisLexEngLoop in lexEngLoop:
    currentLoop = lexEngLoop
    # abbreviate parameter names if possible (e.g. rgb = thisLexEngLoop.rgb)
    if thisLexEngLoop != None:
        for paramName in thisLexEngLoop:
            exec('{} = thisLexEngLoop[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "lexTaleEng"-------
    t = 0
    lexTaleEngClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    eng_Word.setText(Word)
    lexEng_key_resp = event.BuilderKeyResponse()
    # keep track of which components have finished
    lexTaleEngComponents = [eng_Word, eng_Yes, eng_No, lexEng_key_resp]
    for thisComponent in lexTaleEngComponents:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "lexTaleEng"-------
    while continueRoutine:
        # get current time
        t = lexTaleEngClock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *eng_Word* updates
        if t >= 0.2 and eng_Word.status == NOT_STARTED:
            # keep track of start time/frame for later
            eng_Word.tStart = t
            eng_Word.frameNStart = frameN  # exact frame index
            eng_Word.setAutoDraw(True)
        
        # *eng_Yes* updates
        if t >= 0.2 and eng_Yes.status == NOT_STARTED:
            # keep track of start time/frame for later
            eng_Yes.tStart = t
            eng_Yes.frameNStart = frameN  # exact frame index
            eng_Yes.setAutoDraw(True)
        
        # *eng_No* updates
        if t >= 0.2 and eng_No.status == NOT_STARTED:
            # keep track of start time/frame for later
            eng_No.tStart = t
            eng_No.frameNStart = frameN  # exact frame index
            eng_No.setAutoDraw(True)
        
        # *lexEng_key_resp* updates
        if t >= 0.2 and lexEng_key_resp.status == NOT_STARTED:
            # keep track of start time/frame for later
            lexEng_key_resp.tStart = t
            lexEng_key_resp.frameNStart = frameN  # exact frame index
            lexEng_key_resp.status = STARTED
            # keyboard checking is just starting
            lexEng_key_resp.clock.reset()  # now t=0
        if lexEng_key_resp.status == STARTED:
            theseKeys = event.getKeys(keyList=['1', '4'])
            
            # check for quit:
            if "escape" in theseKeys:
                endExpNow = True
            if len(theseKeys) > 0:  # at least one key was pressed
                if lexEng_key_resp.keys == []:  # then this was the first keypress
                    lexEng_key_resp.keys = theseKeys[0]  # just the first key pressed
                    lexEng_key_resp.rt = lexEng_key_resp.clock.getTime()
                    # was this 'correct'?
                    if (lexEng_key_resp.keys == str(corrAnsEngV)) or (lexEng_key_resp.keys == corrAnsEngV):
                        lexEng_key_resp.corr = 1
                    else:
                        lexEng_key_resp.corr = 0
                    # a response ends the routine
                    continueRoutine = False
        
        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in lexTaleEngComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "lexTaleEng"-------
    for thisComponent in lexTaleEngComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # check responses
    if lexEng_key_resp.keys in ['', [], None]:  # No response was made
        lexEng_key_resp.keys=None
        # was no response the correct answer?!
        if str(corrAnsEngV).lower() == 'none':
           lexEng_key_resp.corr = 1;  # correct non-response
        else:
           lexEng_key_resp.corr = 0;  # failed to respond (incorrectly)
    # store data for lexEngLoop (TrialHandler)
    lexEngLoop.addData('lexEng_key_resp.keys',lexEng_key_resp.keys)
    lexEngLoop.addData('lexEng_key_resp.corr', lexEng_key_resp.corr)
    if lexEng_key_resp.keys != None:  # we had a response
        lexEngLoop.addData('lexEng_key_resp.rt', lexEng_key_resp.rt)
    # the Routine "lexTaleEng" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()
    
# completed 1 repeats of 'lexEngLoop'


# ------Prepare to start Routine "instructions_blp"-------
t = 0
instructions_blpClock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_instructions = event.BuilderKeyResponse()
# keep track of which components have finished
instructions_blpComponents = [text_instructions, key_resp_instructions]
for thisComponent in instructions_blpComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "instructions_blp"-------
while continueRoutine:
    # get current time
    t = instructions_blpClock.getTime()
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
        theseKeys = event.getKeys(keyList=['0'])
        
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
    for thisComponent in instructions_blpComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "instructions_blp"-------
for thisComponent in instructions_blpComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# the Routine "instructions_blp" was not non-slip safe, so reset the non-slip timer
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
        theseKeys = event.getKeys(keyList=['0'])
        
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
trials_blp_hist = data.TrialHandler(nReps=1, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('data/processed_data/exp_files/sp_en_blp_trials.csv', selection='0:2'),
    seed=None, name='trials_blp_hist')
thisExp.addLoop(trials_blp_hist)  # add the loop to the experiment
thisTrials_blp_hist = trials_blp_hist.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisTrials_blp_hist.rgb)
if thisTrials_blp_hist != None:
    for paramName in thisTrials_blp_hist:
        exec('{} = thisTrials_blp_hist[paramName]'.format(paramName))

for thisTrials_blp_hist in trials_blp_hist:
    currentLoop = trials_blp_hist
    # abbreviate parameter names if possible (e.g. rgb = thisTrials_blp_hist.rgb)
    if thisTrials_blp_hist != None:
        for paramName in thisTrials_blp_hist:
            exec('{} = thisTrials_blp_hist[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "language_history"-------
    t = 0
    language_historyClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    text_section_lang_hist.setText(eval(section)
)
    text_lang_hist_question.setText(eval(questionText))
    text_lang_hist_lang.setColor(color, colorSpace='rgb')
    text_lang_hist_lang.setText(eval(language))
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
    # store data for trials_blp_hist (TrialHandler)
    trials_blp_hist.addData('rating_lang_hist.response', rating_lang_hist.getRating())
    trials_blp_hist.addData('rating_lang_hist.rt', rating_lang_hist.getRT())
    # the Routine "language_history" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()
    
# completed 1 repeats of 'trials_blp_hist'


# set up handler to look after randomisation of conditions etc
trials_blp_hist_2 = data.TrialHandler(nReps=1, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('data/processed_data/exp_files/sp_en_blp_trials.csv', selection='2:4'),
    seed=None, name='trials_blp_hist_2')
thisExp.addLoop(trials_blp_hist_2)  # add the loop to the experiment
thisTrials_blp_hist_2 = trials_blp_hist_2.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisTrials_blp_hist_2.rgb)
if thisTrials_blp_hist_2 != None:
    for paramName in thisTrials_blp_hist_2:
        exec('{} = thisTrials_blp_hist_2[paramName]'.format(paramName))

for thisTrials_blp_hist_2 in trials_blp_hist_2:
    currentLoop = trials_blp_hist_2
    # abbreviate parameter names if possible (e.g. rgb = thisTrials_blp_hist_2.rgb)
    if thisTrials_blp_hist_2 != None:
        for paramName in thisTrials_blp_hist_2:
            exec('{} = thisTrials_blp_hist_2[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "language_history_2"-------
    t = 0
    language_history_2Clock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    text_section_lang_hist_2.setText(eval(section)
)
    text_lang_hist_question_2.setText(eval(questionText))
    text_lang_hist_lang_2.setColor(color, colorSpace='rgb')
    text_lang_hist_lang_2.setText(eval(language))
    text_lang_hist_qnum_2.setText(questionNum)
    rating_lang_hist_2.reset()
    # keep track of which components have finished
    language_history_2Components = [text_section_lang_hist_2, text_lang_hist_question_2, text_lang_hist_lang_2, text_lang_hist_qnum_2, rating_lang_hist_2]
    for thisComponent in language_history_2Components:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "language_history_2"-------
    while continueRoutine:
        # get current time
        t = language_history_2Clock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *text_section_lang_hist_2* updates
        if t >= 0.0 and text_section_lang_hist_2.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_section_lang_hist_2.tStart = t
            text_section_lang_hist_2.frameNStart = frameN  # exact frame index
            text_section_lang_hist_2.setAutoDraw(True)
        
        # *text_lang_hist_question_2* updates
        if t >= 0.0 and text_lang_hist_question_2.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_hist_question_2.tStart = t
            text_lang_hist_question_2.frameNStart = frameN  # exact frame index
            text_lang_hist_question_2.setAutoDraw(True)
        
        # *text_lang_hist_lang_2* updates
        if t >= 0.0 and text_lang_hist_lang_2.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_hist_lang_2.tStart = t
            text_lang_hist_lang_2.frameNStart = frameN  # exact frame index
            text_lang_hist_lang_2.setAutoDraw(True)
        
        # *text_lang_hist_qnum_2* updates
        if t >= 0.0 and text_lang_hist_qnum_2.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_hist_qnum_2.tStart = t
            text_lang_hist_qnum_2.frameNStart = frameN  # exact frame index
            text_lang_hist_qnum_2.setAutoDraw(True)
        # *rating_lang_hist_2* updates
        if t >= 0.0 and rating_lang_hist_2.status == NOT_STARTED:
            # keep track of start time/frame for later
            rating_lang_hist_2.tStart = t
            rating_lang_hist_2.frameNStart = frameN  # exact frame index
            rating_lang_hist_2.setAutoDraw(True)
        continueRoutine &= rating_lang_hist_2.noResponse  # a response ends the trial
        
        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in language_history_2Components:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "language_history_2"-------
    for thisComponent in language_history_2Components:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # store data for trials_blp_hist_2 (TrialHandler)
    trials_blp_hist_2.addData('rating_lang_hist_2.response', rating_lang_hist_2.getRating())
    trials_blp_hist_2.addData('rating_lang_hist_2.rt', rating_lang_hist_2.getRT())
    # the Routine "language_history_2" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()
    
# completed 1 repeats of 'trials_blp_hist_2'


# set up handler to look after randomisation of conditions etc
trials_blp_hist_3 = data.TrialHandler(nReps=1, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('data/processed_data/exp_files/sp_en_blp_trials.csv', selection='4:12'),
    seed=None, name='trials_blp_hist_3')
thisExp.addLoop(trials_blp_hist_3)  # add the loop to the experiment
thisTrials_blp_hist_3 = trials_blp_hist_3.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisTrials_blp_hist_3.rgb)
if thisTrials_blp_hist_3 != None:
    for paramName in thisTrials_blp_hist_3:
        exec('{} = thisTrials_blp_hist_3[paramName]'.format(paramName))

for thisTrials_blp_hist_3 in trials_blp_hist_3:
    currentLoop = trials_blp_hist_3
    # abbreviate parameter names if possible (e.g. rgb = thisTrials_blp_hist_3.rgb)
    if thisTrials_blp_hist_3 != None:
        for paramName in thisTrials_blp_hist_3:
            exec('{} = thisTrials_blp_hist_3[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "language_history_3"-------
    t = 0
    language_history_3Clock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    text_section_lang_hist_3.setText(eval(section)
)
    text_lang_hist_question_3.setText(eval(questionText))
    text_lang_hist_lang_3.setColor(color, colorSpace='rgb')
    text_lang_hist_lang_3.setText(eval(language))
    text_lang_hist_qnum_3.setText(questionNum)
    rating_lang_hist_3.reset()
    # keep track of which components have finished
    language_history_3Components = [text_section_lang_hist_3, text_lang_hist_question_3, text_lang_hist_lang_3, text_lang_hist_qnum_3, rating_lang_hist_3]
    for thisComponent in language_history_3Components:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    
    # -------Start Routine "language_history_3"-------
    while continueRoutine:
        # get current time
        t = language_history_3Clock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *text_section_lang_hist_3* updates
        if t >= 0.0 and text_section_lang_hist_3.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_section_lang_hist_3.tStart = t
            text_section_lang_hist_3.frameNStart = frameN  # exact frame index
            text_section_lang_hist_3.setAutoDraw(True)
        
        # *text_lang_hist_question_3* updates
        if t >= 0.0 and text_lang_hist_question_3.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_hist_question_3.tStart = t
            text_lang_hist_question_3.frameNStart = frameN  # exact frame index
            text_lang_hist_question_3.setAutoDraw(True)
        
        # *text_lang_hist_lang_3* updates
        if t >= 0.0 and text_lang_hist_lang_3.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_hist_lang_3.tStart = t
            text_lang_hist_lang_3.frameNStart = frameN  # exact frame index
            text_lang_hist_lang_3.setAutoDraw(True)
        
        # *text_lang_hist_qnum_3* updates
        if t >= 0.0 and text_lang_hist_qnum_3.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_hist_qnum_3.tStart = t
            text_lang_hist_qnum_3.frameNStart = frameN  # exact frame index
            text_lang_hist_qnum_3.setAutoDraw(True)
        # *rating_lang_hist_3* updates
        if t >= 0.0 and rating_lang_hist_3.status == NOT_STARTED:
            # keep track of start time/frame for later
            rating_lang_hist_3.tStart = t
            rating_lang_hist_3.frameNStart = frameN  # exact frame index
            rating_lang_hist_3.setAutoDraw(True)
        continueRoutine &= rating_lang_hist_3.noResponse  # a response ends the trial
        
        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in language_history_3Components:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
    
    # -------Ending Routine "language_history_3"-------
    for thisComponent in language_history_3Components:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # store data for trials_blp_hist_3 (TrialHandler)
    trials_blp_hist_3.addData('rating_lang_hist_3.response', rating_lang_hist_3.getRating())
    trials_blp_hist_3.addData('rating_lang_hist_3.rt', rating_lang_hist_3.getRT())
    # the Routine "language_history_3" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()
    
# completed 1 repeats of 'trials_blp_hist_3'


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
        theseKeys = event.getKeys(keyList=['0'])
        
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
trials_blp_use = data.TrialHandler(nReps=1, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('data/processed_data/exp_files/sp_en_blp_trials.csv', selection='12:27'),
    seed=None, name='trials_blp_use')
thisExp.addLoop(trials_blp_use)  # add the loop to the experiment
thisTrials_blp_use = trials_blp_use.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisTrials_blp_use.rgb)
if thisTrials_blp_use != None:
    for paramName in thisTrials_blp_use:
        exec('{} = thisTrials_blp_use[paramName]'.format(paramName))

for thisTrials_blp_use in trials_blp_use:
    currentLoop = trials_blp_use
    # abbreviate parameter names if possible (e.g. rgb = thisTrials_blp_use.rgb)
    if thisTrials_blp_use != None:
        for paramName in thisTrials_blp_use:
            exec('{} = thisTrials_blp_use[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "language_use"-------
    t = 0
    language_useClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    text_section_lang_use.setText(eval(section))
    text_lang_use_question.setText(eval(questionText))
    text_lang_use_lang.setColor(color, colorSpace='rgb')
    text_lang_use_lang.setText(eval(language))
    text_lang_use_qnum.setText(questionNum)
    rating_blp_use.reset()
    # keep track of which components have finished
    language_useComponents = [text_section_lang_use, text_lang_use_question, text_lang_use_lang, text_lang_use_qnum, rating_blp_use]
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
        # *rating_blp_use* updates
        if t >= 0.0 and rating_blp_use.status == NOT_STARTED:
            # keep track of start time/frame for later
            rating_blp_use.tStart = t
            rating_blp_use.frameNStart = frameN  # exact frame index
            rating_blp_use.setAutoDraw(True)
        continueRoutine &= rating_blp_use.noResponse  # a response ends the trial
        
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
    # store data for trials_blp_use (TrialHandler)
    trials_blp_use.addData('rating_blp_use.response', rating_blp_use.getRating())
    trials_blp_use.addData('rating_blp_use.rt', rating_blp_use.getRT())
    # the Routine "language_use" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()
    
# completed 1 repeats of 'trials_blp_use'


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
        theseKeys = event.getKeys(keyList=['0'])
        
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
trials_blp_prof = data.TrialHandler(nReps=1, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('data/processed_data/exp_files/sp_en_blp_trials.csv', selection='27:35'),
    seed=None, name='trials_blp_prof')
thisExp.addLoop(trials_blp_prof)  # add the loop to the experiment
thisTrials_blp_prof = trials_blp_prof.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisTrials_blp_prof.rgb)
if thisTrials_blp_prof != None:
    for paramName in thisTrials_blp_prof:
        exec('{} = thisTrials_blp_prof[paramName]'.format(paramName))

for thisTrials_blp_prof in trials_blp_prof:
    currentLoop = trials_blp_prof
    # abbreviate parameter names if possible (e.g. rgb = thisTrials_blp_prof.rgb)
    if thisTrials_blp_prof != None:
        for paramName in thisTrials_blp_prof:
            exec('{} = thisTrials_blp_prof[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "language_proficiency"-------
    t = 0
    language_proficiencyClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    text_section_lang_prof.setText(eval(section))
    text_lang_prof_question.setText(eval(questionText))
    text_lang_prof_lang.setColor(color, colorSpace='rgb')
    text_lang_prof_lang.setText(eval(language))
    text_lang_prof_qnum.setText(questionNum)
    rating_lang_prof.reset()
    # keep track of which components have finished
    language_proficiencyComponents = [text_section_lang_prof, text_lang_prof_question, text_lang_prof_lang, text_lang_prof_qnum, rating_lang_prof]
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
    # store data for trials_blp_prof (TrialHandler)
    trials_blp_prof.addData('rating_lang_prof.response', rating_lang_prof.getRating())
    trials_blp_prof.addData('rating_lang_prof.rt', rating_lang_prof.getRT())
    # the Routine "language_proficiency" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()
    
# completed 1 repeats of 'trials_blp_prof'


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
        theseKeys = event.getKeys(keyList=['0'])
        
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
trials_blp_att = data.TrialHandler(nReps=1, method='sequential', 
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('data/processed_data/exp_files/sp_en_blp_trials.csv', selection='35:43'),
    seed=None, name='trials_blp_att')
thisExp.addLoop(trials_blp_att)  # add the loop to the experiment
thisTrials_blp_att = trials_blp_att.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisTrials_blp_att.rgb)
if thisTrials_blp_att != None:
    for paramName in thisTrials_blp_att:
        exec('{} = thisTrials_blp_att[paramName]'.format(paramName))

for thisTrials_blp_att in trials_blp_att:
    currentLoop = trials_blp_att
    # abbreviate parameter names if possible (e.g. rgb = thisTrials_blp_att.rgb)
    if thisTrials_blp_att != None:
        for paramName in thisTrials_blp_att:
            exec('{} = thisTrials_blp_att[paramName]'.format(paramName))
    
    # ------Prepare to start Routine "language_attitudes"-------
    t = 0
    language_attitudesClock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    text_lang_att_section.setText(eval(section))
    text_lang_att_ques.setText(eval(questionText))
    text_lang_prof_att.setColor(color, colorSpace='rgb')
    text_lang_prof_att.setText(eval(language))
    text_lang_att_qnum.setText(questionNum)
    rating_lang_att.reset()
    # keep track of which components have finished
    language_attitudesComponents = [text_lang_att_section, text_lang_att_ques, text_lang_prof_att, text_lang_att_qnum, rating_lang_att]
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
        
        # *text_lang_prof_att* updates
        if t >= 0.0 and text_lang_prof_att.status == NOT_STARTED:
            # keep track of start time/frame for later
            text_lang_prof_att.tStart = t
            text_lang_prof_att.frameNStart = frameN  # exact frame index
            text_lang_prof_att.setAutoDraw(True)
        
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
    # store data for trials_blp_att (TrialHandler)
    trials_blp_att.addData('rating_lang_att.response', rating_lang_att.getRating())
    trials_blp_att.addData('rating_lang_att.rt', rating_lang_att.getRT())
    # the Routine "language_attitudes" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()
    
# completed 1 repeats of 'trials_blp_att'


# ------Prepare to start Routine "gracias"-------
t = 0
graciasClock.reset()  # clock
frameN = -1
continueRoutine = True
routineTimer.add(5.000000)
# update component parameters for each repeat
# keep track of which components have finished
graciasComponents = [Gracias]
for thisComponent in graciasComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "gracias"-------
while continueRoutine and routineTimer.getTime() > 0:
    # get current time
    t = graciasClock.getTime()
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
    for thisComponent in graciasComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished
    
    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "gracias"-------
for thisComponent in graciasComponents:
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

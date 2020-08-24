[![](https://img.shields.io/badge/Octave-CI-blue?logo=Octave&logoColor=white)](https://github.com/cpp-lln-lab/localizer_auditory_motion/actions)
![](https://github.com/cpp-lln-lab/localizer_auditory_motion/workflows/CI/badge.svg)

[![codecov](https://codecov.io/gh/cpp-lln-lab/localizer_auditory_motion/branch/master/graph/badge.svg)](https://codecov.io/gh/cpp-lln-lab/localizer_auditory_motion)

[![Build Status](https://travis-ci.com/cpp-lln-lab/localizer_auditory_motion.svg?branch=master)](https://travis-ci.com/cpp-lln-lab/localizer_auditory_motion)


# Auditory Translational Motion

<!-- vscode-markdown-toc -->

- 1. [Requirements](#Requirements)
- 2. [Installation](#Installation)
- 3. [Structure and function details](#Structureandfunctiondetails)
     _ 3.1. [audioLocTranslational](#audioLocTranslational)
     _ 3.2. [setParameters](#setParameters)
     _ 3.3. [subfun/expDesign](#subfunexpDesign)
     _ 3.3.1. [EVENTS](#EVENTS)
     _ 3.3.2. [TARGETS:](#TARGETS:)
     _ 3.3.3. [Input:](#Input:)
     _ 3.3.4. [Output:](#Output:)
     _ 3.4. [subfun/eyeTracker](#subfuneyeTracker) \* 3.5. [subfun/wait4Trigger](#subfunwait4Trigger)

<!-- vscode-markdown-toc-config
	numbering=true
	autoSave=true
	/vscode-markdown-toc-config -->
<!-- /vscode-markdown-toc -->

## 1. <a name='Requirements'></a>Requirements

Make sure that the following toolboxes are installed and added to the matlab / octave path.

For instructions see the following links:

| Requirements                                             | Used version |
| -------------------------------------------------------- | ------------ |
| [PsychToolBox](http://psychtoolbox.org/)                 | >=3.0.14     |
| [Matlab](https://www.mathworks.com/products/matlab.html) | >=2017b      |
| or [octave](https://www.gnu.org/software/octave/)        | >=4.?        |

## 2. <a name='Installation'></a>Installation

The CPP_BIDS and CPP_PTB dependencies are already set up as submodule to this repository.
You can install it all with git by doing.

```bash
git clone --recurse-submodules https://github.com/cpp-lln-lab/localizer_auditory_motion.git
```

## 3. <a name='Structureandfunctiondetails'></a>Structure and function details

### 3.1. <a name='audioLocTranslational'></a>audioLocTranslational

Running this script will play blocks of motion/static sounds. Motion blocks will play sounds moving in one of four directions (up-, down-, left-, and right-ward)

By default it is run in `Debug mode` meaning that it does not care about subjID, run n., fMRI triggers, Eye Tracker, etc..

Any details of the experiment can be changed in `setParameters.m` (e.g., experiment mode, motion stimuli details, exp. design, etc.)

### 3.2. <a name='setParameters'></a>setParameters

`setParameters.m` is the core engine of the experiment. It contains the following tweakable sections:

- Debug mode setting
- Engine parameters:
  - Devices parameters
  - Monitor parameters
  - Keyboard parameters
  - MRI parameters
- Experiment Design
- Timing
- Auditory Stimulation
- Task(s)
  - Instructions
  - Task #1 parameters

### 3.3. <a name='subfunexpDesign'></a>subfun/expDesign

Creates the sequence of blocks and the events in them. The conditions are consecutive static and motion blocks (Gives better results than randomised). It can be run as a stand alone without inputs to display a visual example of a possible design.

#### 3.3.1. <a name='EVENTS'></a>EVENTS

The `numEventsPerBlock` should be a multiple of the number of "base" listed in the `motionDirections` and `staticDirections` (4 at the moment).

#### 3.3.2. <a name='TARGETS:'></a>TARGETS:

- If there are 2 targets per block we make sure that they are at least 2 events apart.
- Targets cannot be on the first or last event of a block

#### 3.3.3. <a name='Input:'></a>Input:

- `expParameters`: parameters returned by `setParameters`
- `displayFigs`: a boolean to decide whether to show the basic design matrix of the design

#### 3.3.4. <a name='Output:'></a>Output:

- `expParameters.designBlockNames` is a cell array `(nr_blocks, 1)` with the name for each block
- `expParameters.designDirections` is an array `(nr_blocks, numEventsPerBlock)` with the direction to present in a given block
  - `0 90 180 270` indicate the angle
  - `-1` indicates static
- `expParameters.designSpeeds` is an array `(nr_blocks, numEventsPerBlock) * speedEvent`
- `expParameters.designFixationTargets` is an array `(nr_blocks, numEventsPerBlock)` showing for each event if it should be accompanied by a target

### 3.4. <a name='subfuneyeTracker'></a>subfun/eyeTracker

Eyetracker script, still to be debugged. Will probably moved in the CPP_PTB package. It deals with the calibration (dufault or custom), eye movements recording and saving the files.

### 3.5. <a name='subfunwait4Trigger'></a>subfun/wait4Trigger

Simple functions that counts the triggers sent by the MRI computer to the stimulation computer to sync brain volume recordings and stimulation.

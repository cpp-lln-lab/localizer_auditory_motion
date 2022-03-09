## Structure and function details

`setParameters.m` is the core engine of the experiment. It contains the
following tweakable sections. See
[docs/configuration](.docs/../docs/configuration.md) for more information.

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

#### Let the scanner pace the experiment

Set `cfg.pacedByTriggers.do` to `true` and you can then set all the details in
this `if` block

```matlab
% Time is here in in terms of number repetition time (i.e MRI volumes)
if cfg.pacedByTriggers.do

  cfg.pacedByTriggers.quietMode = true;
  cfg.pacedByTriggers.nbTriggers = 1;

  cfg.timing.eventDuration = cfg.mri.repetitionTime / 2 - 0.04; % second

  % Time between blocs in secs
  cfg.timing.IBI = 0;
  % Time between events in secs
  cfg.timing.ISI = 0;
  % Number of seconds before the motion stimuli are presented
  cfg.timing.onsetDelay = 0;
  % Number of seconds after the end all the stimuli before ending the run
  cfg.timing.endDelay = 2;

end
```

### subfun/expDesign

Creates the sequence of blocks and the events in them. The conditions are
consecutive static and motion blocks (Gives better results than randomised). It
can be run as a stand alone without inputs to display a visual example of a
possible design.

#### EVENTS

The `numEventsPerBlock` should be a multiple of the number of "base" listed in
the `motionDirections` and `staticDirections` (4 at the moment).

#### TARGETS

- If there are 2 targets per block we make sure that they are at least 2 events
  apart.
- Targets cannot be on the first or last event of a block

#### Input

- `expParameters`: parameters returned by `setParameters`
- `displayFigs`: a boolean to decide whether to show the basic design matrix of
  the design

#### Output

- `expParameters.designBlockNames` is a cell array `(nr_blocks, 1)` with the
  name for each block
- `expParameters.designDirections` is an array `(nr_blocks, numEventsPerBlock)`
  with the direction to present in a given block
  - `0 90 180 270` indicate the angle
  - `-1` indicates static
- `expParameters.designSpeeds` is an array
  `(nr_blocks, numEventsPerBlock) * speedEvent`
- `expParameters.designFixationTargets` is an array
  `(nr_blocks, numEventsPerBlock)` showing for each event if it should be
  accompanied by a target

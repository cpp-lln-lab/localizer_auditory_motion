function cfg = setParameters

    % AUDITORY LOCALIZER

    % Initialize the parameters and general configuration variables
    cfg = struct();

    % by default the data will be stored in an output folder created where the
    % setParamters.m file is
    % change that if you want the data to be saved somewhere else
    cfg.dir.output = fullfile( ...
        fileparts(mfilename('fullpath')), 'output');

    %% Debug mode settings

    cfg.debug.do = false; % To test the script out of the scanner, skip PTB sync
    cfg.debug.smallWin = false; % To test on a part of the screen, change to 1
    cfg.debug.transpWin = false; % To test with trasparent full size screen

    cfg.verbose = 1;

    %% Engine parameters

    cfg.testingDevice = 'mri';
    cfg.eyeTracker.do = false;
    cfg.audio.do = true;

    cfg = setMonitor(cfg);

    % Keyboards
    cfg = setKeyboards(cfg);

    % MRI settings
    cfg = setMRI(cfg);

    cfg.pacedByTriggers.do = false;

    %% Experiment Design

    %     cfg.design.motionType = 'translation';
    %     cfg.design.motionType = 'radial';
    cfg.design.motionType = 'translation';
    cfg.design.names = {'static'; 'motion'};
    % 0: L--R--L; 180: R--L--R;
    cfg.design.motionDirections = [0 180];
    cfg.design.nbRepetitions = 14;
    cfg.design.nbEventsPerBlock = 6;

    %% Timing

    % FOR 7T: if you want to create localizers on the fly, the following must be
    % multiples of the scanner sequence TR
    %
    % IBI
    % block length = (cfg.eventDuration + cfg.ISI) * cfg.design.nbEventsPerBlock

    % for info: not actually used since "defined" by the sound duration
    %     cfg.timing.eventDuration = 0.850; % second

    % Time between blocs in secs
    cfg.timing.IBI = 0;
    % Time between events in secs
    cfg.timing.ISI = 0;
    % Number of seconds before the motion stimuli are presented
    cfg.timing.onsetDelay = 0;
    % Number of seconds after the end all the stimuli before ending the run
    cfg.timing.endDelay = 3.6;

    % reexpress those in terms of number repetition time
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

    %% Auditory Stimulation

    cfg.audio.channels = 2;

    %% Task(s)

    cfg.task.name = 'auditory localizer';

    % Instruction
    cfg.task.instruction = ['1 - Detect the RED fixation cross\n' ...
      '2 - Detected the shorter repeated sounds'];

    % Fixation cross (in pixels)
    cfg.fixation.type = 'cross';
    cfg.fixation.colorTarget = cfg.color.red;
    cfg.fixation.color = cfg.color.white;
    cfg.fixation.width = .5;
    cfg.fixation.lineWidthPix = 3;
    cfg.fixation.xDisplacement = 0;
    cfg.fixation.yDisplacement = 0;

    cfg.target.maxNbPerBlock = 1;
    cfg.target.duration = 0.5; % In secs

    cfg.extraColumns = {'direction', 'soundTarget', 'fixationTarget', 'event', 'block', 'keyName'};

end

function cfg = setMonitor(cfg)

    % Monitor parameters for PTB
    cfg.color.white = [255 255 255];
    cfg.color.black = [0 0 0];
    cfg.color.red = [255 0 0];
    cfg.color.grey = mean([cfg.color.black; cfg.color.white]);
    cfg.color.background = cfg.color.black;
    cfg.text.color = cfg.color.white;

    % Monitor parameters
    cfg.screen.monitorWidth = 50; % in cm
    cfg.screen.monitorDistance = 40; % distance from the screen in cm

    if strcmpi(cfg.testingDevice, 'mri')
        cfg.screen.monitorWidth = 25;
        cfg.screen.monitorDistance = 95;
    end
end

function cfg = setKeyboards(cfg)
    cfg.keyboard.escapeKey = 'ESCAPE';
    cfg.keyboard.responseKey = { ...
        'r', 'g', 'y', 'b', ...
        'd', 'n', 'z', 'e', ...
        't'}; % dnze rgyb
    cfg.keyboard.keyboard = [];
    cfg.keyboard.responseBox = [];

    if strcmpi(cfg.testingDevice, 'mri')
        cfg.keyboard.keyboard = [];
        cfg.keyboard.responseBox = [];
    end
end

function cfg = setMRI(cfg)
    % letter sent by the trigger to sync stimulation and volume acquisition
    cfg.mri.triggerKey = 't';
    cfg.mri.triggerNb = 5;

    cfg.mri.repetitionTime = 1.8;

    cfg.bids.MRI.Instructions = ['1 - Detect the RED fixation cross\n' ...
      '2 - Detected the shorter repeated sounds'];
    cfg.bids.MRI.TaskDescription = [];

end

%% Auditory hMT localizer using translational motion in four directions
%  (up- down- left and right-ward)

% by Mohamed Rezk 2018
% adapted by MarcoB and RemiG 2020

%%

getOnlyPress = 1;

more off;

% Clear all the previous stuff
% clc; clear;
if ~ismac
    close all;
    clear Screen;
end

% make sure we got access to all the required functions and inputs
initEnv();

% set and load all the parameters to run the experiment
cfg = setParameters;
cfg = userInputs(cfg);
cfg = createFilename(cfg);

%%  Experiment

% Safety loop: close the screen if code crashes
try

    % % % REFACTOR THIS FUNCTION % % %

    [cfg] = loadAudioFiles(cfg);

    % % % REFACTOR THIS FUNCTION % % %

    %% Init the experiment
    [cfg] = initPTB(cfg);

    [el] = eyeTracker('Calibration', cfg);

    [cfg] = expDesign(cfg);

    % Prepare for the output logfiles with all
    logFile.extraColumns = cfg.extraColumns;
    logFile = saveEventsFile('init', cfg, logFile);
    logFile = saveEventsFile('open', cfg, logFile);

    %     disp(cfg);

    % Show experiment instruction
    standByScreen(cfg);

    % prepare the KbQueue to collect responses
    getResponse('init', cfg.keyboard.responseBox, cfg);

    % Wait for Trigger from Scanner
    waitForTrigger(cfg);

    %% Experiment Start
    cfg = getExperimentStart(cfg);

    getResponse('start', cfg.keyboard.responseBox);

    waitFor(cfg, cfg.timing.onsetDelay);

    %% For Each Block

    for iBlock = 1:cfg.design.nbBlocks

        fprintf('\n - Running Block %.0f \n', iBlock);

        eyeTracker('StartRecording', cfg);

        % For each event in the block
        for iEvent = 1:cfg.design.nbEventsPerBlock

            % Check for experiment abortion from operator
            checkAbort(cfg, cfg.keyboard.keyboard);

            % set direction, speed of that event and if it is a target
            thisEvent.trial_type = cfg.design.blockNames{iBlock};
            thisEvent.direction = cfg.design.directions(iBlock, iEvent);
            thisEvent.fixationTarget = cfg.design.fixationTargets(iBlock, iEvent);
            thisEvent.soundTarget = cfg.design.soundTargets(iBlock, iEvent);

            thisEvent.isStim = logFile.isStim;

            % we wait for a trigger every events
            if cfg.pacedByTriggers.do
                waitForTrigger(cfg, ...
                               cfg.keyboard.responseBox, ...
                               cfg.pacedByTriggers.quietMode, ...
                               cfg.pacedByTriggers.nbTriggers);
            end

            % % % REFACTOR THIS FUNCTION % % %
            % play the sounds and collect onset and duration of the event
            [onset, duration] = doAuditoryMotion(cfg, thisEvent);

            thisEvent.event = iEvent;
            thisEvent.block = iBlock;
            thisEvent.keyName = 'n/a';
            thisEvent.duration = duration;
            thisEvent.onset = onset - cfg.experimentStart;

            % Save the events txt logfile
            % we save event by event so we clear this variable every loop
            thisEvent.fileID = logFile.fileID;
            thisEvent.extraColumns = logFile.extraColumns;

            saveEventsFile('save', cfg, thisEvent);

            clear thisEvent;

            % collect the responses and appends to the event structure for
            % saving in the tsv file
            responseEvents = getResponse('check', cfg.keyboard.responseBox, cfg, ...
                                         getOnlyPress);

            triggerString = ['trigger_' cfg.design.blockNames{iBlock}];
            saveResponsesAndTriggers(responseEvents, cfg, logFile, triggerString);

            % wait for the inter-stimulus interval
            waitFor(cfg, cfg.timing.ISI);

        end

        eyeTracker('StopRecordings', cfg);

        waitFor(cfg, cfg.timing.IBI);

        % IBI trigger paced
        if cfg.pacedByTriggers.do
            waitForTrigger( ...
                           cfg, ...
                           cfg.keyboard.responseBox, ...
                           cfg.pacedByTriggers.quietMode, ...
                           cfg.timing.triggerIBI);
        end

        % trigger monitoring
        triggerEvents = getResponse('check', cfg.keyboard.responseBox, cfg, ...
                                    getOnlyPress);

        triggerString = 'trigger_baseline';
        saveResponsesAndTriggers(triggerEvents, cfg, logFile, triggerString);

    end

    % End of the run for the BOLD to go down
    waitFor(cfg, cfg.timing.endDelay);

    cfg = getExperimentEnd(cfg);

    % Close the logfiles
    saveEventsFile('close', cfg, logFile);

    getResponse('stop', cfg.keyboard.responseBox);
    getResponse('release', cfg.keyboard.responseBox);

    eyeTracker('Shutdown', cfg);

    % remove the sound data from the cfg before saving it.
    cfg = rmfield(cfg, 'soundData');
    createJson(cfg, cfg);

    farewellScreen(cfg);

    cleanUp();

catch

    cleanUp();
    psychrethrow(psychlasterror);

end

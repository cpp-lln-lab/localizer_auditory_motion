%% Auditory hMT localizer using translational motion in four directions
%  (up- down- left and right-ward)

% Original Script Written by Sam Weiller to localize MT+/V5
% adapted by M.Rezk to localize MT/MST (Huk,2002)
% re-adapted by MarcoB and RemiG 2020

% Clear all the previous stuff
% clc; clear;
if ~ismac
    close all;
    clear Screen;
end

getOnlyPress = 1;

more off;

% make sure we got access to all the required functions and inputs
initEnv();

cfg = setParameters;
cfg = userInputs(cfg);
cfg = createFilename(cfg);


%%  Experiment

% Safety loop: close the screen if code crashes
try
    
    % % % REFACTOR THIS FUNCTION
    [cfg] = loadAudioFiles(cfg);

    %% Init the experiment
    [cfg] = initPTB(cfg);
    
    % % Convert some values from degrees to pixels
    % cfg = deg2Pix('diameterAperture', cfg, cfg);
    % expParameters = deg2Pix('dotSize', expParameters, cfg);
    
    [el] = eyeTracker('Calibration', cfg);
    
    % % % REFACTOR THIS FUNCTION
    [cfg] = expDesign(cfg);
    
    % Prepare for the output logfiles with all
    logFile = saveEventsFile('open', cfg, [], ...
        'direction', 'speed', 'target', 'event', 'block');

%     disp(cfg);

    standByScreen(cfg);

    % prepare the KbQueue to collect responses
    getResponse('init', cfg.keyboard.responseBox, cfg);

    % Wait for Trigger from Scanner
    waitForTrigger(cfg);

    %% Experiment Start
    cfg = getExperimentStart(cfg);

    getResponse('start', cfg.keyboard.responseBox);

    WaitSecs(cfg.onsetDelay);
    
    %% For Each Block
    
    for iBlock = 1:cfg.numBlocks
        
        fprintf('\n - Running Block %.0f \n',iBlock)
        
        eyeTracker('StartRecording', cfg);
        
        % For each event in the block
        for iEvent = 1:cfg.numEventsPerBlock
                        
            % Check for experiment abortion from operator
            checkAbort(cfg, cfg.keyboard.keyboard);
            
            % set direction, speed of that event and if it is a target
            thisEvent.trial_type = 'dummy';
            thisEvent.direction = cfg.designDirections(iBlock,iEvent);
            thisEvent.speed = cfg.designSpeeds(iBlock,iEvent);
            thisEvent.target = cfg.designFixationTargets(iBlock,iEvent);
            
            % play the sounds and collect onset and duration of the event
            [onset, duration] = doAudMot(cfg, thisEvent, cfg.audio.pahandle);
            
            thisEvent.event = iEvent;
            thisEvent.block = iBlock;
            thisEvent.duration = duration;
            thisEvent.onset = onset - cfg.experimentStart;
            
            % Save the events txt logfile
            % we save event by event so we clear this variable every loop
            thisEvent.fileID = logFile.fileID;
            
            saveEventsFile('save', cfg, thisEvent, ...
                'direction', 'speed', 'target', 'event', 'block');
            
            clear thisEvent
            
            
            % collect the responses and appends to the event structure for
            % saving in the tsv file
            responseEvents = getResponse('check', cfg.keyboard.responseBox, cfg, ...
                getOnlyPress);
            
            triggerString = ['trigger'];
            saveResponsesAndTriggers(responseEvents, cfg, logFile, triggerString);
            
            % wait for the inter-stimulus interval
            WaitSecs(cfg.ISI);
            
        end
        
        eyeTracker('StopRecordings', cfg);
        
        WaitSecs(cfg.IBI);
        
    end
    
    % End of the run for the BOLD to go down
    WaitSecs(cfg.endDelay);
    
    % Close the logfiles
    saveEventsFile('close', cfg, logFile);
    
    getResponse('stop', cfg.keyboard.responseBox);
    getResponse('release', cfg.keyboard.responseBox);
    
    totalExperimentTime = GetSecs-cfg.experimentStart;
    
    eyeTracker('Shutdown', cfg);
    
    % save the whole workspace
    matFile = fullfile(cfg.dir.output, strrep(cfg.fileName.events,'tsv', 'mat'));
    if IsOctave
        save(matFile, '-mat7-binary');
    else
        save(matFile, '-v7.3');
    end
    
    cleanUp()
    
catch
    
    cleanUp()
    psychrethrow(psychlasterror);
    
end

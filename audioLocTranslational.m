%% Auditory hMT localizer using translational motion in four directions
%  (up- down- left and right-ward)

% Original Script Written by Sam Weiller to localize MT+/V5
% adapted by M.Rezk to localize MT/MST (Huk,2002)
% re-adapted by MarcoB and RemiG 2020

%%

% Clear all the previous stuff
% clc; clear;
if ~ismac
    close all;
    clear Screen;
end

% make sure we got access to all the required functions and inputs
addpath(genpath(fullfile(pwd, 'subfun')))

[expParameters, cfg] = setParameters;

% set and load all the parameters to run the experiment
expParameters = userInputs(cfg, expParameters);
expParameters = createFilename(expParameters, cfg);

expParameters %#ok<NOPTS>

%%  Experiment

% Safety loop: close the screen if code crashes
try

    %% Init the experiment
    [cfg] = initPTB(cfg);

    % % Convert some values from degrees to pixels
    % cfg = deg2Pix('diameterAperture', cfg, cfg);
    % expParameters = deg2Pix('dotSize', expParameters, cfg);
    %
    %
    [el] = eyeTracker('Calibration', cfg, expParameters);

    % % % REFACTOR THIS FUNCTION
    [expParameters] = expDesign(expParameters);
    % % %

    % Prepare for the output logfiles with all
    logFile = saveEventsFile('open', expParameters, [], ...
    'direction', 'speed', 'target', 'event', 'block');

    % % % REFACTOR THIS FUNCTION
    [soundData, freq] = loadAudioFiles(SubjName);
    phandle = PsychPortAudio('Open',[],[],1,freq,2);
    % % %

    % Prepare for fixation Cross
    if expParameters.Task1

        cfg.xCoords = [-expParameters.fixCrossDimPix expParameters.fixCrossDimPix 0 0] ...
            + expParameters.xDisplacementFixCross;

        cfg.yCoords = [0 0 -expParameters.fixCrossDimPix expParameters.fixCrossDimPix] ...
            + expParameters.yDisplacementFixCross;

        cfg.allCoords = [cfg.xCoords; cfg.yCoords];

    end



catch

  cleanUp()
  psychrethrow(psychlasterror);

end

function [cfg] = loadAudioFiles(cfg)

    %% Get parameters

    % Set the subj name to retrieve its own sounds
    if cfg.debug.do
        subjName = 'sub-ctrl666';
    else
        zeroPadding = 3;
        pattern = ['%0' num2str(zeroPadding) '.0f'];
        subjName = ['sub-' cfg.subject.subjectGrp, sprintf(pattern, cfg.subject.subjectNb)];
    end

    %% Load the sounds
    
    % static Stimuli
    fileName = fullfile('input', 'Static', 'Static.wav');
    [soundData.S, freq1] = audioread(fileName);
    soundData.S = soundData.S';

    % motion input
    fileName = fullfile('input', 'Motion', subjName, [ subjName, '_LRL_rms.wav']);
    [soundData.LRL, freq2] = audioread(fileName);
    soundData.LRL = soundData.LRL';

    fileName = fullfile('input', 'Motion', subjName, [ subjName, '_RLR_rms.wav']);
    [soundData.RLR, freq3] = audioread(fileName);
    soundData.RLR = soundData.RLR';

    %% Targets

    % static Stimuli
    fileName = fullfile('input', 'Static', 'Static_T.wav');
    [soundData.S_T, freq4] = audioread(fileName);
    soundData.S_T = soundData.S_T';

    % motion Stimuli
    fileName = fullfile('input', 'Motion', subjName, [ subjName, '_LRL_T_rms.wav']);
    [soundData.LRL_T, freq5] = audioread(fileName);
    soundData.LRL_T = soundData.LRL_T';

    fileName = fullfile('input', 'Motion', subjName, [ subjName, '_RLR_T_rms.wav']);
    [soundData.RLR_T, freq6] = audioread(fileName);
    soundData.RLR_T = soundData.RLR_T';

    if length(unique([ freq1 freq2 freq3 freq4 freq5 freq6 ])) > 1
        error ('Sounds do not have the same frequency');
    else
        freq = unique([ freq1 freq2 freq3 freq4 freq5 freq6 ]);
    end

    cfg.soundData = soundData;
    cfg.audio.fs = freq;

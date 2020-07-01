function [expParameters] = loadAudioFiles(cfg, expParameters)

%% Get parameters

% Set the subj name to retrieve its own sounds
if cfg.debug
  subjName = 'sub-ctrl666';
else
  zeroPadding = 3;
  pattern = ['%0' num2str(zeroPadding) '.0f'];
  subjName = ['sub-' expParameters.subjectGrp, sprintf(pattern, expParameters.subjectNb)];
end

%% Load the sounds

%static Stimuli
fileName=fullfile('input','Static','Static.wav');
[soundData.S , freq1] = audioread(fileName);
soundData.S = soundData.S';

%motion input
fileName=fullfile('input','Motion',subjName,['rms_',subjName,'_U.wav']);
[soundData.U , freq2] = audioread(fileName);
soundData.U = soundData.U';

fileName=fullfile('input','Motion',subjName,['rms_',subjName,'_D.wav']);
[soundData.D , freq3] = audioread(fileName);
soundData.D = soundData.D';

fileName=fullfile('input','Motion',subjName,['rms_',subjName,'_R.wav']);
[soundData.R , freq4] = audioread(fileName);
soundData.R = soundData.R';


fileName=fullfile('input','Motion',subjName,['rms_',subjName,'_L.wav']);
[soundData.L , freq5] = audioread(fileName);
soundData.L = soundData.L';


%% Targets

%static Stimuli
fileName=fullfile('input','Static','Static_T.wav');
[soundData.S_T , freq6] = audioread(fileName);
soundData.S_T = soundData.S_T';

%motion Stimuli
fileName=fullfile('input','Motion',subjName,['rms_',subjName,'_U_T.wav']);
[soundData.U_T , freq7] = audioread(fileName);
soundData.U_T = soundData.U_T';

fileName=fullfile('input','Motion',subjName,['rms_',subjName,'_D_T.wav']);
[soundData.D_T , freq8] = audioread(fileName);
soundData.D_T = soundData.D_T';

fileName=fullfile('input','Motion',subjName,['rms_',subjName,'_R_T.wav']);
[soundData.R_T , freq9] = audioread(fileName);
soundData.R_T = soundData.R_T';


fileName=fullfile('input','Motion',subjName,['rms_',subjName,'_L_T.wav']);
[soundData.L_T , freq10] = audioread(fileName);
soundData.L_T = soundData.L_T';


if length(unique([freq1 freq2 freq3 freq4 freq5 freq6 freq7 freq8 freq9 freq10]))>1
    error ('Sounds dont have the same frequency')
else
    freq = unique([freq1 freq2 freq3 freq4 freq5 freq6 freq7 freq8 freq9 freq10]);
end

expParameters.soundData = soundData;
expParameters.freq = freq;

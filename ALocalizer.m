%function mirror_runMTLocalizer
clear all;
clc

%8 trials =  370 sec (without trigger) =6.17 minutes
% if TR =2 Sec.    370 sec / 2 (TR) = 185 TRs (without trigger) + 4 = 189 TRs  
% if TR =2.5 Sec.  370 sec / 2 (TR) = 148 TRs (without trigger) + 4 = 152 TRs 

%% To correct for the y-axis problem inside the scanner
%  where the lower 1/3 of the screen is not appearing because of coil indicate which device the script is running on, on PC, the middle of the
%  y axis will be the middle of the screen, on the Scanner, the middle of y-axis will be the middle of the upper 2/3 of the screen, because the
%  lower 1/3 is not visible due to the coil in the scanner.
device = 'Scanner';
%device = 'PC';

fprintf('Connected Device is %s \n\n',device);

% Original Script Written by Sam Weiller to localize MT+/V5
% Adapted by M.Rezk to localize MT/MST (Huk,2002)
%% Start me up
% Get the subject Name
SubjName = input('Subject Name: ','s');
       if isempty(SubjName)
          SubjName = 'trial';
       end

fprintf('Auditory MT Localizer \n\n')

%% Experiment Parametes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
initial_wait = 5;                                                              % seconds to have a blank screen at the beginning, the scans will be discarded until                                                                              % the magnetic field is homogenous                                                                         
finalWait = 5;
%blockDur = 16;                                                                 % Block duration [should be a multiple of osc (below)]                                                                               
ISI = 0.1;             % Interstimulus Interval between events in the block.
ibi = 6;                                                                       % Inter-block duration in seconds (time between blocks)
nrBlocks = 14;                                                                 % Number of trials , where 1 block = 1 block of all conditions (static and motion)
numEventsPerBlock = 12;
range_targets = [0 2];                                                         % range of number of targets in each block (from 2 to 5 targets in each block)

mirror_width= 11.5;                                                            % Width (x-axis) of the mirror (in cm)
v_dist      = 14;                                                              % viewing distance from the mirror (cm) "in this script we use mirror"
fix_r       = 0.15;                                                            % radius of fixation point (deg)

%Audiofile_duration = 16 ;                                                      % Length of the Audio file (in seconds)
%Stop_audiofile = blockDur ;                                                    % Let the audio file play for x Seconds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                                               % 1 Cycle = one inward and outward motion together
%% Experimental Design
% function "experimental_design" while assign the blocks, conditions, and 
% the number of targets that will be used in the motion localizer
%[names,targets,condition] = experimental_design(nrBlocks,range_targets);  
[names,targets,condition,directions,isTarget] = experimental_design(nrBlocks,numEventsPerBlock,range_targets) ;

numBlocks = length(names);                                                     % Create a variable with the number of blocks in the whole experiment


%% InitializePsychAudio;
InitializePsychSound(1);

[soundData, freq] = loadAudioFiles(SubjName);
phandle = PsychPortAudio('Open',[],[],1,freq,2);
%PsychPortAudio('FillBuffer',phandle,soundData_static);
%fprintf('\nstatic wav file loaded. \n')

%% PTB Setup
screenNumber = max(Screen('Screens'));
%screenNumber = 0;
%Screen('Preference', 'SkipSyncTests', 2);
[w, winRect, xMid, yMid] = startPTB(screenNumber, 1, [128 128 128]);
HideCursor;

%% Color indeces, and Screen parameters and inter-flip interval.  
% Color indices
white = WhiteIndex(screenNumber);                        
black = BlackIndex(screenNumber);
grey = ceil((white+black)/2);

% Flip interval and screen size
ifi = Screen('GetFlipInterval', w);                                            % Get the flip interval
[tw, th] = Screen('WindowSize', w);

%nframes  = floor(blockDur/ifi);
% while mod(nframes,2)~=0                                                % make sure the nframes are even number
%     nframes = nframes-1;                                                       % to be able to re-assign dots in the static condition (to perform divison calculation)
% end

%% Welcome screen
Screen('TextFont',w, 'Courier New');
Screen('TextSize',w, 20);
Screen('TextStyle', w, 1);
DrawFormattedText(w,'Press for FASTER sound \n\n\n(static or motion)',...
            'center', 'center', black);
Screen('Flip', w);
[~, ~, ~]=KbCheck;
KbWait;
Screen('Flip', w);

WaitSecs(0.25);

% DrawFormattedText(w,'The experiment is about to begin','center', 'center', black);
% Screen('Flip', w);
% [KeyIsDown, pend, KeyCode]=KbCheck;
% 
% KbWait;
% Screen('Flip', w);

%% FUNCTION
if strcmp(device,'PC')
    DrawFormattedText(w,'Waiting For Trigger',...
        'center', 'center', black);
    Screen('Flip', w);
    
    % press key
    KbWait();
    KeyIsDown=1;
    while KeyIsDown>0
        [KeyIsDown, ~, ~]=KbCheck;
    end
    
% open Serial Port "SerPor" - COM1 (BAUD RATE: 11520)
elseif strcmp(device,'Scanner')
    DrawFormattedText(w,'Waiting For Trigger','center', 'center', black);
    Screen('Flip', w);
    SerPor = MT_portAndTrigger;
    Screen('Flip', w);
end

%% Experiment Start (Main Loop)
experimentStartTime = GetSecs;

%% To correct for the y-axis problem inside the scanner
if strcmp(device,'Scanner')
    adjusted_yAxis = 2/3*th;        %  where the lower 1/3 of the screen is not appearing because of coil
elseif strcmp(device,'PC')
    adjusted_yAxis = th;            %  y-axis is the same, no changes
end

%% Pixels per degree
[mirrorPixelPerDegree] = mirror2Pixels (winRect,v_dist,mirror_width) ;         % Calculate pixel per degree on the mirror surface

%% fixation coordiates
fix_cord = [[tw/2 adjusted_yAxis/2]-fix_r*mirrorPixelPerDegree [tw/2 adjusted_yAxis/2]+fix_r*mirrorPixelPerDegree];

%% Experiment start
% The experment will wait (initial_wait)  Secs before running the stimuli
Screen('FillOval', w, uint8(white), fix_cord);	% draw fixation dot (flip erases it)
blank_onset=Screen('Flip', w);
WaitSecs('UntilTime', blank_onset + initial_wait);

targetTime   = [];
responseKey  = [];
responseTime = [];

eventOnsets=zeros(numBlocks,numEventsPerBlock);
eventEnds=zeros(numBlocks,numEventsPerBlock);
eventDurations=zeros(numBlocks,numEventsPerBlock);

responsesPerBlock=zeros(numBlocks,1);

playTime = zeros(numBlocks,1);

for blocks = 1:numBlocks
    
    timeLogger.block(blocks).startTime = GetSecs - experimentStartTime;        % Get the start time of the block
    timeLogger.block(blocks).condition = condition(blocks);                    % Get the condition of the block (motion or static)
    timeLogger.block(blocks).names = names(blocks);                            % Get the name of the block 
    
    responseCount=0;
    
    for iEvent = 1: numEventsPerBlock
        
        Sound=[];
        
        if isTarget(blocks,iEvent)==0
            
            if strcmp(directions(blocks,iEvent),'S')
                Sound= soundData.S;
            elseif strcmp(directions(blocks,iEvent),'U')
                Sound= soundData.U;
            elseif strcmp(directions(blocks,iEvent),'D')
                Sound= soundData.D;
            elseif strcmp(directions(blocks,iEvent),'R')
                Sound= soundData.R;
            elseif strcmp(directions(blocks,iEvent),'L')
                Sound= soundData.L;
            end
        
        elseif isTarget(blocks,iEvent)==1
            
            if strcmp(directions(blocks,iEvent),'S')
                Sound= soundData.S_T;
            elseif strcmp(directions(blocks,iEvent),'U')
                Sound= soundData.U_T;
            elseif strcmp(directions(blocks,iEvent),'D')
                Sound= soundData.D_T;
            elseif strcmp(directions(blocks,iEvent),'R')
                Sound= soundData.R_T;
            elseif strcmp(directions(blocks,iEvent),'L')
                Sound= soundData.L_T;
            end
            
        end
        
        eventOnsets(blocks,iEvent)=GetSecs-experimentStartTime;
        
        PsychPortAudio('FillBuffer',phandle,Sound);
        playTime(blocks,1) = PsychPortAudio('Start',phandle);
         
         %length(playedAudio)/freq
         
         while GetSecs() <= eventOnsets(blocks,iEvent)+ experimentStartTime + (length(Sound)/freq)
             
             if strcmp(device,'Scanner')
                 [sbutton,secs] = TakeSerialButton(SerPor);
                 %[sbutton,secs] = MT_TakeSerialButtonPerFrame(SerPor);
                 %responseKey(end+1)= sbutton;
                 if sbutton~= 0
                     responseTime(end+1)= secs - experimentStartTime;
                     
                     %%%%%%%%%%%%%%%%%%%%%
                     % while you are pressing, wait till it is
                            % released
                            while  sbutton ~= 0
                                [sbutton,secs]= TakeSerialButton(Cfg.SerPor);
                            end
                     %%%%%%%%%%%%%%%%%%%%%
                            
                     responseCount = responseCount + 1;
                 end
                 
                 
                 
             elseif  strcmp(device,'PC')
                 
                 [keyIsDown, secs, ~ ] = KbCheck();
                 
                 if keyIsDown
                     responseTime(end+1)= secs - experimentStartTime;
                     while keyIsDown ==1
                         [keyIsDown , ~] = KbCheck();
                     end
                     
                     responseCount = responseCount + 1;
                 end
             end
             
         end
         
         eventEnds(blocks,iEvent)=GetSecs-experimentStartTime;
         eventDurations(blocks,iEvent)=eventEnds(blocks,iEvent)-eventOnsets(blocks,iEvent);
         
         WaitSecs(ISI);
         
    end
    
    responsesPerBlock (blocks,1) = responseCount ;
    
    %% Get Block end and duration
    timeLogger.block(blocks).endTime = GetSecs - experimentStartTime;            % Get the time for the block end
    timeLogger.block(blocks).length  = timeLogger.block(blocks).endTime - timeLogger.block(blocks).startTime;  %Get the block duration
    
    %% Fixation cross and inter-block interval
    Screen('FillOval', w, uint8(white), fix_cord);	                             % draw fixation dot (flip erases it)
    blank_onset=Screen('Flip', w);
    WaitSecs('UntilTime', blank_onset + ibi);                                    % wait for the inter-block interval
    
end;

% At the end of the blocks wait ... secs before ending the experiment.
Screen('FillOval', w, uint8(white), fix_cord);	% draw fixation dot (flip erases it)
blank_onset=Screen('Flip', w);
WaitSecs('UntilTime', blank_onset + finalWait);


%% Save the results ('names','onsets','ends','duration') of each block
names     = cell(length(timeLogger.block),1);
onsets    = zeros(length(timeLogger.block),1);
ends      = zeros(length(timeLogger.block),1);
durations = zeros(length(timeLogger.block),1);

for i=1:length(timeLogger.block)
    names(i,1)     = timeLogger.block(i).names;
    onsets(i,1)    = timeLogger.block(i).startTime;
    ends(i,1)      = timeLogger.block(i).endTime;
    durations(i,1) = timeLogger.block(i).length;
end

%% KeyPresses and Times
% for i=length(responseKey):-1:2                                                   % responseKey gives a '1' in all frames where button was pressed, so one motor response = gives multiple consequitive '1' frames
%     if responseKey(i-1)~=0                                                       % therefore, we need to cancel consequitive '1' frames after the first button press
%         responseKey(i)=0;                                                        % we loop through the responses and remove '1's that are not preceeded by a zero
%         responseTime(i)=0;                                                       % this way, we remove the additional 1s for the same button response
%     end                                                                          % - The same concept for the responseTime
% end
% 
% for i=length(targetTime):-1:2                                                   % The same concept as responseKey adn responseTime.
%     if targetTime(i-1)~=0                                                       % Our Targets lasts 3 frames, to remove the TargetTime for the 2nd and 3rd frame
%         targetTime(i)=0;                                                        % we remove targets that are preceeded by a non-zero value
%     end                                                                          % that way, we have the time of the first frame only of the target
% end
% 
% responseKey  = responseKey(responseKey > 0);                                       % Remove zero elements from responseKey, responseTime, & targetTime
% responseTime = responseTime(responseTime > 0);
% targetTime   = targetTime(targetTime > 0);

%% Shutdown Procedures
ShowCursor;
clear screen;
myTotalSecs=GetSecs;
Experiment_duration = myTotalSecs - experimentStartTime;

%% Save a mat Log file
% Onsets & durations are saved in seconds.
save(['logFileFull_',SubjName,'.mat']);
save(['logFile_',SubjName,'.mat'], 'names','onsets','durations','ends','targets','responseTime','responseKey','targetTime','Experiment_duration','playTime');


%% FUNCTION
% close Serial Port ----  VERY IMPORTANT NOT FORGET
if strcmp(device,'Scanner')
    CloseSerialPort(SerPor);
end

catch
    clear Screen;
    fprintf('Code was catched!')
    %% Close serial port of the scanner IF CRASH OF THE CODE
    if strcmp(Cfg.device,'Scanner')
        CloseSerialPort(Cfg.SerPor);
    end
    
end
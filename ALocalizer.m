
eventOnsets=zeros(numBlocks,numEventsPerBlock);
eventEnds=zeros(numBlocks,numEventsPerBlock);
eventDurations=zeros(numBlocks,numEventsPerBlock);

responsesPerBlock=zeros(numBlocks,1);6

playTime = zeros(numBlocks,1);

for blocks = 1:numBlocks

    for iEvent = 1: numEventsPerBlock


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

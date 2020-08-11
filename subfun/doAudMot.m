function [onset, duration] = doAudMot(cfg, thisEvent)
    
    % Play the auditopry stimulation of moving in 4 directions or static noise bursts
    %
    % DIRECTIONS
    %  0=Right; 90=Up; 180=Left; 270=down; -1 static
    %
    % Input:
    %   - cfg: PTB/machine configurations returned by setParameters and initPTB
    %   - expParameters: parameters returned by setParameters
    %   - thisEvent: structure that the parameters regarding the event to present
    %
    % Output:
    %     -
    %
    
    %% Get parameters
    
    sound = [];
    
    direction = thisEvent.direction(1);
    isTarget = thisEvent.target(1);
    targetDuration = cfg.target.duration;
    
    soundData = cfg.soundData;
    
    % if isTarget == 0
    
    if direction == -1
        sound = soundData.S;
    elseif direction == 90
        sound = soundData.U;
    elseif direction == 270
        sound = soundData.D;
    elseif direction == 0
        sound = soundData.R;
    elseif direction == 180
        sound = soundData.L;
    end
    
    % elseif isTarget == 1
    %
    %   if direction == -1
    %     sound = soundData.S_T;
    %   elseif direction == 90
    %     sound = soundData.U_T;
    %   elseif direction == 270
    %     sound = soundData.D_T;
    %   elseif direction == 0
    %     sound = soundData.R_T;
    %   elseif direction == 180
    %     sound = soundData.L_T;
    %   end
    %
    % end
    
    % Start the sound presentation
    PsychPortAudio('FillBuffer', cfg.audio.pahandle, sound);
    PsychPortAudio('Start', cfg.audio.pahandle);
    onset = GetSecs;
    
    % draw first fixation and get a first visual time stamp
    % ideally we would want to synch that first time stamp and the sound start
    thisFixation.fixation = cfg.fixation;
    thisFixation.screen = cfg.screen;
    if isTarget == 1
        thisFixation.fixation.color = cfg.fixation.colorTarget;
    end
    drawFixation(thisFixation);
    vbl = Screen('Flip', cfg.screen.win);
    
    while 1
        
        % set default cross cross color but update if target time is not
        % finished
        thisFixation.fixation.color = cfg.fixation.color;
        if GetSecs < (onset + targetDuration) && isTarget == 1
            thisFixation.fixation.color = cfg.fixation.colorTarget;
        end
        
        drawFixation(thisFixation);
        vbl = Screen('Flip', cfg.screen.win, vbl + cfg.screen.ifi);
        
        status = PsychPortAudio('GetStatus', cfg.audio.pahandle);
        if ~status.Active
            break;
        end
        
    end
    
    % Get the end time
    waitForEndOfPlayback = 1; % hard coding that will need to be moved out
    [onset, ~, ~, estStopTime] = PsychPortAudio('Stop', cfg.audio.pahandle, ...
        waitForEndOfPlayback);
    
    duration = estStopTime - onset;

function [onset, duration] = doAudMot(cfg, expParameters, thisEvent)

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

sound=[];

direction = thisEvent.direction(1);
isTarget = thisEvent.target(1);



if isTarget == 0

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

elseif isTarget == 1

  if direction == -1
    sound = soundData.S_T;
  elseif direction == 90
    sound = soundData.U_T;
  elseif direction == 270
    sound = soundData.D_T;
  elseif direction == 0
    sound = soundData.R_T;
  elseif sdirection == 180
    sound = soundData.L_T;
  end

end

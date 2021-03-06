function equateRmsWav(subjName)
    % function equateRmsWav(subjName)
    % Not used during the experiment itself but allows to root mean square the sounds of a given
    % subject.
    if nargin < 1
        subjName = input('Enter Subjects name: ', 's');
    end

    referenceDir = fullfile(pwd, 'Static');
    subjectDir = fullfile(pwd, ['Motion/sub-', subjName]);

    % reference folder (Static)
    cd(referenceDir);
    referenceWavFn = fullfile(pwd, 'Static.wav');

    % Subject motion folder
    cd(subjectDir);

    targetWavFn = ['sub-', subjName, '_LRL.wav'];
    runFunction(referenceWavFn, targetWavFn);

    targetWavFn = [subjName, '_RLR.wav'];
    runFunction(referenceWavFn, targetWavFn);

    % Targets
    cd(referenceDir);
    referenceWavFn = fullfile(pwd, 'Static_T.wav');

    cd(subjectDir);

    targetWavFn = [subjName, '_LRL_T.wav'];
    runFunction(referenceWavFn, targetWavFn);

    targetWavFn = [subjName, '_RLR_T.wav'];
    runFunction(referenceWavFn, targetWavFn);

end

function runFunction (referenceWavFn, targetWavFn)
    % This Script takes a file (targetWavFn) and equates its rms with
    % another reference audio file (referenceWavFn) amd gives the equated
    % wav file as an output ('final_wave.wav')

    % Get the rms of the original sound
    [referenceWav, referenceFs] = audioread(referenceWavFn);
    referenceRMS = rms(referenceWav);
    disp('rms of the reference wav file');
    disp(referenceRMS);

    % Get the rms for the edited combined sound (static)
    [targetWav, ~] = audioread(targetWavFn);
    targetRms = rms(targetWav);
    disp('rms of the target wav file');
    disp(targetRms);

    % correct for the rms differences in each channel
    finalWav = [targetWav(:, 1) * (referenceRMS(1) / targetRms(1)) ...
                targetWav(:, 2) * (referenceRMS(2) / targetRms(2))];

    % check that the rms of the final is similar to the original
    finalRms = rms(finalWav);
    disp('rms of the final wav file');
    disp(finalRms);

    audiowrite([targetWavFn(1:end - 4), '_rms.wav'], finalWav, eferenceFs);

    %% plot the reference wav and final wav files
    figure();
    subplot(2, 1, 1);
    plot(referenceWav(:, 1), 'r');
    hold on;
    plot(referenceWav(:, 2), 'b');
    title('Reference wav file');

    subplot(2, 1, 2);
    plot(finalWav(:, 1), 'r');
    hold on;
    plot(finalWav(:, 2), 'b');
    title('Final wav file');

end

function mfccVec = extractMFCCs(audioData,fs)
    
    numCoeffs = 13;
    
    % Pre-Emphasis Filter
    B = [1 -0.95];
    audioData = filter(B,1,audioData);
    
    % Windowing and Extracting MFCCs
    windowSize = 0.02*fs;      % 20 ms window
    overlap = 0.5*windowSize;  % 50% overlap
    window = hamming(windowSize,'periodic');
    [mfccs,deltaMfccs,delta2Mfccs] = mfcc(audioData,fs,'LogEnergy',     ...
    'Replace','Window',window,'OverlapLength',overlap,'NumCoeffs',numCoeffs);
    
    % Combining all vectors
    mfccVec = horzcat(mfccs,deltaMfccs);
    mfccVec = horzcat(mfccVec,delta2Mfccs);
    mfccVec = mfccVec';

end
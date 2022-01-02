function mfccCodebooks = trainingVQ(digit,numCentroids)
    
    currentDir = pwd;
    userDir = strcat(currentDir,'/open-set data'); 
    files = dir(fullfile(userDir,'*.wav')); % gets all wav files
    
    speaker = "";
    numSpeaker = 0;
    numSample = 0;

    for file = 1:length(files)   
        fileName = string(files(file).name);
        fileName = erase(fileName,'.wav');
        k = split(fileName,'_');
        [currentDigit,currentSpeaker,currentSample] = k{:};

        if (str2double(currentDigit) ~= digit)
            continue
        end
        if (~strcmp(speaker,currentSpeaker) &                           ... 
            (numSample == str2double(currentSample)))
            speaker = currentSpeaker;
            cd(userDir);
            [audioData,fs] = audioread(fileName+'.wav');
            cd(currentDir);
            numSpeaker = numSpeaker + 1;
            mfccVec = extractMFCCs(audioData,fs);
            mfccCodebooks(numSpeaker,:,:) = LBG(mfccVec,numCentroids);
            
        end
    end
    cd(currentDir)  
    
end
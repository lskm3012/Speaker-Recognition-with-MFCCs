function numCorrect = testingVQ(digit,numSample,codebooks,numSpeakers)

    currentDir = pwd;
    userDir = strcat(currentDir,'/closed-set data'); 
    files = dir(fullfile(userDir,'*.wav')); % gets all wav files

    speaker = '';
    presentSpeaker = 0;
    numCorrect = zeros(1,numSpeakers);
    
    for file = 1:length(files)
    
        fileName = string(files(file).name);
        fileName = erase(fileName,'.wav');
        k = split(fileName,'_');
        [currentDigit,currentSpeaker,currentSample] = k{:};

        if (str2double(currentDigit) ~= digit)
            continue
        end
        if (~strcmp(speaker,currentSpeaker) &                               ... 
            (numSample == str2double(currentSample)))
            presentSpeaker = presentSpeaker + 1;
            cd(userDir);
            [audioData,fs] = audioread(fileName+'.wav');
            cd(currentDir);
            speaker = currentSpeaker;
            mfccVec = extractMFCCs(audioData,fs);
            numSpeaker = 0;
            minDistortion = 100000;
            for i = (1:size(codebooks,1))
                distance = euclideanDistance(mfccVec,squeeze(codebooks(i,:,:)));
                distortion = sum(min(distance,[],2))/(size(distance,1));
                if (distortion < minDistortion)
                    numSpeaker = i;
                    minDistortion = distortion;          
                end
            end
            
%             disp(['Speaker ',num2str(numSpeakers),                      ... 
%                 ' in test matches with Speaker ',                       ...
%                 num2str(numSpeaker), ' in train.'])
            if (presentSpeaker == numSpeaker)
                numCorrect(presentSpeaker) = 1;
            end
        end
        
    end
    
end
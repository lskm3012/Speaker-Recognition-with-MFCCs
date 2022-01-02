function answerMat = testingVQ(digit,numSample,codebooks,distortionTH)

    currentDir = pwd;
    userDir = strcat(currentDir,'/open-set data'); 
    files = dir(fullfile(userDir,'*.wav')); % gets all wav files

    speaker = '';
    presentSpeaker = 0;

    if (numSample > 10)
        isImpostor = true;
    else
        isImpostor = false;
    end
    
    TP = 0; TN = 0; FP = 0; FN = 0;

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
            
            % SET DISTORTION THRESHOLD
            if (minDistortion > distortionTH)
                numSpeaker = 0;
            end
            
%             disp(['Speaker ',num2str(numSpeakers),                      ... 
%                 ' in test matches with Speaker ',                       ...
%                 num2str(numSpeaker), ' in train.'])

            if (~isImpostor & (numSpeaker ~= 0))
                TP = TP + 1;
            elseif (isImpostor & (numSpeaker == 0))
                TN = TN + 1;
            elseif (isImpostor & (numSpeaker ~= 0))
                FP = FP + 1;
            elseif (~isImpostor & (numSpeaker == 0))
                FN = FN + 1;
            end
        end
    end
    answerMat = [TP,TN,FP,FN];
    
end
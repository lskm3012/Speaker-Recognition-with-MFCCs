% RUN THIS TO TRAIN AND TEST THE CLOSED-SET MODEL

clc; clear; close all; format short;

numTestSamples = 20;
numSpeakers = 6;
numCorrect = zeros(numTestSamples,10,numSpeakers);
numCentroids = 16;
digitCodebooks = zeros(10,numSpeakers,39,numCentroids);

currentDir = pwd;
userDir = strcat(currentDir,'/closed-set data'); 
files = dir(fullfile(userDir,'*.wav')); % gets all wav files

for digit = 0:9
    digitCodebooks(digit+1,:,:,:) = trainingVQ(digit,numCentroids);
end

for sample = 1:numTestSamples
    for digit = 0:9        
        numCorrect(sample,digit+1,:) = testingVQ(digit,sample,          ...
        squeeze(digitCodebooks(digit+1,:,:,:)),numSpeakers);
    end
end

percentCorrect = 100*squeeze(sum(numCorrect)/numTestSamples);
percentCorrect = round(percentCorrect,1);

% Plotting a matrix of speaker-digit accuracies
figure
im = imagesc([1 6],[0 9],percentCorrect);
im.AlphaData = .7;
title('Speaker-Digit Model Accuracies','fontsize',20)
xlabel('Speaker #', 'fontsize',16)
ylabel('Digit Model','fontsize',16)
for a = 1:size(percentCorrect,1)
    for b = 1:size(percentCorrect,2)
        text(b-0.25,a-1,[num2str(percentCorrect(a,b)),' %']);
    end
end

accuracies = sum(percentCorrect')/numSpeakers;

% Plotting a bar graph of accuracies based on digit
figure 
bar(0:9,accuracies)
title('Test Accuracies of the 10 Digits','fontsize',20)
xlabel('Digit Model','fontsize',16)
ylabel('Accuracy (%)','fontsize',16)
ylim([80,100])

disp(['The average accuracy of the closed-set model is ',               ...
    num2str(mean(accuracies)),' %'])

% RUN THIS TO TRAIN AND TEST THE OPEN_SET MODEL
% Samples 11-20 are impostors

clc; clear; close all; format short;

numTestSamples = 20;
numSpeakers = 6; numImpostors = 6;
numCentroids = 16;
digitCodebooks = zeros(10,numSpeakers,39,numCentroids);

currentDir = pwd;
userDir = strcat(currentDir,'/open-set data'); 
files = dir(fullfile(userDir,'*.wav')); % gets all wav files

for digit = 0:9
    digitCodebooks(digit+1,:,:,:) = trainingVQ(digit,numCentroids);
end

distTH = 2:0.05:3;
TParr = zeros(1,length(distTH)); FParr = TParr;
TNarr = TParr; FNarr = TParr;

answerMat = zeros(1,5);

for idx = 1:length(distTH)
    disp(idx)
    for sample = 1:numTestSamples
        for digit = 0:9  
            answerMat = testingVQ(digit,sample,                         ...
            squeeze(digitCodebooks(digit+1,:,:,:)),distTH(idx));
            TParr(idx) = TParr(idx) + answerMat(1);
            TNarr(idx) = TNarr(idx) + answerMat(2);
            FParr(idx) = FParr(idx) + answerMat(3);
            FNarr(idx) = FNarr(idx) + answerMat(4);
        end
    end
end

FPR = 100*FParr/(numImpostors*10*numTestSamples/2);
FRR = 100*FNarr/(numSpeakers*10*numTestSamples/2);

% DET CURVE
x = [0 40]; y = [0 40];
[xi,yi] = polyxpoly(x,y,FPR,FRR);
mapshow(FPR,FRR,'LineWidth',3,'color','b')
mapshow(x,y,'Marker','.')
mapshow(xi,yi,'DisplayType','point','Marker','*')
text(1.1*xi,1.1*yi,'Equal Error Rate','fontsize',12)
title('DET Curve','fontsize',20)
xlabel('False Acceptance Rate (%)','fontsize',16)
ylabel('False Rejection Rate (%)','fontsize',16)
xlim([0 20])
ylim([0 20])

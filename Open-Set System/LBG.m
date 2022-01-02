function codebook = LBG(mfccs,M)
    % The code is based on existing implementation descriptions 

    eps = 0.01;
    codebook = mean(mfccs,2); % initial centroid
    
    distortion = 100000;
    
    for i = 1:log2(M)
        
        % Divide the vector space into two
        codebook = [codebook*(1+eps), codebook*(1-eps)];
        
        while(1)
            distance = euclideanDistance(mfccs,codebook);
            [~,idx] = min(distance,[],2); % argmin - idx of min val per row
            temp = 0;
            
            for j = (1:2^i)
                codebook(:,j) = mean(mfccs(:,find(idx==j)),2);
                tempDistance = euclideanDistance(mfccs(:,find(idx==j)), ...
                    codebook(:,j));
                for k = 1:length(tempDistance)
                    temp = temp + tempDistance(k);
                end
            end
            if ((distortion - temp)/temp < eps)
                break;
            else
                distortion = temp;
            end 
        end
        
%         % Plotting accoustic vectors with 2^i centroids (codewords)
%         if (i == 3)
%             figure
%             dims = [3,6];         % Can be any two different dimensions
%             plot(mfccs(dims(1),:),mfccs(dims(2),:),'bo',                ...
%             'MarkerFaceColor','b','MarkerSize',7)
%             hold on
%             plot(codebook(dims(1),:), codebook(dims(2),:),'s',          ...
%             'MarkerFaceColor','r','MarkerSize',10)
%             xlabel('3rd order MFCC','fontsize',16)
%             ylabel('6th order MFCC','fontsize',16)
%             title(['LBG with ',num2str(2^(i)),' codewords'],'fontsize',20)
%             legend('Accoustic vectors','Stable centroids (codewords)',  ...
%             'fontsize',14)
%             pause(inf)
%         end
        
    end
    
    
end
function distance = euclideanDistance(a,b)
    % The code is based on existing implementation descriptions 
    
    distance = zeros(size(a,2),size(b,2));
    if (size(a,2) < size(b,2))
        for i = (1:size(a,2)) % Loop upto the lesser column num
            squaredDiff = (a(:,i*ones(1,size(b,2))) - b).^2;
            distance(i,:) = (sum(squaredDiff,1)).^0.5;
        end
    else
        for i = (1:size(b,2)) % Loop upto the lesser column num
            squaredDiff = (b(:,i*ones(1,size(a,2))) - a).^2;
            distance(:,i) = (sum(squaredDiff,1)).^0.5;
        end
    end
    
end
%% RANSAC function
%   P : probability that wew want to achieve
%   p : probability of outliers
%   n : random n samples
%   k : number of trials
function maxMatch = ransac(match, pos1, orient1, desc1, pos2, orient2, desc2)
	p = 0.5;
	n = 2;
	P = 0.9999;
    k = ceil(log(1-P)/log(1-p^n));
    threshold = 10;	% FIXME
    
    N = size(match, 1);

    maxMatch = [];
    if N <= n
        maxMatch = match;
	return;
    end

    % run k times
    for trial = 1:k
        % draw n samples randomly
        rp = randperm(N);     % shuffle the N number
        sampleIdx = rp(1:n);  % pick the first n numbers --> 

        sampleMatch = match(sampleIdx, :);
        otherMatch = match;
        otherMatch(sampleIdx, :) = [];

        %sampleDesc1 = desc1(sampleMatch(:,1), :);
        %sampleDesc2 = desc2(sampleMatch(:,2), :);
        %othersDesc1 = desc1(otherMatch(:,1), :);
        %othersDesc2 = desc2(otherMatch(:,2), :);
        samplePos1 = pos1(sampleMatch(:,1), :);
        samplePos2 = pos2(sampleMatch(:,2), :);
        othersPos1 = pos1(otherMatch(:,1), :);
        othersPos2 = pos2(otherMatch(:,2), :);

        % fit parameters theta with these n samples
        tmpMatch = [];
        posDiff = samplePos1 - samplePos2;
        theta = mean(posDiff);

        %   for each of other N-n points, calcuate 
        %   its distance to the fitted model, count the
        %   number of inliner points, c
        for i = 1:size(othersPos1, 1)
    	    d = (othersPos1(i,:)-othersPos2(i,:)) - theta;
    	    if sqrt(sum(d.^2)) < threshold
                tmpMatch = [tmpMatch; otherMatch(i, :)];
            end
        end
        if size(tmpMatch, 1) > size(maxMatch, 1)
            maxMatch = tmpMatch;
        end
    end
    % output theta with the largest c
end


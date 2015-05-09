%% RANSAC function
% pick 2 points --> we can solve a translation transform matrix --> apply
% to all points --> check error (by minus? or points by points?) --> get
% the best set of inliers --> use them to solve matrix AGAIN!
%   P : probability that we want to achieve
%   p : probability of inliers
%   n : random n samples
%   k : number of trials
function inlier_trans = ransac(pos1, pos2, img_r, img_l) % (feature_right, feature_left)
	p = 0.15; % guess
	n = 2;
	P = 0.999999999999;
    k = ceil(log(1-P)/log(1-p^n)); % run k times
    % threshold = 15.125;	% !!!!!!!FIXME!!!!!!!!! lib_out
    threshold = 2.21;
    N = size(pos1,1); % number of matched feature points
    
    best_set_num_array = [];
    best_num_of_inliers = 0;
    
    mind = 999999;
    
    for iteration = 1:k
        shuffle_perm = randperm(N);
        sample_id = shuffle_perm(1:n); % extract n random point index
        sample_pos1 = zeros(n,2);
        sample_pos2 = zeros(n,2);
        
        for num = 1:n
            sample_pos1(num, :) = pos1(sample_id(num), :);
            sample_pos2(num, :) = pos2(sample_id(num), :);
            % display_features(img_l, sample_pos2());
            % diaplay_features(img_r, sample_pos1());
        end
        sample_trans = least_squares_pairwise_alignment_translation_only(sample_pos1,sample_pos2); % (feature_right, feature_left)

        % apply the trans to ALL points, count distance to points in pos2
        inlier_num_array = [];
        inlier_num_count = 0;
        
        sample_flag = 1;
        for s = 1:N
            for t = 1:n
                if s == sample_id(t);
                    sample_flag = 0;
                    break;
                end
            end
            if sample_flag == 1
                match_pos = [pos1(s,1)+sample_trans(1,3) pos1(s,2)+sample_trans(2,3)]; % transform to another image point
                % distance = ((match_pos(1,1)-pos2(s,1))^2 + (match_pos(1,2)-pos2(s,2))^2)^(0.5);
                dist = distance(match_pos, pos2(s,:));
                % disp(dist);
                if dist < mind
                    mind = dist;
                end
                if dist < threshold
                    inlier_num_count = inlier_num_count + 1;
                    inlier_num_array(inlier_num_count) = s; % store the inlier number in pos
                end
            end
            sample_flag = 1;
        end
        
        disp(['Iteration ' num2str(iteration) ' number of inliers = ' num2str(inlier_num_count) ' min distance = ' num2str(mind)]);
        
        if inlier_num_count > best_num_of_inliers
            best_num_of_inliers = inlier_num_count;
            best_set_num_array = inlier_num_array;
        end
        
    end 
    
    % found a good set of inliers --> use them to get a even better
    % TRANSFORMATION MATRIX
    inlier_pos1 = pos1(best_set_num_array(:),:);
    inlier_pos2 = pos2(best_set_num_array(:),:);
    inlier_trans = least_squares_pairwise_alignment_translation_only(inlier_pos1, inlier_pos2);
end
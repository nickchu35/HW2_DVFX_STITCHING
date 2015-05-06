%% clear previous records and variables
clear;
clc;
%% Main file for HW2 - Image Stitching
N = 0; % number_of_images
%% Read in photos, if already have cylindrical photos, set make_new_cylindrical to false
%% control flags
make_new_cylindrical = false;
run_feature_detection_to_matching = false;
blend_1_by_1_and_show_result = true; % true will show blended result of every "2" images 
%%
cylin_img = {};
if make_new_cylindrical
    cylin_img = make_new_cylindrical_photos();
else
    disp('Reading in preprocessed cylindrical photos...');
    dirName = 'cylin_photos';
    file = dir([dirName '/' '*.bmp']); % don't use jpg
    tic;
    for k = 1 : size(file,1)
        cylin_img{k}= imread([dirName '/' file(k).name]);
    end
    disp('Reading cylindrical photos finished...');
    toc;
end
N = size(cylin_img, 2);
%% Feature Detection and Feature Descriptor
if run_feature_detection_to_matching
    disp('Running Harris Corner Detection and SIFT Descriptor...');
    tic;
    for i = 1 : N
        %% Harris Corner Detection
        corner_bin_im = zeros(size(cylin_img{i},1),size(cylin_img{i},2));
        [corner_bin_im, feature_points] = harris(cylin_img{i}, 2, 1000, 2, 1); % harris(im, sigma, thresh, radius, disp)
        figure;
        imshow(corner_bin_im);
    
        %disp('number of feature points: '); disp(size(rows,1));
        disp('number of feature points: '); disp(size(feature_points,1));
        featureX = feature_points(:,2);
        featureY = feature_points(:,1);
    
        %% remove boundary
        [featureX, featureY] = removeBoundary(cylin_img{i}, featureX, featureY);
        disp('number of feature points after removing boundary: '); disp(numel(featureX));
    
        %% remove low contrast
        [featureX, featureY] = removeLowContrast(cylin_img{i}, featureX, featureY);
        disp('number of feature points after removing low contrast: '); disp(numel(featureX));
    
        %% remove edge
        [featureX, featureY] = removeEdge(cylin_img{i}, featureX, featureY);
        disp('number of feature points after removing edge: '); disp(numel(featureX));
    
        figure, imagesc(cylin_img{i}), axis image, colormap(gray), hold on
        plot(featureX,featureY,'ys'), title('feature points');

        %% SIFT Descriptor
        [pos, orient, desc] = descriptorSIFT(cylin_img{i}, featureX, featureY);
        poss{i} = pos;
        orients{i} = orient;
        descs{i} = desc;
    end
    save('mat/poss.mat', 'poss');
    save('mat/orients.mat', 'orients');
    save('mat/descs.mat', 'descs');
    disp('Harris Corner Detection and SIFT Descriptor done!');
    toc;
    %% Feature Matching
    disp('Running Feature Matching...');
    tic;
    for i = 1 : (N-1)
        match = featureMatching(descs{i}, descs{i+1}, poss{i}, poss{i+1});
        x = match(:,2);
        y = match(:,1);
        figure, imagesc(cylin_img{i}), axis image, colormap(gray), hold on
        plot(y,x,'ys'), title('feature matching');
        matchs{i} = match;
    end
    save('mat/matchs.mat', 'matchs');
    disp('Feature Matching done!');
    toc;
end
disp('Reading in preprocessed feature positions and matches...');
tic;
poss = struct2cell(load('mat/poss.mat'));
orients = struct2cell(load('mat/orients.mat'));
descs = struct2cell(load('mat/descs.mat'));
matchs = struct2cell(load('mat/matchs.mat'));
disp('Reading in preprocessed feature positions and matches FINISHED!');
toc;
%% RANSAC, (use it to get dependable inliers and good transformation matrix)
trans_matrix = {};
blend_result_1_by_1 = {};
for i = 1:N-1  % a trans matrix for every 2 matrix, last is the same one as first
%for i = 1:1  % a trans matrix for every 2 matrix, last is the same one as first
    pos1 = cell2mat(poss{1}(i));
    pos2 = cell2mat(poss{1}(i + 1));
    match = cell2mat(matchs{1}(i));
    matchpos1 = swap_row_col(pos1(match(:,1),:));
    matchpos2 = swap_row_col(pos2(match(:,2),:));
    trans_matrix{i} = ransac(matchpos2,matchpos1, cylin_img{i}, cylin_img{i+1});
    if blend_1_by_1_and_show_result
        blend_result_1_by_1{i} = blend_imgs_translation_only(cylin_img{i}, cylin_img{i+1}, trans_matrix{i},0);
        if i >= 10
            imwrite( blend_result_1_by_1{i}, ['result_photos/1by1_blend_result/1by1_blend_' num2str(i) '.bmp']);
        else
            imwrite( blend_result_1_by_1{i}, ['result_photos/1by1_blend_result/1by1_blend_0' num2str(i) '.bmp']);
        end
    end
%     fi = show_matched_features(cylin_img{i},cylin_img{i+1},swap_row_col(matchpos1),swap_row_col(matchpos2));
%     saveas(fi,['mat/feature_match_' num2str(i) '.jpg']);
%     if i < 10
%         save(['mat/trans_matrix_0' num2str(i) '.mat'], ['trans_matrix{' num2str(i) '}']);
%     else
%         save(['mat/trans_matrix_' num2str(i) '.mat'], ['trans_matrix{' num2str(i) '}']);
%     end
end
if blend_1_by_1_and_show_result
    for i = 1: N-1
        figure;
        imshow(blend_result_1_by_1{i});
    end
end
%% Bundle Adjustment of the matrix
%% Blending(Panoramas)







%% clear previous records and variables
clear;
clc;
%% Main file for HW2 - Image Stitching
N = 0; % number_of_images
%% Read in photos, if already have cylindrical photos, set make_new_cylindrical to false
% control flags
make_new_cylindrical = false;
run_feature_detection_to_matching = true;
cylin_img = {};
if make_new_cylindrical
    cylin_img = make_new_cylindrical_photos();
else
    disp('Reading in preprocessed cylindrical photos...');
    dirName = 'cylin_photos/testbmp';
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
    for i = 1 : 2
        %% Harris Corner Detection
        corner_bin_im = zeros(size(cylin_img{i},1),size(cylin_img{i},2));
        [corner_bin_im, feature_points] = harris(cylin_img{i}, 2, 1000, 2, 1); % harris(im, sigma, thresh, radius, disp)
        figure;
        imshow(corner_bin_im);
    
        %disp('number of feature points: '); disp(size(rows,1));
        disp(sprintf('image %d --> number of feature points: ', i)); disp(size(feature_points,1));
        featureX = feature_points(:,2);
        featureY = feature_points(:,1);
    
        %% remove boundary
        [featureX, featureY] = removeBoundary(cylin_img{i}, featureX, featureY);
        disp(sprintf('image %d --> number of feature points after removing boundary: ', i)); disp(numel(featureX));
    
        %% remove low contrast
        [featureX, featureY] = removeLowContrast(cylin_img{i}, featureX, featureY);
        disp(sprintf('image %d --> number of feature points after removing low contrast: ', i)); disp(numel(featureX));
    
        %% remove edge
        [featureX, featureY] = removeEdge(cylin_img{i}, featureX, featureY);
        disp(sprintf('image %d --> number of feature points after removing edge: ', i)); disp(numel(featureX));
    
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
    for i = 1 : (2-1)
        match = featureMatching(descs{i}, descs{i+1}, poss{i}, poss{i+1});
%         x = match(:,1);
%         y = match(:,2);
%         figure, imagesc(cylin_img{i}), axis image, colormap(gray), hold on
%         plot(poss{i}(x),poss{i}(y),'ys'), title('feature matching');
        matchs{i} = match;
    end
    
%     matchedPoints1 = poss{1}(matchs{1}(1:20, 1));
%     matchedPoints2 = poss{2}(matchs{1}(1:20, 2));
%     image1 = imread('test_photos/prtn_01.jpg');
%     image2 = imread('test_photos/prtn_02.jpg');
%     disp(class(int8(image1)));
%     disp(class(matchedPoints1));
%     figure; ax = axes;
%     disp(class(ax));
%     showMatchedFeatures(int8(image1),int8(image2),matchedPoints1,matchedPoints2,'montage','Parent',ax);
%     title(ax, 'Candidate point matches');
%     legend(ax, 'Matched points 1','Matched points 2');
    show_matched_features(cylin_img{1}, cylin_img{2}, poss{1}, poss{2});
    
    save('mat/matchs.mat', 'matchs');
    disp('Feature Matching done!');
    toc;
else
    disp('Reading in preprocessed feature positions and matches...');
    tic;
    poss = struct2cell(load('mat/poss.mat'));
    orients = struct2cell(load('mat/orients.mat'));
    descs = struct2cell(load('mat/descs.mat'));
    matchs = struct2cell(load('mat/matchs.mat'));
    disp('Reading in preprocessed feature positions and matches FINISHED!');
    toc;    
end
%% RANSAC, (use it to get dependable inliers and good transformation matrix)
trans_matrix = {};
for i = 1:2-1  % a trans matrix for every 2 matrix, last is the same one as first
    pos1 = cell2mat(poss{1}(i));
    pos2 = cell2mat(poss{1}(i + 1));
    match = cell2mat(matchs{1}(i));
    matchpos1 = pos1(match(:,1),:);
    matchpos2 = pos2(match(:,2),:);
    trans_matrix{i} = ransac(matchpos2,matchpos1);
    if i < 10
        save(['mat/trans_matrix_0' num2str(i) '.mat'], ['trans_matrix{' num2str(i) '}']);
    else
        save(['mat/trans_matrix_' num2str(i) '.mat'], ['trans_matrix{' num2str(i) '}']);
    end
end
%% Bundle Adjustment of the matrix

%% Blending(Panoramas)




%% clear previous records and variables
clear;
clc;
%% Main file for HW2 - Image Stitching
N = 0; % number_of_images
%% Read in photos, if already have cylindrical photos, set make_new_cylindrical to false
make_new_cylindrical = false;
cylin_img = {};
if make_new_cylindrical
    cylin_img = make_new_cylindrical_photos();
else
    disp('Reading in preprocessed cylindrical photos...');
    tic;
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
disp('Running Harris Corner Detection and SIFT Descriptor...');
tic;
for i = 1 : 2
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
for i = 1 : (2-1)
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
%% RANSAC, (use it to get dependable inliers and good transformation matrix)
% trans_matrix = {};
% for i = 1:N  % a trans matrix for every 2 matrix, last is the same one as first
%     pos1 = ;
%     pos2 = ;
%     if i == N
%         pos2 = pos ; % first img
%     end
%     trans_matrix{i} = ransac(pos2,pos1);
% end
%% Image Alignment (matching, find transformation matrix)
% if we have N photos, we will get N-1 trans matrix
% trans_matrix = {}
% for i = 1:N-1
%     trans_matrix{i} = least_squares_pairwise_alignment( feature_points1, feature_points2 );
% end
%% Bundle Adjustment of the matrix

%% Blending(Panoramas)




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
    file = dir([dirName '/' '*.jpg']);
    tic;
    for k = 1 : size(file,1) 
        cylin_img{k}= imread([dirName '/' file(k).name]);
    end
    disp('Reading cylindrical photos finished...');
    toc;
end
N = size(cylin_img, 2);
%% Feature Detection
disp('Running Harris Corner Detection and SIFT Descriptor...');
tic;
for i = 1 : 2
    corner_bin_im = zeros(size(cylin_img{i},1),size(cylin_img{i},2));
    [corner_bin_im, feature_points] = harris(cylin_img{i}, 2, 1000, 2, 1); % harris(im, sigma, thresh, radius, disp)
    figure;
    imshow(corner_bin_im);
    %disp('number of feature points: '); disp(size(rows,1));
    disp('number of feature points: '); disp(size(feature_points,1));

    %% Feature Descriptor
    [pos, orient, desc] = descriptorSIFT(cylin_img{i}, feature_points(:,2), feature_points(:,1));
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
   plot(x, y, 'ys');
   matchs{i} = match;
end
save('mat/matchs.mat', 'matchs');

disp('Feature Matching done!');
toc;
%% RANSAC, (use it to get dependable inliers)

%% Image Alignment (matching, find transformation matrix)
% if we have N photos, we will get N-1 trans matrix
trans_matrix = {}
for i = 1:N-1
    trans_matrix{i} = least_squares_pairwise_alignment( feature_points1, feature_points2 );
end

%% Blending(Panoramas)




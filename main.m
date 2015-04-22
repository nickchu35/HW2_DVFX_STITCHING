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
disp('Running Harris Corner Detection...');
tic;
corner_bin_im = zeros(size(cylin_img{1},1),size(cylin_img{1},2));
[corner_bin_im feature_points] = harris(cylin_img{1}, 2, 1000, 2, 1); % harris(im, sigma, thresh, radius, disp)
figure;
imshow(corner_bin_im);
%disp('number of feature points: '); disp(size(rows,1));
disp('number of feature points: '); disp(size(feature_points,1));
disp('Harris Corner Detection done!');
toc;
%% Feature Descriptor

%% Feature Matching

%% RANSAC, (use it to get dependable inliers and good transformation matrix)
trans_matrix = {};
for i = 1:N  % a trans matrix for every 2 matrix, last is the same one as first
    pos1 = ;
    pos2 = ;
    if i == N
        pos2 = pos ; % first img
    end
    trans_matrix{i} = ransac(pos2,pos1);
end

%% Image Alignment (matching, find transformation matrix)
% if we have N photos, we will get N-1 trans matrix
% trans_matrix = {}
% for i = 1:N-1
%     trans_matrix{i} = least_squares_pairwise_alignment( feature_points1, feature_points2 );
% end
%% Blending(Panoramas)




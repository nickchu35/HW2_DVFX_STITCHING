%% clear previous records and variables
clear;
clc;
%% Main file for HW2 - image stitching
%% Read in photos
dirName = 'test_photos';
file = dir([dirName '/' '*.JPG']);
img = {};
disp('Reading images...');
tic;
for k = 1 : size(file,1) 
    img{k}= imread([dirName '/' file(k).name]);
end
disp(['Reading images finished... ' int2str(size(file,1)) ' images found.']);
toc;
%% Feature Detection
disp('Running Harris Corner Detection...');
tic;
corner_bin_im = zeros(size(img{1},1),size(img{1},2));
rows = [];
cols = [];
[corner_bin_im rows cols] = harris(img{1}, 2, 1000, 2, 1); % harris(im, sigma, thresh, radius, disp)
figure;
imshow(corner_bin_im);
disp('rows : '); disp(size(rows,1));
disp('cols : '); disp(size(cols,1));
disp('Harris Corner Detection... Done');
toc;
%% Feature Descriptor
%% Feature Matching
%% Reprojection to cylinder
%% Image Alignment
%% Panoramas
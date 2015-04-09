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
harris(img{1}, 2, 1000, 2, 1) % harris(im, sigma, thresh, radius, disp)
%% Feature Descriptor
%% Image Matching
%% Panoramas
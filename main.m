%% clear previous records and variables
clear;
clc;
%% Main file for HW2 - Image Stitching
%% Read in photos
dirName = 'test_photos';
file = dir([dirName '/' '*.jpg']);
img = {};
disp('Reading images...');
tic;
for k = 1 : size(file,1) 
    img{k}= imread([dirName '/' file(k).name]);
end
disp(['Reading images finished... ' int2str(size(file,1)) ' images found.']);
toc;
%% Reprojection to cylinder for each Image
disp('Cylinder reprojection start......');
tic;
focal_length = get_focal_length(size(file,1));
cylin_img = {};
cylin_path = 'cylin_photos/cylin_';
for k = 1 : size(file,1) 
    cylin_img{k} = cylinder_reproject(img{k}, size(img{k},2), size(img{k},1), focal_length);
    imwrite(cylin_img{k},[cylin_path int2str(k) '.jpg'])
end
disp('Cylinder reprojection finished!');
toc;
%% Feature Detection
disp('Running Harris Corner Detection...');
tic;
corner_bin_im = zeros(size(cylin_img{1},1),size(cylin_img{1},2));
rows = [];
cols = [];
[corner_bin_im rows cols] = harris(cylin_img{1}, 2, 1000, 2, 1); % harris(im, sigma, thresh, radius, disp)
figure;
imshow(corner_bin_im);
disp('rows : '); disp(size(rows,1));
disp('cols : '); disp(size(cols,1));
disp('Harris Corner Detection... Done');
toc;
%% Feature Descriptor
%% Feature Matching
%% Image Alignment (matching, find transformation matrix)
%% Panoramas
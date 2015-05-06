%% Read in original photos and do the reprojection
% return the cell of cylindrical images.
function cylin_img = make_new_cylindrical_photos()
    % dirName = 'test_photos';
    dirName = 'mrt_photos';
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
    focal_length = get_focal_length(size(file,1), [dirName '/pano.txt']);
    cylin_img = {};
    cylin_path = 'cylin_photos/cylin_';
    for k = 1 : size(file,1)
        cylin_img{k} = cylinder_reproject(img{k}, size(img{k},2), size(img{k},1), focal_length);
        if k < 10
            imwrite(cylin_img{k},[cylin_path '0' int2str(k) '.bmp']) % don't use jpg!!
        else
            imwrite(cylin_img{k},[cylin_path int2str(k) '.bmp']) % don't use jpg!!
        end
    end
    disp('Cylinder reprojection finished!');
    toc;
end
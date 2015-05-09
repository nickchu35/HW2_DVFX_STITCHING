% dirName = 'lib_out_photos';
dirName = '.';
file = dir([dirName '/' '*.jpg']); % don't use jpg
name = 'lib_40_';
for k = 1 : size(file,1)
    cylin_img{k} = imresize(imread([dirName '/' file(k).name]), 0.125);
    if k < 10
        imwrite(cylin_img{k},[dirName '/' name '0' num2str(k) '.jpg']);
    else
        imwrite(cylin_img{k},[dirName '/' name num2str(k) '.jpg']);
    end
end

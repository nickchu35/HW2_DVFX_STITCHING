dirName = 'lib_out_photos';
file = dir([dirName '/' '*.jpg']); % don't use jpg
for k = 1 : size(file,1)
    cylin_img{k} = imresize(imread([dirName '/' file(k).name]),0.5);
    if k < 10
        imwrite(cylin_img{k},['lib_out_photos/lib_0' num2str(k) '.jpg']);
    else
        imwrite(cylin_img{k},['lib_out_photos/lib_' num2str(k) '.jpg']);
    end
end

function result = rotation_test(im, trans_matrix);
    tx = round(trans_matrix(1,3));
    ty = round(trans_matrix(2,3));
    result = zeros(size(im,1), size(im,2), 3, 'uint8');
    for i = 1:size(im,1)
        for j = 1:size(im,2)
            if i + tx >= 1 && i + tx <= size(im,1) && j + ty <= size(im,2) && j + ty >= 1
                result(i + tx, j + ty, :) = im(i,j,:);
            end
        end 
    end
end
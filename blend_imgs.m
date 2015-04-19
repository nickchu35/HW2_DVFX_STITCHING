%% Blending funciton
% our matrix includes - c, s, tx, ty (rotation and translation)
function blended_result = blend_imgs(im1, im2, trans_matrix)
    c = trans_matrix(1,1);
    s = trans_matrix(2,1);
    tx = trans_matrix(1,3);
    ty = trans_matrix(2,3);
    result = zeros(size(im,1)*c + size(im,2)*s + abs(ty), size(im,1)*s + size(im,2)*c + abs(tx));
    
end
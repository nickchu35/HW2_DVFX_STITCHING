%% Blending funciton
% our matrix includes - tx, ty (translation)
% blending from right to the left!
function [blended_result i_shift] = blend_imgs_translation_only(im_l, im_r, trans_matrix, shift)
    tx = round(trans_matrix(1,3)); % tx is actually in the downward direction
    ty = round(trans_matrix(2,3)); % ty is actually in the rightward direction
    result = zeros(size(im_l,1) + abs(tx), size(im_l,2) + abs(ty), 3, 'uint8');
    i_add = 0;
    if tx < 0
        i_add = abs(tx);
    end
    i_add = i_add + shift;
    for i = 1:size(im_l,1) 
        for j = 1:size(im_l,2)
            if i + i_add > 0
                if result(i + i_add, j, :) == 0;
                    result(i + i_add, j, :) = im_l(i,j,:);
                else
                    result(i + i_add, j, :) = (im_l(i,j,:) + result(i + i_add, j, :))/2;
                end
            end
            if i + tx > 0 && j + ty > 0
                if result(i + tx, j + ty, :) == 0
                    result(i + tx, j + ty, :) = im_r(i,j,:);
                else
                    result(i + tx, j + ty, :) = (im_r(i,j,:) + result(i + tx, j + ty, :))/2;
                end
            end
        end
    end
    blended_result = result;
    i_shift = i_add;
end
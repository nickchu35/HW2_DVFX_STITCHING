%% Blending funciton
% our matrix includes - tx, ty (translation)
% blending from right to the left!
% use a simple fun to blend
function [blended_result i_shift] = blend_imgs_translation_only(im_l, im_r, trans_matrix, shift)
    tx = round(trans_matrix(1,3)); % tx is actually in the downward direction
    ty = round(trans_matrix(2,3)); % ty is actually in the rightward direction
    result = zeros(size(im_l,1) + abs(tx), size(im_l,2) + abs(ty), 3, 'uint8');
    i_add = 0;
    if tx < 0
        i_add = abs(tx);
        center2 = [size(im_l,1)/2 size(im_l,2)/2+abs(ty)];
    else
        center2 = [size(im_l,1)/2+tx size(im_l,2)/2+abs(ty)];
    end
    i_add = i_add + shift;
    center1 = [size(im_l,1)/2+i_add size(im_l,2)/2];
    for i = 1:size(im_l,1) 
        for j = 1:size(im_l,2)
            if i + i_add > 0
                if result(i + i_add, j, :) == 0;
                    result(i + i_add, j, :) = im_l(i,j,:);
                else % need to make sure the point is not zero!!!!!!!!!!!!!!!
                    % use distance to 2 center
                    d1 = distance([i+i_add j], center1);
                    d2 = distance([i+i_add j], center2);
                    % use x coordinate only
%                     d1 = j - abs(ty);
%                     d2 = size(im_l,2) - j;
                    temp = result(i + i_add, j, :);
                    if im_l(i,j,:)== 0
                        d1 = 0;
                    end
                    result(i + i_add, j, :) = im_l(i,j,:)*(d1/(d1+d2)) + temp*(d2/(d1+d2));
                end
            end
            if i + tx > 0 && j + ty > 0
                if result(i + tx, j + ty, :) == 0
                    result(i + tx, j + ty, :) = im_r(i,j,:);
                else % need to make sure the point is not zero!!!!!!!!!!!!!!!
                    % use distance to 2 center
                    d1 = distance([i+tx j+ty], center1);
                    d2 = distance([i+tx j+ty], center2);
                    % use x coordinate only
%                     d1 = j + ty - abs(ty);
%                     d2 = size(im_l,2) - j - ty;
                    temp = result(i + tx, j + ty, :);
                    if im_r(i,j,:) == 0
                        d2 = 0;
                    end
                    result(i + tx, j + ty, :) = im_r(i,j,:)*(d2/(d1+d2)) + temp*(d1/(d1+d2));
                end
            end
        end
    end
    blended_result = result;
    i_shift = i_add;
    % after first blending finished, run poisson blending
    
    
    
    
end
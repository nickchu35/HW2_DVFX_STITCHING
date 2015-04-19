%% Blending funciton
% our matrix includes - c, s, tx, ty (rotation and translation)
% blending from right to the left!
function blended_result = blend_imgs(im_l, im_r, trans_matrix);
    c = trans_matrix(1,1);  % cos(theta)
    s = trans_matrix(2,1);  % sin(theta)
    tx = trans_matrix(1,3); % tx is actually in the downward direction
    ty = trans_matrix(2,3); % ty is actually in the rightward direction
    h_add = size(im_r,2)*c + abs(size(im_r,1)*s) - size(im_r,1); % the height addition because of rotation, if ty = 0, then the left image's y center = whole image's y center
    % w_add = abs(size(im_r,2)*s) + size(im_r,1)*c - size(im_r,2); % the width addition......
    result = zeros(round(size(im_r,1)*c + abs(size(im_r,2)*s) + abs(tx)), round(abs(size(im_r,1)*s) + size(im_r,2)*c + abs(ty)), 3, 'uint8');
    for i = 1:size(im_l,1)
        for j = 1:size(im_l,2)
            % put in im_l pixels
            if round(i + h_add/2 + tx) <= 0
            elseif result(round(i + h_add/2 + tx), j, :) == 0
                result(round(i + h_add/2 + tx), j, :) = im_l(i,j,:);
            else
                result(round(i + h_add/2 + tx), j, :) = (im_l(i,j,:) + result(round(i + h_add/2 + tx), j, :)) / 2; % simple average
            end
            % put in im_r pixels
            if round(i*c - j*s + tx + h_add/2) <= 0 || round(i*s + j*c + ty) <=0
            elseif result(round(i*c - j*s + tx + h_add/2), round(i*s + j*c + ty), :) == 0
                result(round(i*c - j*s + tx + h_add/2), round(i*s + j*c + ty), :) = im_r(i,j, :);
            else
                result(round(i*c - j*s + tx + h_add/2), round(i*s + j*c + ty), :) = im_r(i,j, :) + result(round(i*c - j*s + tx + h_add/2), round(i*s + j*c + ty), :);
                result(round(i*c - j*s + tx + h_add/2), round(i*s + j*c + ty), :) = result(round(i*c - j*s + tx + h_add/2), round(i*s + j*c + ty), :)/2;
            end
        end
    end
    blended_result = result;
end
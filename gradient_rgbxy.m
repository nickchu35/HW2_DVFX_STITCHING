%% Gradient funciton
% the gradient is to the right and down.
function [gx_r gy_r gx_g gy_g gx_b gy_b] = gradient_rgbxy(img)
    gray_r = img(:,:,1);
    gray_g = img(:,:,2);
    gray_b = img(:,:,3);
    
    dx = [-1 0 1; -1 0 1; -1 0 1]; % masks
    dy = dx';
    
    gx_r = conv2(gray_r, dx, 'same');
    gy_r = conv2(gray_r, dy, 'same');
    gx_g = conv2(gray_g, dx, 'same');
    gy_g = conv2(gray_g, dy, 'same');
    gx_b = conv2(gray_b, dx, 'same');
    gy_b = conv2(gray_b, dy, 'same');
end
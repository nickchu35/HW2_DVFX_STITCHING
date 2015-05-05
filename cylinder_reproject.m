%% reproject a img to cylindrical coordinates
function temp_img = cylinder_reproject(im, x_size, y_size, f)
    new_x_size = ceil(2 * f * atan(x_size/(2*f)));
    new_y_size = y_size;
    temp_img = zeros(new_y_size, new_x_size, 3, 'uint8'); % x_size is for number 2, problem... f is NaN
    
    for i = 1 : y_size
        for j = 1 : x_size
            x = j - x_size/2; % transform to center of image = (0,0)
            y = i - y_size/2;
            new_x = f * atan(x/f);
            new_y = f * (y/((x^2 + f^2)^0.5));
            if round(new_y + new_y_size/2) > 0 && round(new_x + new_x_size/2) > 0
                temp_img(round(new_y + new_y_size/2), round(new_x + new_x_size/2), :) = im(i,j,:);
            end
        end
    end
    
end
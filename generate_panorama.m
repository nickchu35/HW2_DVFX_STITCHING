%% read in all trans matrices and cylin photos to generate panorama
function panorama = generate_panorama( cylin_img, trans, N)
    tx_sum = {};
    tx_max = 0;
    tx_min = 0;
    ty_sum = {};
    row = size(cylin_img{1},1);
    col = size(cylin_img{1},2);
    center = {};
    
    for i = 1 : N-1
        if i == 1
            tx_sum{i} = round(trans{i}(1,3)); % tx is actually in the downward direction
            ty_sum{i} = round(trans{i}(2,3)); % ty is actually in the rightward direction
        else
            tx_sum{i} = tx_sum{i-1} + round(trans{i}(1,3)); % tx is actually in the downward direction
            ty_sum{i} = ty_sum{i-1} + round(trans{i}(2,3)); % ty is actually in the rightward direction
        end
        if tx_sum{i} < tx_min
            tx_min = tx_sum{i};
        elseif tx_sum{i} > tx_max
            tx_max = tx_sum{i};
        end
    end
    
    for i = 1:N
        if i == 1
            center{i} = [row/2-tx_min col/2];
        else
            center{i} = [row/2-tx_min+tx_sum{i-1}  col/2+ty_sum{i-1}];
        end
    end
    
    result = zeros( row + tx_max - tx_min, col + ty_sum{N-1},3,'uint8');
    disp('Stitching image 1.');
    for i = 1 : row   % put in the first pic
        for j = 1: col
            result(i - tx_min,j,:) = cylin_img{1}(i,j,:);
        end
    end
    for k = 2:N % put in photos one by one
        disp(['Stitching image ' num2str(k) '.']);
        x1 = center{k-1}(1);
        y1 = center{k-1}(2);
        x2 = center{k}(1);
        y2 = center{k}(2);
        for i = 1 : row   % put in the first pic
            for j = 1: col
                if cylin_img{k}(i, j, :) ~= 0
                    if result(x2 - row/2 + i, y2 - col/2 + j, :) == 0
                        result(x2 - row/2 + i, y2 - col/2 + j, :) = cylin_img{k}(i, j, :);
                    else
                        % use distance to 2 center - (1)
%                         d1 = distance([x2-row/2+i y2-col/2+j], center{k-1});
%                         d2 = distance([x2-row/2+i y2-col/2+j], center{k-2});
                        % use x coordinate only - (2)
                        d1 = j;
                        if k ~= 2
                            d2 = col - j - (ty_sum{k-1} - ty_sum{k-2});
                        else
                            d2 = col - j - ty_sum{k-1};
                        end
                        % use the square root of x and y difference -  (3 , has to be used with (2))
%                         if k ~= 2 
%                             if tx_sum{k-1} < tx_sum{k-2}
%                                 d1 = (d1^2 + (row - i)^2)^(0.5);
%                                 d2 = (d2^2 + (i - (tx_sum{k-2} - tx_sum{k-1}))^2)^(0.5);
%                             else
%                                 d1 = (d1^2 + i^2)^(0.5);
%                                 d2 = (d2^2 + (row - i - (tx_sum{k-1} - tx_sum{k-2}))^2)^(0.5);
%                             end
%                         else
%                             if tx_sum{1} < 0
%                                 d1 = (d1^2 + (row - i)^2)^(0.5);
%                                 d2 = (d2^2 + (i + tx_sum{1})^2)^(0.5);
%                             else
%                                 d1 = (d1^2 + i^2)^(0.5);
%                                 d2 = (d2^2 + (row - i - tx_sum{1})^2)^(0.5);
%                             end
%                         end
                        %
                        result(x2 - row/2 + i, y2 - col/2 + j, :) = cylin_img{k}(i, j, :)*(d1/(d1+d2)) + result(x2 - row/2 + i, y2 - col/2 + j, :)*(d2/(d1+d2));
                    end
                end
            end
        end
    end
    panorama = result;
end
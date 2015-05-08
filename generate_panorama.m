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
        % tx_sum{i} % print it out
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
                        % use distance to 2 center
                        d1 = distance([x2-row/2+i y2-col/2+j], center{k});
                        d2 = distance([x2-row/2+i y2-col/2+j], center{k-1});
                        % use x coordinate only
%                     
%                     
                        result(x2 - row/2 + i, y2 - col/2 + j, :) = cylin_img{k}(i, j, :)*(d2/(d1+d2)) + result(x2 - row/2 + i, y2 - col/2 + j, :)*(d1/(d1+d2));
                    end
                end
            end
        end
    end
    panorama = result;
end
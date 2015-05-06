%% to swap a coordinate's rows and cols
function pos_n = swap_row_col( pos)
    pos_n(:,1) = pos(:,2);
    pos_n(:,2) = pos(:,1);
end


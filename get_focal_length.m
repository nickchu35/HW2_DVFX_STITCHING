%% read in the pano.txt ad retrieve the focal length
function focal = get_focal_length(number_of_pics, filename)
    %# read the whole file to a temporary cell array
    %filename = 'test_photos/pano.txt';
    fid = fopen(filename,'rt');
    total_line_num = 13 * number_of_pics;
    line_num = 1;
    temp_f = 0;
    tline = fgetl(fid);
    while line_num <= total_line_num
        if (mod((line_num - 12),13) == 0)
            temp_f = temp_f + str2double(tline);
        end
        tline = fgetl(fid);
        line_num = line_num + 1;
    end
    fclose(fid);
    focal = temp_f/number_of_pics;
end
function match = featureMatching(desc1, desc2, pos1, pos2, filter, img)

    match = [];

    for i = 1:size(desc1, 1)
        dists = [];
        for j = 1:size(desc2, 1)
            disp(class(cell2mat(pos1(i))));
            [x1,y1] = cell2mat(pos1(i));
            [x2,y2] = cell2mat(pos2(j));
            if (x1 > filter) && (x2 < filter)
                dists = [dists; descriptorDistance(desc1(i,:), desc2(j,:))];
            else
                dists = [dists; 10000];
            end
            dists = [dists; descriptorDistance(desc1(i,:), desc2(j,:))];
        end
        [min1 min1_idx] = min(dists);
        dists(min1_idx) = [];
        min2 = min(dists);
        % 80% peak value
        if (min1/min2) < 0.8
            match = [match; [i min1_idx]];
        end
    end
end

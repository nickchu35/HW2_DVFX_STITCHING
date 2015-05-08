function match = featureMatching(desc1, desc2, pos1, pos2, filter, img)
    width = size(img,2);
    match = [];
    x = [];
    y = [];

    for i = 1:size(desc1, 1)
        dists = [];
        for j = 1:size(desc2, 1)
            x1 = pos1(i,1);
            x2 = pos2(j,1);
            y1 = pos1(i,2);
            if (x1 > (width * (1 - filter))) && (x2 < (width * filter))
                x = [x; x1];
                y = [y; y1];
                dists = [dists; descriptorDistance(desc1(i,:), desc2(j,:))];
            else
                dists = [dists; []];
            end
            % dists = [dists; descriptorDistance(desc1(i,:), desc2(j,:))];
        end
        [min1 min1_idx] = min(dists);
        dists(min1_idx) = [];
        min2 = min(dists);
        % 80% peak value
        if (min1/min2) < 0.8
            match = [match; [i min1_idx]];
        end
    end
    
    figure, imagesc(img), axis image, colormap(gray), hold on
    plot(x,y,'ys'), title('feature points after filtering');
end

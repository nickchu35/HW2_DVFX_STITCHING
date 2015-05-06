function fi = show_matched_features(img1,img2,matchpos1,matchpos2)
    I1 = rgb2gray(img1);
    I2 = rgb2gray(img2);
    fi = figure; ax = axes;
    showMatchedFeatures(I1,I2,matchpos1,matchpos2,'montage');
    title(ax, 'Candidate point matches');
    legend(ax, 'Matched points 1','Matched points 2');
end


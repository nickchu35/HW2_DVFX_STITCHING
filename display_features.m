function display_features( img, pos )
    figure, imagesc(img), axis image, colormap(gray), hold on
    plot(pos(:,2),pos(:,1),'ys'), title('corners detected');
end


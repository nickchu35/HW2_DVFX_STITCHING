%% Distance function
function d = distance(point1, point2)
    d = ((point1(1)-point2(1))^2 + (point1(2)-point2(2))^2)^0.5;
end
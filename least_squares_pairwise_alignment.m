%% To get the transformation matrix (translation + rotation) of the feature points.
% we only need the matched feature points, don't need the images
function trans_matrix = least_squares_pairwise_alignment(feature_points1, feature_points2)
    % put them into the forms of Ax = b
    number_of_features = size(feature_points,1);
    b = zeros(number_of_features * 2, 1); % b vector
    A = zeros(number_of_features * 2, 4); % A matrix
    for i = 1:number_of_features
        A(2*(i-1)+1,:) = [feature_points1(i,1) -feature_points1(i,2) 1 0];
        A(2*(i-1)+2,:) = [feature_points1(i,2) feature_points1(i,1) 0 1];
        b(2*(i-1) + 1,1) = features_points(i,1);
        b(2*(i-1) + 2,1) = features_points(i,2);
    end
    x = A\b;
    c = x(1,1);
    s = x(2,1);
    tx = x(3,1);
    ty = x(4,1);
    trans_matrix = [c -s tx;s c ty;0 0 1];
end
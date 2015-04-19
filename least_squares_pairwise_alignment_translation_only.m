%% To get the transformation matrix (translation + rotation) of the feature points.
% we only need the matched feature points, don't need the images
function trans_matrix = least_squares_pairwise_alignment_translation_only(feature_points1, feature_points2)
    % put them into the forms of Ax = b
    number_of_features = size(feature_points1,1);
    b = zeros(number_of_features * 2 + 1, 1); % b vector
    A = zeros(number_of_features * 2 + 1, 3); % A matrix
    for i = 1:number_of_features
        A(2*(i-1)+1,:) = [1 0 feature_points1(i,1)];
        A(2*(i-1)+2,:) = [0 1 feature_points1(i,2)];
        b(2*(i-1) + 1,1) = feature_points2(i,1);
        b(2*(i-1) + 2,1) = feature_points2(i,2);
    end
    A(2 * number_of_features + 1,3) = 1;
    b(2 * number_of_features + 1,1) = 1;
    x = A\b;
    tx = x(1,1);
    ty = x(2,1);
    trans_matrix = [1 0 tx;0 1 ty];
end
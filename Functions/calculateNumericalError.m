function numericalError = calculateNumericalError(X_test, Y_test, R_list, net)
    
    num_test_cases = length(X_test);
    numericalError = zeros(num_test_cases, 3); % Three columns for x, y, and y_predicted

    for i = 1:num_test_cases
        x = X_test{i};
        y = Y_test{i};
        y_predicted = double(predict(net, x));

        for j = 1:length(R_list)

            r = R_list{j};
            inverse = r';

            % Rotate x, y, and y_predicted
            [rotated_x, rotated_y] = performRotation(x, y, r);
            rotated_x = double(rotated_x);
            [re_rotated_x, re_rotated_y] = performRotation(rotated_x, rotated_y, inverse);
            
            % Rotate y_predicted
            [rotated_x, rotated_y_predicted] = performRotation(x, y_predicted, r);
            [re_rotated_x, re_rotated_y_predicted] = performRotation(rotated_x, rotated_y_predicted, inverse);

            % Compute numerical error for x, y, and y_predicted
            numericalError(i, 1) = max(max(abs(x - re_rotated_x)));
            numericalError(i, 2) = max(max(abs(y - re_rotated_y)));
            numericalError(i, 3) = max(max(abs(y_predicted - re_rotated_y_predicted)));

        end
    end
end




function [median_values, std_values] = calculateMedianError(X_test, Y_test, re_rotated_predictions, R_list)

    median_values = cell(size(X_test));
    std_values = cell(size(X_test));

    for i = 1:length(X_test)
        x = X_test{i};
        y = Y_test{i};
        re_rotated_predictions_cell = re_rotated_predictions{i};

        % Preallocate an array to store all rotated predictions
        all_predictions = zeros([size(re_rotated_predictions_cell{1}), length(R_list)]);
        
        % Collect all predictions for median and std calculation
        for j = 1:length(R_list)
            all_predictions(:, :, j) = re_rotated_predictions_cell{j};
        end

        % Calculate median along the 3rd dimension (across predictions)
        median_values{i} = median(all_predictions, 3);

        % Calculate standard deviation across the 3rd dimension
        std_values{i} = std(all_predictions, 0, 3);
    end
    
end

function [mean_values, std_values] = calculateMeanError(X_test, Y_test, re_rotated_predictions, R_list)

    mean_values = cell(size(X_test));
    std_values = cell(size(X_test));

    for i = 1:length(X_test)
        x = X_test{i};
        y = Y_test{i};
        re_rotated_predictions_cell = re_rotated_predictions{i};

        sum_predictions = zeros(size(re_rotated_predictions_cell{1}));
        sum_squared_predictions = zeros(size(re_rotated_predictions_cell{1}));

        for j = 1:length(R_list)
            re_rotated_prediction = re_rotated_predictions_cell{j};
            sum_predictions = sum_predictions + re_rotated_prediction;
            sum_squared_predictions = sum_squared_predictions + re_rotated_prediction.^2;
        end

        mean_values{i} = sum_predictions / length(R_list);
        std_values{i} = sqrt((sum_squared_predictions - (sum_predictions.^2) / length(R_list)) / (length(R_list) - 1));

    end
    
end

function [mean_MeRE, mean_MaRE, mean_values, error_bars] = calculateMeRE(X_test, Y_test, re_rotated_predictions, R_list)

    num_cells = length(X_test);
    num_rotations = length(R_list);
    MeREs = zeros(num_cells, num_rotations);
    MaREs = zeros(num_cells, num_rotations);
    mean_values = cell(num_rotations, 1);
    error_bars = cell(num_rotations, 1);

    for h = 1:num_rotations

        for i = 1:num_cells
            x = X_test{i};
            y = Y_test{i};
            predictions_cell = re_rotated_predictions{i};
    
            sum_predictions = zeros(size(predictions_cell{1}));
            sum_squared_errors = zeros(size(predictions_cell{1}));
    
            for j = 1:h
                re_rotated_prediction = predictions_cell{j};
                sum_predictions = sum_predictions + re_rotated_prediction;
                sum_squared_errors = sum_squared_errors + (re_rotated_prediction - y).^2;
            end
    
            mean_values{h} = sum_predictions / h;
            std_values = sqrt(sum_squared_errors / (h - 1));
            error_bars{h} = std_values;
    
            vonMisesTarget = calculateVonMisesStress(y);
            vonMisesPrediction = calculateVonMisesStress(mean_values{h});
            absolute_error = abs(vonMisesPrediction - vonMisesTarget);
            MeREs(i, h) = sqrt(mean(absolute_error.^2)) / range(vonMisesTarget);
            MaREs(i, h) = max(absolute_error) / range(vonMisesTarget);
        end
    end
    
    mean_MeRE = mean(MeREs, 1);
    mean_MaRE = mean(MaREs, 1);
end

function [MeRE, MaRE, start_predictions] = startPrediction(net, X_test, Y_test)

    num_samples = length(X_test);
    MeREs = zeros(num_samples, 1);
    MaREs = zeros(num_samples, 1);

    for cellIndex = 1:num_samples
        % Select the specific cell for X_test and Y_test
        X_test_cell = X_test{cellIndex};
        Y_test_cell = Y_test{cellIndex};

        predictions = double(predict(net, X_test_cell));
        
        % Calculate MeRE and MaRE for the current sample
        vonMisesTarget = calculateVonMisesStress(Y_test_cell); % Assuming Y_test_cell contains only one sample
        vonMisesPrediction = calculateVonMisesStress(predictions);

        absolute_error = abs(vonMisesPrediction - vonMisesTarget);
        MeRE = sqrt(mean(absolute_error.^2)) / range(vonMisesTarget);
        MaRE = max(absolute_error) / range(vonMisesTarget);

        % Store MeRE and MaRE for the current sample
        MeREs(cellIndex) = MeRE;
        MaREs(cellIndex) = MaRE;

        start_predictions{cellIndex} = predictions;
    end

    % Calculate mean MeRE and MaRE for the entire dataset
    MeRE = mean(MeREs);
    MaRE = mean(MaREs);

end


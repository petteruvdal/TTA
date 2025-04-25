% Function to perform re-rotation and calculate average MeRE for each rotation
function [meanMeREs] = reRotateFunctionParallel(X_test, Y_test, R_list, net)

    nSamples = length(X_test);
    nRandomRotation = length(R_list);

    % Pre-allocate arrays for rotated inputs and outputs
    newX_test = cell(nSamples * nRandomRotation, 1);
    newY_test = cell(nSamples * nRandomRotation, 1);

    % Generate rotated test data in a single vectorized pass
    for k = 1:nRandomRotation
        r = R_list{k};

        % Rotate all samples in parallel
        for j = 1:nSamples
            idx = nSamples * (k - 1) + j;
            [newX_test{idx}, newY_test{idx}] = performRotation(X_test{j}, Y_test{j}, r);
        end
    end

    % Predict in a vectorized manner
    predictions = predict(net, newX_test);

    % Calculate the von Mises stress for true and predicted values in a vectorized way
    meanMeREs = zeros(1, nRandomRotation); % Store average MeRE for each rotation

    % Calculate MeRE for each rotation across all samples in parallel
    for k = 1:nRandomRotation
        sampleIndices = (k - 1) * nSamples + (1:nSamples); % Indices for current rotation
        y_true_all = newY_test(sampleIndices);
        y_pred_all = predictions(sampleIndices);

        % Calculate von Mises stress and MeRE for each sample with rotation k
        MeREs = arrayfun(@(j) computeMeRE(y_true_all{j}, y_pred_all{j}), 1:nSamples);

        % Average MeRE for current rotation
        meanMeREs(k) = mean(MeREs);
    end
end

% Helper function to calculate MeRE for a single sample
function MeRE = computeMeRE(y_true, y_pred)
    vonMisesTarget = calculateVonMisesStress(y_true);
    vonMisesPrediction = calculateVonMisesStress(y_pred);
    absolute_error = abs(vonMisesPrediction - vonMisesTarget);
    MeRE = sqrt(mean(absolute_error.^2)) / range(vonMisesTarget);
end

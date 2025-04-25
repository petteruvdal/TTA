%% Load data & Settings

clear; clc;

% FineTuned_All, FromScratch_RR_20_best, FromScratch_All

load("RVE_all_data.mat");
load("FineTuned_All.mat");
load("Best_R_list_200_valid_sorted.mat"); 

% For best
R_list = sortedRList;


% SAVING: Define the network name and dataset name
network_name = 'FineTuned_All_Training_200_best'; % Change this to the actual name of your network and R_list
dataset_name = 'TestDataSet';    % Change this to the actual name of your dataset

% Define the number of random rotations
numRotations = 1; % or any desired number

% If you want to iterate up to a specific length of R_list
if numRotations > length(R_list)
    disp('Error: Requested number of rotations exceeds the length of R_list.');
    return;
end

% Initialize R_list with the desired number of rotations
R_list = R_list(1:numRotations);

disp('Re-rotating predictions ...');

 X_test = X_train;
 Y_test = Y_train;
%%
[re_rotated_predictions, re_rotated_inputs] = reRotateFunction(X_test, Y_test, R_list, net);

disp('Calculating mean, and errorbars ...');

[mean_values, std_values] = calculateMeanError(X_test, Y_test, re_rotated_predictions, R_list);

%%

[MeRE, MaRE] = calculateMeRE(X_test, Y_test, re_rotated_predictions, R_list);


%%

[start_MeRE, start_MaRE, start_predictions] = startPrediction(net, X_test, Y_test);

%%

numericalError = calculateNumericalError(X_test, Y_test, R_list, net);

disp('Done');

%%

% Create folder for the network if it doesn't exist
network_folder = ['./Results/', network_name];
if ~exist(network_folder, 'dir')
    mkdir(network_folder);
end

% Save variables with appended names in the network folder
save(fullfile(network_folder, ['mean_values_', network_name, '_', dataset_name, '.mat']), 'mean_values', '-v7.3');
save(fullfile(network_folder, ['start_predictions_', network_name, '_', dataset_name, '.mat']), 'start_predictions', '-v7.3');
save(fullfile(network_folder, ['std_values_', network_name, '_', dataset_name, '.mat']), 'std_values', '-v7.3');
save(fullfile(network_folder, ['MaRE_', network_name, '_', dataset_name, '.mat']), 'MeRE', 'MaRE', '-v7.3');
save(fullfile(network_folder, ['numericalError_', network_name, '_', dataset_name, '.mat']), 'numericalError', '-v7.3');
save(fullfile(network_folder, ['start_MeRE_', network_name, '_', dataset_name, '.mat']), 'start_MeRE', '-v7.3');
save(fullfile(network_folder, ['start_MaRE_', network_name, '_', dataset_name, '.mat']), 'start_MaRE', '-v7.3');
save(fullfile(network_folder, ['re_rotated_predictions', network_name, '_', dataset_name, '.mat']), 're_rotated_predictions', '-v7.3');

%% Plot the mean predictions with standard deviation error bars

cellIndex = 1;

figure;
hold on;

% Select the specific cell for X_test and Y_test
Y_test_cell = Y_test{cellIndex};
mean_values_cell = mean_values{cellIndex};  % Corrected variable name
std_values_cell = std_values{cellIndex};    % Corrected variable name
start_prediction = start_predictions{cellIndex};
t = linspace(0, 1, size(Y_test_cell, 2));

for j = 1:6
    subplot(2, 4, j)
    hold on;
    
    % Plot original data
    plot(t, Y_test_cell(j, :), 'k--', 'LineWidth', 1);
    
    % Plot mean predictions
    plot(t, mean_values_cell(j, :), 'b-', 'LineWidth', 2);

    % Plot start prediction
    plot(t, start_prediction(j, :), 'm-', 'LineWidth', 1);

    % Plot error bars
    upper_bound = mean_values_cell(j, :) + std_values_cell(j, :);  % Use std_values_cell
    lower_bound = mean_values_cell(j, :) - std_values_cell(j, :);  % Use std_values_cell
    fill([t, fliplr(t)], [upper_bound, fliplr(lower_bound)], 'b', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    
    % Set axis labels and title
    xlabel('Time');
    ylabel('Value');
    title(sprintf('Mean Predictions with Error Bars for Cell %d', cellIndex));
end

% Add legend
legend('Original Data', 'Mean Predictions', 'Starting Prediction','Error Bars', 'Location', 'best');

% Adjust figure layout
sgtitle('Mean of Re-rotated Predictions with Standard Deviation');

%% Plot MeRE and MaRE
figure;
plot(1:numRotations, MeRE, 'b-', 'LineWidth', 2);

hold on;

plot(1:numRotations, MaRE, 'r-', 'LineWidth', 2);
plot(1:numRotations, start_MeRE * ones(size(1:numRotations)), 'b--', 'LineWidth', 2);
plot(1:numRotations, start_MaRE * ones(size(1:numRotations)), 'r--', 'LineWidth', 2);

xlabel('Number of Random Rotations');
ylabel('Mean Error');
title('Mean Relative Error (MeRE) and Maximum Absolute Relative Error (MaRE) vs. Number of Random Rotations');
legend('MeRE', 'MaRE', 'Starting MeRE', 'Starting MaRE');





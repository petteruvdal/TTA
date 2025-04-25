% Define the number of random rotations
numRotations = 100000; % or any desired number

% Initialize R_list
R_list = cell(1, numRotations);

% Generate random rotation matrices and store them in R_list
disp('Generating random rotation matrices...');
for i = 1:numRotations
    R_list{i} = createRandomRotationMatrix();
end

% Save R_list to a MAT file
save('R_list_100000_0.mat', 'R_list', '-v7.3');
disp('R_list saved successfully.');

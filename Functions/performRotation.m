function [xRotated, yRotated] = performRotation(x, y, r)
    timeSteps = size(x, 2);
    vf = x(7, 1);

    % Extract components of the original A matrix
    a11 = double(x(1, 1)); a22 = double(x(2, 1));  a33 = double(x(3, 1));
    a12 = double(x(4, 1)); a13 = double(x(5, 1));  a23 = double(x(6, 1));
    
    % Construct the original A matrix
    tmpA = [a11 a12 a13; a12 a22 a23; a13 a23 a33];
    
    % Rotate the A matrix
    ARotated = r * tmpA * r';
    
    % Extract components of the strain tensor
    e11 = double(x(8, :)); e22 = double(x(9, :)); e33 = double(x(10, :));
    e12 = double(x(11, :)) / 2; e23 = double(x(12, :)) / 2; e13 = double(x(13, :)) / 2;
    
    % Construct the strain tensor
    tmpStrain = [e11; e12; e13; e12; e22; e23; e13; e23; e33];
    tmpStrain = reshape(tmpStrain, [3, 3, timeSteps]);
    
    % Extract components of the stress tensor
    s11 = double(y(1, :)); s22 = double(y(2, :)); s33 = double(y(3, :));
    s12 = double(y(4, :)); s23 = double(y(5, :)); s13 = double(y(6, :));
    
    % Construct the stress tensor
    tmpStress = [s11; s12; s13; s12; s22; s23; s13; s23; s33];
    tmpStress = reshape(tmpStress, [3, 3, timeSteps]);
    
    % Replicate the rotation matrix for each time step
    r = repmat(r, 1, 1, timeSteps);
    
    % Rotate the strain tensor
    strainRotated = pagemtimes(pagemtimes(r, tmpStrain), 'none', r, 'transpose');
    strainRotated = reshape(strainRotated, [9, size(strainRotated, 3)])';
    
    % Rotate the stress tensor
    stressRotated = pagemtimes(pagemtimes(r, tmpStress), 'none', r, 'transpose');
    stressRotated = reshape(stressRotated, [9, size(stressRotated, 3)])';
    
    % Extract the properties of the rotated A matrix
    prop = [ARotated(1, 1) ARotated(2, 2) ARotated(3, 3) ARotated(1, 2) ARotated(1, 3) ARotated(2, 3) vf];
    
    % Concatenate the rotated strain and stress tensors
    strainStress = [strainRotated(:, 1), strainRotated(:, 5), strainRotated(:, 9), ...
                    strainRotated(:, 2) * 2, strainRotated(:, 6) * 2, strainRotated(:, 3) * 2, ...
                    stressRotated(:, 1), stressRotated(:, 5), stressRotated(:, 9), ...
                    stressRotated(:, 2), stressRotated(:, 6), stressRotated(:, 3)];
    
    % Concatenate the properties and strain-stress data
    xRotated = [repmat(prop, timeSteps, 1), strainStress(:, 1:6)]';
    yRotated = strainStress(:, 7:12)';

    % Compute Von Mises stress for the original and rotated stress tensor
    vmOriginal = calculateVonMisesStress(y);
    vmRotated = calculateVonMisesStress(yRotated);
    
    % Compute the maximum absolute difference between Von Mises stresses
    error = max(abs(vmOriginal - vmRotated));
    
end

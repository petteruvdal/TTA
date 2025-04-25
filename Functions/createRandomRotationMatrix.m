function r = createRandomRotationMatrix()
    % Random sampling of rotation parameters.
    theta = 2*pi*rand();
    phi = 2*pi*rand();
    z = rand();
    
    % Generate rotation matrix around z-axis.
    R = [cos(theta) sin(theta) 0;
        -sin(theta) cos(theta) 0;
        0 0 1];
    
    % Generate mirrored householder matrix.
    v = [cos(phi)*sqrt(z); sin(phi)*sqrt(z); sqrt(1-z)];
    P = 2*v*v' - eye(3);
    
    % Total rotation matrix which is sampled uniformly from SO(3).
    r = P*R;
end



function vmStress = calculateVonMisesStress(stress)
s11 = stress(1,:);
s22 = stress(2,:);
s33 = stress(3,:);
s12 = stress(4,:);
s23 = stress(5,:);
s13 = stress(6,:);
vmStress = sqrt(((s11-s22).^2 + (s22-s33).^2 + (s33-s11).^2 + 6.*(s12.^2+s23.^2+s13.^2))/2);
end
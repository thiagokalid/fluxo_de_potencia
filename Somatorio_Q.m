function [somatorio] = Somatorio_Q(k , max , Y_bus)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
somatorio = 0;
G = real(Y_bus);
B = imag(Y_bus);

for m = 1:1:max
    theta_k = sym("theta" + k);
    theta_m = sym("theta" + m);
    V_m = sym("V" + m);
    G_km = G(k, m);
    B_km = B(k, m);
    somatorio_temp = V_m * (G_km *  sin(theta_k - theta_m) - B_km * cos(theta_k - theta_m));
    
    somatorio = somatorio + somatorio_temp;
end


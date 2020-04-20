function [funcao_P] = funcaoP(k , matriz_V, matriz_theta, matriz_Y)
    somatorio = 0;
    V_k = matriz_V(k);
    max = size(matriz_V, 2);
    G = real(matriz_Y);
    B = imag(matriz_Y);

for m = 1:1:max
    theta_k = matriz_theta(k);
    theta_m = matriz_theta(m);
    V_m = matriz_V(m);
    G_km = G(k, m);
    B_km = B(k, m);
    somatorio_temp = V_m * (G_km *  cos(theta_k - theta_m) + B_km * sin(theta_k - theta_m));
    
    somatorio = somatorio + somatorio_temp;
end
    funcao_P = somatorio * V_k;
end

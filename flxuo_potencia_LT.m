function [fluxo_de_potencia_LT] = flxuo_potencia_LT(variaveis_NR , final_X , matriz_V, matriz_theta, Y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
tamanho = size(matriz_V , 2);
E = matriz_V + matriz_theta * j;
E = subs(E , variaveis_NR , final_X');
Y_G = zeros(tamanho , tamanho);

fluxo_de_potencia_LT = zeros(tamanho , tamanho);
for p = 1:1:tamanho
    for q = 1:1:tamanho
        fluxo_de_potencia_LT(p , q) = conj(E(p)) * (E(p) - E(q)) * Y(p,q) + conj(E(p))* E(p) * (Y_G(p,q)/2);
    end
end
end


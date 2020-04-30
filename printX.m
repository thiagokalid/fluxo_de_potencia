function [] = printX(variaveis_NR , valores , matriz_V , matriz_theta)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
tamanho = size(matriz_V , 2);

valores_total = [matriz_V ; matriz_theta];
output = vpa(subs(valores_total , variaveis_NR , valores' ));
V = output(1,:)';
theta = output(2,:)';

fprintf("\n\nTensão e ângulo nos barramentos.\n");
fprintf(" n |     V  [pu]  |  %c [rad]\n", 952);
fprintf("------------------------------\n");
for i = 1:1:tamanho

    fprintf("%2.0d | %10.5f   | %10.5f \n", i , V(i) , theta(i));
end
end


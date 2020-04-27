function [] = printP(valores_P, iteracoes)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
tamanho = size(valores_P , 1);

n = [1:tamanho]';


fprintf("Potência fornecida por cada barramento depois de %d iterações. \n", iteracoes);
fprintf(" n |     P + Q*i [p.u.]\n", 952);
fprintf("------------------------------\n");
for i = 1:1:tamanho

    fprintf("%2.0d | %10.5f%+fi \n", i , real(valores_P(i)) , imag(valores_P(i)));
end
fprintf("\n\n");
end


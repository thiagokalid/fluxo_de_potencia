% Funcao para calcular matriz impedancia.
% @param matriz_Z: matriz com valores da impedância da LTs de tamanho
%N x N onde n corresponde ao número de barras.
%
% @param matriz_B: matriz dos valores da susceptância das LTs de tamanho
%1 x N onde N corresponde ao número de barras. 
%
% @return Y_bus: matriz admitancia tamanho N x N, com valores reais e
% imaginários.

function [Y_Bus] = matriz_admitancia(matriz_Z , matriz_B)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
n = size(matriz_Z , 1);
Y_Bus = zeros(n,n);

for i = 1:1:n
    for z = 1:1:n
        if(matriz_Z(i,z) ~= 0)
            Y_Bus(i,z) = -(1 / matriz_Z(i,z));
        end
        
        if(z == n)
            for(k = 1:1:n)
            if( k ~= i)
                Y_Bus(i,i) = (Y_Bus(i,i) + (-(Y_Bus(i,k))));
            else
                %matriz_Y(i,i) = (matriz_Y(i,i) + B(1));
            end
                
            end
        end
        
    end
end
end


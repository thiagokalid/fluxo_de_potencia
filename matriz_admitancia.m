clear 
clc

n = 3;
Z_base = 1190.25;           % Unidade em OhmsPode ser extendido para formula
Z_12_base = (5.55 + 56.4j); % Unidade em Ohms
Z_13_base = (7.40 + 75.2j);
Z_23_base = (5.55 + 56.4j);

Z_12  = Z_12_base / Z_base  % Por unidade (pu)
Z_13 = Z_13_base / Z_base
Z_23 = Z_23_base / Z_base

matriz_Z = zeros(n,n);
matriz_Z = [0 Z_12 Z_13 ; Z_12 0 Z_23 ; Z_13 Z_12 0]; % Impedancia das linhas de transmissao. Zero igual a nao existir linha.


matriz_Y = zeros(n,n);

for i = 1:1:n
    for j = 1:1:n
        if(matriz_Z(i,j) ~= 0)
            matriz_Y(i,j) = -(1 / matriz_Z(i,j));
        end
        
        if(j == n)
            for(k = 1:1:n)
            if( k ~= i)
                matriz_Y(i,i) = (matriz_Y(i,i) - matriz_Y(i,k));
            end
            end
        end
        
    end
end

Y_bus = matriz_Y
clear 
clc

n = 3
Z_base = 1190.25;           % Unidade em OhmsPode ser extendido para formula
Z_12_base = (5.55 + 56.4j); % Unidade em Ohms
Z_13_base = (7.40 + 75.2j);
Z_23_base = (5.55 + 56.4j);

Z_12  = Z_12_base / Z_base  % Por unidade (pu)
Z_13 = Z_13_base / Z_base
Z_23 = Z_23_base / Z_base

matriz_Z = zeros(n,n);
matriz_Z = [0 Z_12 Z_13 ; Z_12 0 Z_23 ; Z_13 Z_12 0] % Impedancia das linhas de transmissao. Zero igual a nao existir linha.

% 
% B_12_total_base = 675e-6; % Unidade em Siemens
% B_13_total_base = 900e-6;
% B_23_total_base = 675e-6;
% 
% B_12_total = 0.8034;
% B_13_total = 1.0712;
% B_23_total = 0.8034;

matriz_Y = zeros(n,n);
for i = 1:1:n
    for j = 1:1:n
        if(matriz_Z(i,j) == 0)
           
%                 display("i = " + i + "j = " + j)
                for( k = i:1:n)
                    display("i = " + i + "k = " + k)
                    if( k ~= i)
                        matriz_Y(i,j) = (matriz_Y(i,j) + matriz_Z(i,k));
                    end
                end
            
        else
            
                matriz_Y(i,j) = -(1 / matriz_Z(i,j));
            
            
        end
        
    end
    
end



Y_12 = - (1/Z_12)
Y_21 = Y_12;


Y_13 = -(1/Z_13)
Y_31 = Y_13;



Y_11 = 0;

Y_22 = 0;
Y_23 = -(1/Z_23);
Y_32 = Y_23;

Y_33 = 0;
Y_23 = Y_32;



Y_1G = -(Y_12 + Y_13)
Y_11 = Y_1G;

Y_2G = -(Y_21 + Y_23)
Y_22 = Y_2G

Y_3G = -(Y_32 + Y_31)
Y_33 = Y_3G

Y_bus = [Y_11 Y_12 Y_13; Y_21 Y_22 Y_23; Y_31 Y_32 Y_33]
matriz_Y
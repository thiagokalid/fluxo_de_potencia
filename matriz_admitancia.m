clear 
clc
n = 3;
Z_base = 1190.25;           % Unidade em OhmsPode ser extendido para formula
Z_12_base = (5.55 + 56.4j); % Unidade em Ohms
Z_13_base = (7.40 + 75.2j);
Z_23_base = (5.55 + 56.4j);

Z_12 = 0.0047 + j*0.0474
Z_13 = 0.0062 + j*0.0632
Z_23 = 0.0047 + j*0.0474

B = [ (j*675e-6/2) , ((j*900e-6)/2) , ((j*675e-6)/2) ];


matriz_Z = zeros(n,n);
matriz_Z = [0 Z_12 Z_13 ; Z_12 0 Z_23 ; Z_13 Z_12 0]; % Impedancia das linhas de transmissao. Zero igual a nao existir linha.


matriz_Y = zeros(n,n);

for i = 1:1:n
    for z = 1:1:n
        if(matriz_Z(i,z) ~= 0)
            matriz_Y(i,z) = -(1 / matriz_Z(i,z));
        end
        
        if(z == n)
            for(k = 1:1:n)
            if( k ~= i)
                matriz_Y(i,i) = (matriz_Y(i,i) + (-(matriz_Y(i,k))));
            else
                %matriz_Y(i,i) = (matriz_Y(i,i) + B(1));
            end
                
            end
        end
        
    end
end

Y_bus = matriz_Y
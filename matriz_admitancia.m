% matriz_admitancia realiza o cálculo da matriz admitância a partir da
% matriz impedância das LTs e matriz suscpetância das LTs.
%
%
%[matriz_Y] = matriz_admitancia(matriz_Z , matriz_YG)
%
% @param matriz_Z: matriz com valores da impedância da LTs de tamanho
% N x N, onde N corresponde ao número de barras.
% @param matriz_YG: matriz coluna com os valores das admitâncias do 
% barramento para o terra. 
%
% @return matriz_Y: matriz quadrada (N x N) contendo os dados das
% admitâncias das LTs conectando os barramentos (matriz_Y(n,m) = 0 significa que
% não há LT entre os barramentos n e m).

function [matriz_Y] = matriz_admitancia(matriz_Z , matriz_YG)
% Todo o método de cálculo da matriz admitância é detalhado melhor no livro
% do Ned Mohan Electric Power System: A first Course.
% 
% 
% -> Para elementos fora da diagonal principal, sua fórmula resume-se ao
% inverso negativo da impedância.
% 
% -> Para elementos dentro da diagonal pricipal, deverá ser somada a auto
% admitância especificada matriz_YG e também todos elementos que tem
% conexão (LT) com o barramento, ou seja, todos elementos de sua linha da matriz_Z.
% 
% * Caso não houver LT o valor da matriz_Z será zero, portanto não haverá
% contribuição no cálculo do somatório da admitância.
% 

n = size(matriz_Z , 1);
matriz_Y = zeros(n,n);

for i = 1:n
    somatorio_linha = 0;
    for j = 1:n
        if(matriz_Z(i,j) ~= 0)
            % Primeiro irá ser determinado todos os valores da linha que não
            % são da diagonal principal:
            matriz_Y(i,j) = -(1 / matriz_Z(i,j));
            somatorio_linha = somatorio_linha + (matriz_Y(i,j));
        end
    end
    % Após determinado todos os valores, ou seja, chegado no final
    % da linha, será determinado o valor da diagonal principal:
    matriz_Y(i,i) = matriz_YG(i) - somatorio_linha;
end
end


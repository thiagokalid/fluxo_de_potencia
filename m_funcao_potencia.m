%Funcao para calcular a matriz das funcoes de potencia
%
% @param matriz_Y: matriz N x N com valores da admitância das LTs
% @param nPV: número de barras tipo PV.
% @param nPQ: número de barras tipo PQ.
% @return m_funcao_potencia: matriz com funcoes simbólicas das potencias
% de todos os barramentos.
%




function [m_funcao_potencia , variaveis] = m_funcao_potencia(m_potencias, m_tipos , matriz_Y)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

n_equacoes = size(m_potencias, 1); % Como é matriz coluna, o número de linhas corresponde ao numer ode elementso.
n_theta = 0;
n_tensao = 0;
sym var_tensao var_theta;

for i = 1:1:n_equacoes
    switch(m_tipos(i))
        case 1 % Slack barra
            
        case 2 % PV barra
            var_theta(n_theta) = sym("theta" + i)
            n_theta = n_theta + 1;
        case 3 % PQ barra
            var_theta(n_theta) = sym("theta" + i);
            var_tensao(n_tensao) = sym("V" + i);
            n_theta = n_theta + 1;
            n_tensao = n_tensao + 1;
    end


end
end


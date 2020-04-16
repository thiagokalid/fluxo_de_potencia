%Funcao para calcular a matriz das funcoes de potencia
%
% @param matriz_Y: matriz N x N com valores da admitância das LTs
% @param nPV: número de barras tipo PV.
% @param nPQ: número de barras tipo PQ.
% @return m_funcao_potencia: matriz com funcoes simbólicas das potencias
% de todos os barramentos.
%




function [m_funcao_potencia , variaveis] = m_funcao_potencia(P_esp, Tipo_barra , matriz_Y)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

num_barramentos = size(P_esp, 1); % Como é matriz coluna, o número de linhas corresponde ao numer ode elementso.
nPV = 0;
nPQ = 0;



for i = 1:1:num_barramentos
    switch( Tipo_barra(i))
        case 1 % Slack
            
        case 2 % PV
            nPV = nPV + 1;
        case 3 % PQ
            nPQ = nPQ + 1;
    end
end
num_equacoes = ( nPV + 2 * nPQ );
% m_funcao_potencia = sym("f" , [num_equacoes , 1]);

funcao_P = sym("P" , [nPQ + nPV , 1]);
P_count = 1;
funcao_Q = sym("Q" , [nPQ , 1]);
Q_count = 1;

thetas = sym("theta", [1 , nPQ + nPV + 1]);
% thetas(Tipo_barra == 1) = 0;

tensoes = sym("V", [1 , nPQ + nPV + 1]);
% tensoes(Tipo_barra == 2 | Tipo_barra == 1) = 0;

variaveis = [  thetas(thetas ~= 0) tensoes(tensoes ~= 0)];

%%
for k = 1:1:(nPV + nPQ + 1)
    switch( Tipo_barra(k))
        case 1 %slack
        case 2 %PV
            P_k = real(P_esp(k));
            V_k = sym("V"+k);
            funcao_P(P_count) = P_k - V_k * Somatorio_P(k , num_barramentos , matriz_Y);
            P_count = P_count + 1;
        case 3 %PQ
            P_k = real(P_esp(k));
            V_k = sym("V" + k);
            funcao_P(P_count) = P_k - V_k * Somatorio_P(k , num_barramentos , matriz_Y);
            P_count = P_count + 1;
            
            Q_k = imag(P_esp(k));
            V_k = sym("V" + k);
            funcao_Q(Q_count) = Q_k - V_k * Somatorio_Q(k , num_barramentos, matriz_Y);
end
end


m_funcao_potencia = vpa([funcao_P ; funcao_Q]);




end

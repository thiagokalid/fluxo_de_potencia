%Funcao para calcular a matriz das funcoes de potencia
%
% @param matriz_Y: matriz N x N com valores da admitância das LTs
% @param nPV: número de barras tipo PV.
% @param nPQ: número de barras tipo PQ.
% @return f_potencia_NR: matriz com funcoes simbólicas das potencias
% de todos os barramentos.
%




function [f_potencia_NR , P_potencia , Q_potencia] = f_potencia_NR(P_esp, Tipo_barra ,matriz_V, matriz_theta, matriz_Y)
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

funcao_P = sym("P" , [nPQ + nPV , 1]);
P_count = 1;
funcao_Q = sym("Q" , [nPQ , 1] , 'real' );
Q_count = 1;



%%
for k = 1:1:(nPV + nPQ + 1)
    P_potencia(k , 1) = funcaoP(k, matriz_V, matriz_theta, matriz_Y);
    Q_potencia(k , 1) = funcaoQ(k, matriz_V, matriz_theta, matriz_Y);
    switch( Tipo_barra(k))
        case 1 %slack
            
        case 2 %PV
            P_k = real(P_esp(k));
            funcao_P(P_count) = P_k - funcaoP(k, matriz_V, matriz_theta, matriz_Y);
            P_count = P_count + 1;
        case 3 %PQ
            P_k = real(P_esp(k));
            funcao_P(P_count) = P_k - funcaoP(k, matriz_V, matriz_theta, matriz_Y);
            P_count = P_count + 1;
            
            Q_k = imag(P_esp(k));
            funcao_Q(Q_count) = Q_k - funcaoQ(k, matriz_V, matriz_theta, matriz_Y);
end
end


f_potencia_NR = vpa([funcao_P ; funcao_Q]);




end

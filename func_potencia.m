% func_potencia gera dois vetores contendo as funções para o cálculo de
% potência ativa e reativa dos barramentos do sistema.
%
%
%[f_potencia_NR , f_potencia_geral] = func_potencia(nPV, nPQ , P_esp, Tipo_barra ,matriz_V, matriz_theta, matriz_Y)
%
% @param nPV: número escalar inteiro que contém o quantidade de barramentos PV;
% @param nPQ: número escalar inteiro que contém o quantidade de barramentos PQ;
% @param P_esp: vetor coluna (M x 1) que contém as potências especificas e
% não especificadas (em forma de variáveis).
% @param Tipo_barra: vetor linha (1 x N) que contém o tipo de cada
% barramento (slack = 1, PV = 2, PQ = 3).
% @param matriz_V: matriz coluna que contém todas tensões especificas e
% não especificadas (em forma de variáveis).
% @param matriz_theta: matriz coluna que contém todos ângulos especificos e
% não especificados (em forma de variáveis).
% @param matriz_Y: matriz quadrada (N x N) contendo os dados das
% admitâncias das LTs conectando os barramentos (Y(n,m) = 0 significa que
% não há LT entre os barramentos n e m).
%
% @return f_potencia_NR: vetor coluna contendo funções para o cálculo das potências
%ativas e reativas desconhecidas, respectivamente.
% @return f_potencia_geral: vetor coluna contendo os valores de todas
%potências conhecidas e desconhecidas (em forma de funções);


function [f_potencia_NR , f_potencia_geral] = func_potencia(nPV, nPQ , P_esp, Tipo_barra ,matriz_V, matriz_theta, matriz_Y)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

num_barramentos = size(P_esp, 1); % Como é matriz coluna, o número de linhas corresponde ao numer ode elementso.


P_equations = sym('P' , [nPQ + nPV , 1]);
P_count = 1;
Q_equations = sym('Q' , [nPQ , 1]);
Q_count = 1;


%%
for k = 1:1:(num_barramentos)
    P = funcaoP(k, matriz_V, matriz_theta, matriz_Y);
    Q = funcaoQ(k, matriz_V, matriz_theta, matriz_Y);
    f_potencia_geral(k , 1) = P + Q * j;
    
    switch( Tipo_barra(k))
        case 1 %slack
            
        case 2 %PV
            P_k = real(P_esp(k));
            P_equations(P_count) = P_k - P;
            P_count = P_count + 1;
        case 3 %PQ
            P_k = real(P_esp(k));
            P_equations(P_count) = P_k - P;
            P_count = P_count + 1;
            
            Q_k = imag(P_esp(k));
            Q_equations(Q_count) = Q_k - Q;
            Q_count = Q_count + 1;
end
end

f_potencia_NR = vpa([P_equations ; Q_equations]);

end

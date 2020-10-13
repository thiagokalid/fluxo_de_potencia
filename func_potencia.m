% func_potencia gera dois vetores contendo as fun��es para o c�lculo de
% pot�ncia ativa e reativa dos barramentos do sistema.
%
%
%[f_potencia_NR , f_potencia_geral] = func_potencia(nPV, nPQ , P_esp, Tipo_barra ,matriz_V, matriz_theta, matriz_Y)
%
% @param nPV: n�mero escalar inteiro que cont�m o quantidade de barramentos PV;
% @param nPQ: n�mero escalar inteiro que cont�m o quantidade de barramentos PQ;
% @param P_esp: vetor coluna (M x 1) que cont�m as pot�ncias especificas e
% n�o especificadas (em forma de vari�veis).
% @param Tipo_barra: vetor linha (1 x N) que cont�m o tipo de cada
% barramento (slack = 1, PV = 2, PQ = 3).
% @param matriz_V: matriz coluna que cont�m todas tens�es especificas e
% n�o especificadas (em forma de vari�veis).
% @param matriz_theta: matriz coluna que cont�m todos �ngulos especificos e
% n�o especificados (em forma de vari�veis).
% @param matriz_Y: matriz quadrada (N x N) contendo os dados das
% admit�ncias das LTs conectando os barramentos (Y(n,m) = 0 significa que
% n�o h� LT entre os barramentos n e m).
%
% @return f_potencia_NR: vetor coluna contendo fun��es para o c�lculo das pot�ncias
%ativas e reativas desconhecidas, respectivamente.
% @return f_potencia_geral: vetor coluna contendo os valores de todas
%pot�ncias conhecidas e desconhecidas (em forma de fun��es);


function [f_potencia_NR , f_potencia_geral] = func_potencia(nPV, nPQ , P_esp, Tipo_barra ,matriz_V, matriz_theta, matriz_Y)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

num_barramentos = size(P_esp, 1); % Como � matriz coluna, o n�mero de linhas corresponde ao numer ode elementso.


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

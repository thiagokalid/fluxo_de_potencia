
% Programa para solucionar problemas de fluxo de potência em
% sistemas elétricos de potência.

clear 
clc
% INPUT DO USUÁRIO:
% Número de barramentos
numBarra = 2;

%%
% Definindo constantes e matrizes que serão utilizadas no programa:
SLACK = 1;
PV = 2;
PQ = 3;
matriz_P = sym("P" , [numBarra , 1]);
matriz_Q = sym("Q" , [numBarra , 1]);
assume(matriz_Q, 'real');
matriz_theta = sym("theta" , [1 , numBarra]);
matriz_V = sym("V" , [1 , numBarra]);
matriz_YG = zeros(numBarra , 1);
matriz_Z = zeros(numBarra,numBarra);
%%
% INPUT DO USUÁRIO: especificações das Linhas de Transmissão (LTs):

% Impedância da LT entre os barramentos 1-2 ou 2-1 (em pu):
matriz_Z(1,2) = 0.0047 + j* 0.0474;
matriz_Z(2,1) = 0.0047 + j* 0.0474;

% Impedância da LT entre os barramentos 1-2 ou 2-1 (em pu):
matriz_Z(1,2) = j* 0.0632;
matriz_Z(2,1) = j* 0.0632;


% Admitância barramento-terra na barra 1, em pu:
matriz_YG(1) = 0 ;

% Admitância barramento-terra na barra 2, em pu:
matriz_YG(2) = 0 ;


% Formando a matriz admitância:
matriz_Y = matriz_admitancia(matriz_Z, matriz_YG)


%%
% INPUT DO USUÁRIO:  especificações dos barramentos:
% Se for barra tipo SLACK, deve-se definir o valor da tensão (1 pu) e ângulo (0 rad)
% Se for barra tipo PV, deve-se definir Potência ativa injetada em pu e magnitude da tensão em pu.
% Se for barra tipo PQ, deve-se definir Potência ativa injetada em pu e Potência reativa injetada em pu.


% Barramento 1: PQ
Tipo_barra(1) = PQ;
matriz_P(1) = -1.0;
matriz_Q(1) = 0;

% Barramento 2: SLACK
Tipo_barra(2) = SLACK;
matriz_V(2) = 1;
matriz_theta(2) = 0;




%%
% Esta secção irá preparar os dados necessários para haver condições de
% solucionar o sistema não linear pelo método de escolha: Newton-Raphson (NR)

% Potência total = Potência ativa + Potência reativa:
P_esp = vpa(matriz_P + matriz_Q * j);

% Construindo o vetor chute X0 e o vetor coluna contendo as variáveis livres para 
% o método NR e calculo do jacobiano:
[X0 , variaveis_NR] = obter_dadosNR(Tipo_barra);


% Contando número de barramentos PV e PQ:
[nPV , nPQ] = contBarramentos(Tipo_barra);

% Obtendo as equações básicas de potência:
[equacao_potencia_NR , f_potencia_geral] = func_potencia(nPV , nPQ , P_esp, Tipo_barra ,matriz_V , matriz_theta, matriz_Y);



sym_P_geral = symfun(f_potencia_geral , variaveis_NR);
P_numeric_geral = matlabFunction(sym_P_geral);

%%
% Chama-se a função que resolve o sistema pelo método numérica
% Newton-Raphson:
[final_X , final_JAC , iteracoes] = NewtonRaphson(equacao_potencia_NR , variaveis_NR ,  X0, 10000, 1.0e-20);

% Cálculo do fluxo de potência nas linhas de transmissão:
[P_nas_LTs] = flxuo_potencia_LT(variaveis_NR , final_X , matriz_V, matriz_theta, matriz_Z);

% Mostrando na tela de comando do usuário os resultados obtidos:
fprintf("Número de iterações = %d ", iteracoes);

cell_X = num2cell(final_X);
P_das_barras = P_numeric_geral(cell_X{:});
printP_barras(P_das_barras);

printX(variaveis_NR , final_X, matriz_V, matriz_theta);

printP_LTs(P_nas_LTs);




% Programa para solucionar problemas de fluxo de potência em
% sistemas elétricos de potência.

clear 
clc

% INPUT DO USUÁRIO:
% Número de barramentos
numBarra = 5;

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
%%
% INPUT DO USUÁRIO: especificações das Linhas de Transmissão (LTs):
matriz_Z = zeros(numBarra,numBarra);

% Impedância da LT entre os barramentos 1-2 ou 2-1 (em pu):
matriz_Z(1,2) = 0.02 + j*0.06;
matriz_Z(2,1) = 0.02 + j*0.06;

% Impedância da LT entre os barramentos 1-3 ou 3-1(em pu):
matriz_Z(1,3) = 0.08 + j*0.24;
matriz_Z(3,1) = 0.08 + j*0.24;

% Impedância da LT entre os barramentos 2-3 ou 3-2(em pu):
matriz_Z(2,3) = 0.06 + j*0.18;
matriz_Z(3,2) = 0.06 + j*0.18;

% Impedância da LT entre os barramentos 2-4 ou 4-2(em pu):
matriz_Z(2,4) = 0.06 + j*0.18;
matriz_Z(4,2) = 0.06 + j*0.18;

% Impedância da LT entre os barramentos 2-5 ou 5-2(em pu):
matriz_Z(2,5) = 0.04 + j*0.12;
matriz_Z(5,2) = 0.04 + j*0.12;

% Impedância da LT entre os barramentos 3-4 ou 4-3(em pu):
matriz_Z(3,4) = 0.01 + j*0.03;
matriz_Z(4,3) = 0.01 + j*0.03;

% Impedância da LT entre os barramentos 4-5 ou 5-4(em pu):
matriz_Z(4,5) = 0.08 + j*0.24;
matriz_Z(5,4) = 0.08 + j*0.24;



% Admitância barramento-terra na barra 1, em pu:
matriz_YG(1) = j*0.055 ;

% Admitância barramento-terra na barra 2, em pu:
matriz_YG(2) = j*0.085 ;

% Admitância barramento-terra na barra 3, em pu:
matriz_YG(3) = j*0.055 ;

% Admitância barramento-terra na barra 4, em pu:
matriz_YG(4) = j*0.055 ;

% Admitância barramento-terra na barra 5, em pu:
matriz_YG(5) = j*0.040 ;



% Formando a matriz admitância:
matriz_Y = matriz_admitancia();


%%
% INPUT DO USUÁRIO:  especificações dos barramentos:
% Se for barra tipo SLACK, deve-se definir o valor da tensão (1 pu) e ângulo (0 rad)
% Se for barra tipo PV, deve-se definir Potência ativa injetada em pu e magnitude da tensão em pu.
% Se for barra tipo PQ, deve-se definir Potência ativa injetada em pu e Potência reativa injetada em pu.

base = 100000e3;

% Barramento 1: SLACK
Tipo_barra(1) = SLACK;
matriz_V(1) = 1.06;
matriz_theta(1) = 0;

% Barramento 2: PQ
Tipo_barra(2) = PQ;
matriz_P(2) = (40e6 - 20e6)/base;
matriz_Q(2) = (30e6 - 10e6)/base;

% Barramento 3: PQ
Tipo_barra(3) = PQ;
matriz_P(3) = (-45e6)/base;
matriz_Q(3) = (-15e6)/base;

% Barramento 4: PQ
Tipo_barra(4) = PQ;
matriz_P(4) = (-40e6)/base;
matriz_Q(4) = ( -5e6)/base;

% Barramento 5: PQ
Tipo_barra(5) = PQ;
matriz_P(5) = (-60e6)/base;
matriz_Q(5) = (-10e6)/base;

% Critérios para o método numérico:
max_iteracoes =  100000;
erro = 1.0e-20;


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



sym_P_geral = symfun(f_potencia_geral , equacao_potencia_NR);
P_numeric_geral = matlabFunction(sym_P_geral);

%%
% Chama-se a função que resolve o sistema pelo método numérica
% Newton-Raphson:
[final_X , final_JAC , iteracoes] = NewtonRaphson(equacao_potencia_NR , variaveis_NR ,  X0, max_iteracoes , erro);

% Cálculo do fluxo de potência nas linhas de transmissão:
[P_nas_LTs] = flxuo_potencia_LT(variaveis_NR , final_X , matriz_V, matriz_theta, matriz_Z);

% Mostrando na tela de comando do usuário os resultados obtidos:
fprintf("Número de iterações = %d ", iteracoes);

cell_X = num2cell(final_X);
P_das_barras = P_numeric_geral(cell_X{:});
printP_barras(P_das_barras);

printX(variaveis_NR , final_X, matriz_V, matriz_theta);

printP_LTs(P_nas_LTs);



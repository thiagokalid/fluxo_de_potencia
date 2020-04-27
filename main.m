
%
% Exemplo 5.4
%

clear 
clc
% Input do usuário:
% Número de barramentos
numBarra = 3;

%%
% Constantes para facilitar a leitura:
SLACK = 1;
PV = 2;
PQ = 3;

% Definindo matrizes das variáveis que serão utilizadas e especificadas:
matriz_P = sym("P" , [numBarra , 1]);
matriz_Q = sym("Q" , [numBarra , 1]);
assume(matriz_Q, 'real');
matriz_theta = sym("theta" , [1 , numBarra]);
matriz_V = sym("V" , [1 , numBarra]);
matriz_B = zeros(numBarra , 1);
%%
% Input do usuário: especificações das Linhas de Transmissão (LTs):
matriz_Z = zeros(numBarra,numBarra);

% Impedância da LT entre os barramentos 1-2 ou 2-1 (em p.u.):
matriz_Z(1,2) = 0.0047 + j*0.0474;
matriz_Z(2,1) = 0.0047 + j*0.0474;

% Impedância da LT entre os barramentos 1-3 ou 3-1(em p.u.):
matriz_Z(1,3) = 0.0062 + j*0.0632;
matriz_Z(3,1) = 0.0062 + j*0.0632;

% Impedância da LT entre os barramentos 2-3 ou 3-2(em p.u.):
matriz_Z(2,3) = 0.0047 + j*0.0474;
matriz_Z(3,2) = 0.0047 + j*0.0474;

% Susceptância no barramento 1, em p.u.:
matriz_B(1) = 0;

% Susceptância no barramento 2, em p.u.:
matriz_B(2) = 0;

% Susceptância no barramento 3, em p.u.:
matriz_B(3) = 0;





% Formando a matriz admitância:
matriz_Y = matriz_admitancia(matriz_Z, matriz_B);


%%
% Input do usuário: especificações dos barramentos:
% Se for barra tipo SLACK, deve-se definir o valor da tensão (1 p.u.) e ângulo (0 rad)
% Se for barra tipo PV, deve-se definir Potência ativa em p.u. e magnitude da tensão em p.u..
% Se for barra tipo PQ, deve-se definir Potência ativa em p.u. e Potência reativa em p.u..


% Barramento 1: SLACK
Tipo_barra(1) = SLACK;
matriz_V(1) = 1;
matriz_theta(1) = 0;

% Barramento 2: PV
Tipo_barra(2) = PV;
matriz_P(2) = 2.00;
matriz_V(2) = 1.05;



% Barramento 3: PQ
Tipo_barra(3) = PQ;
matriz_P(3) = -5.0;
matriz_Q(3) = -1.0;


P_esp = vpa(matriz_P + matriz_Q * i);


%%

% Construindo o vetor chute X0 e as variáveis para o método NR:
[X0 , variaveis_NR] = obter_dadosNR(Tipo_barra);


% Contando número de barramentos PV e PQ:
[nPV , nPQ] = contBarramentos(Tipo_barra);

% Obtendo as equações de potência:
[equacao_potencia_NR , f_potencia_geral] = func_potencia(nPV , nPQ , P_esp, Tipo_barra ,matriz_V , matriz_theta, matriz_Y);



sym_P_geral = symfun(f_potencia_geral , variaveis_NR);
P_numeric_geral = matlabFunction(sym_P_geral);

%%
[final_X , final_JAC , iteracoes] = NewtonRaphson(equacao_potencia_NR , variaveis_NR ,  X0, 100, 1.0e-15);

cell_X = num2cell(final_X);
P_values = P_numeric_geral(cell_X{:});
printP(P_values, iteracoes);

printX(variaveis_NR , final_X, matriz_V, matriz_theta, iteracoes);

clear 
clc
% Número de barramentos
n = 3;
%%
% Constantes para facilitar a leitura:
SLACK = 1;
PV = 2;
PQ = 3;

%%
% Definindo matrizes das variáveis que serão utilizadas e especificadas:
matriz_P = sym("P" , [n , 1]);
matriz_Q = sym("Q" , [n , 1]);
assume(matriz_Q, 'real');
matriz_theta = sym("theta" , [1 , n]);
matriz_V = sym("V" , [1 , n]);

%%
% Input do usuário: especificações das Linhas de Transmissão:
matriz_Z = zeros(n,n);

% Impedância da LT entre os barramentos 1-2 ou 2-1 (em p.u.):
matriz_Z(1,2) = 0.0047 + j*0.0474;
matriz_Z(2,1) = 0.0047 + j*0.0474;

% Impedância da LT entre os barramentos 1-3 ou 3-1(em p.u.):
matriz_Z(1,3) = 0.0062 + j*0.0632;
matriz_Z(3,1) = 0.0062 + j*0.0632;

% Impedância da LT entre os barramentos 2-3 ou 3-2(em p.u.):
matriz_Z(2,3) = 0.0047 + j*0.0474;
matriz_Z(3,2) = 0.0047 + j*0.0474;


matriz_B = [0 ; 0 ; 0];


matriz_Y = matriz_admitancia(matriz_Z, matriz_B);


%%
% Input do usuário: especificações dos barramentos:

% Definindo o tipo de cada barramento. Pode ser slack, PV ou PQ.
Tipo_barra(1) = SLACK;
Tipo_barra(2) = PV;
Tipo_barra(3) = PQ;



% Potência ativa especificada por cada barra PV ou PQ em p.u..
% matriz_P(1) = -0.15;
matriz_P(2) = 2;
matriz_P(3) = -5;


% Potência reativa especificada por cada barra PQ em p.u..
% matriz_Q(1) = ;
% matriz_Q(2) = 2.67;
matriz_Q(3) = -1;

% Valor da tensão especificada nos barramentos PV e slack em p.u..
matriz_V(1) = 1;
matriz_V(2) = 1.05;
% matriz_V(3) = 1;

% Valor do ângulo especificado no barramento slack em radianos..
matriz_theta(1) = 0;
% matriz_theta(2) = 0;
% matriz_theta(1) =;


P_esp = vpa(matriz_P + matriz_Q * i);


%%

% Construindo o vetor chute X0 e as variáveis para o método NR:
[X0 , variaveis_NR] = obter_dadosNR(Tipo_barra);

%%
% Contando número de barramentos PV e PQ:
[nPV , nPQ] = contBarramentos(Tipo_barra);

% Obtendo as equações de potência:
[equacao_potencia_NR , f_potencia_geral] = func_potencia(nPV , nPQ , P_esp, Tipo_barra ,matriz_V , matriz_theta, matriz_Y);


sym_P_geral = symfun(f_potencia_geral , variaveis_NR);
P_numeric_geral = matlabFunction(sym_P_geral);


[final_X , final_JAC , iteracoes] = NewtonRaphson(equacao_potencia_NR , variaveis_NR ,  X0)


cell_X = num2cell(final_X);
P_values = P_numeric_geral(cell_X{:})



% Programa para solucionar problemas de fluxo de pot�ncia em
% sistemas el�tricos de pot�ncia.

clear 
clc
% INPUT DO USU�RIO:
% N�mero de barramentos
numBarra = 3;

%%
% Definindo constantes e matrizes que ser�o utilizadas no programa:
SLACK = 1;
PV = 2;
PQ = 3;
matriz_P = sym('P' , [numBarra , 1]);
matriz_Q = sym('Q' , [numBarra , 1]);
assume(matriz_Q, 'real');
matriz_theta = sym('theta' , [1 , numBarra]);
matriz_V = sym('V' , [1 , numBarra]);
matriz_YG = zeros(numBarra , 1);
matriz_Z = zeros(numBarra,numBarra);
%%
% INPUT DO USU�RIO: especifica��es das Linhas de Transmiss�o (LTs):

% Imped�ncia da LT entre os barramentos 1-2 ou 2-1 (em pu):
matriz_Z(1,2) = 0.0047 + j* 0.0474;
matriz_Z(2,1) = 0.0047 + j* 0.0474;

% Imped�ncia da LT entre os barramentos 1-3 ou 3-1 (em pu):
matriz_Z(1,3) = 0.0062 + j* 0.0632;
matriz_Z(3,1) = 0.0062 + j* 0.0632;

% Imped�ncia da LT entre os barramentos 2-3 ou 3-2 (em pu):
matriz_Z(2,3) = 0.0047 + j* 0.0474;
matriz_Z(3,2) = 0.0047 + j* 0.0474;


% Admit�ncia barramento-terra na barra 1, em pu:
matriz_YG(1) = 0 ;

% Admit�ncia barramento-terra na barra 2, em pu:
matriz_YG(2) = 0 ;

% Admit�ncia barramento-terra na barra 3, em pu:
matriz_YG(3) = 0 ;


% Formando a matriz admit�ncia:
matriz_Y = matriz_admitancia(matriz_Z, matriz_YG)


%%
% INPUT DO USU�RIO:  especifica��es dos barramentos:
% Se for barra tipo SLACK, deve-se definir o valor da tens�o (1 pu) e �ngulo (0 rad)
% Se for barra tipo PV, deve-se definir Pot�ncia ativa injetada em pu e magnitude da tens�o em pu.
% Se for barra tipo PQ, deve-se definir Pot�ncia ativa injetada em pu e Pot�ncia reativa injetada em pu.


% Barramento 1: SLACK
Tipo_barra(1) = SLACK;
matriz_V(1) = 1.0;
matriz_theta(1) = 0;

% Barramento 2: PQ
Tipo_barra(2) = PV;
matriz_P(2) = 2.00;
matriz_V(2) = 1.05;

% Barramento 3: PQ
Tipo_barra(3) = PQ;
matriz_P(3) = -5.00;
matriz_Q(3) = -1.00;




%%
% Esta sec��o ir� preparar os dados necess�rios para haver condi��es de
% solucionar o sistema n�o linear pelo m�todo de escolha: Newton-Raphson (NR)

% Pot�ncia total = Pot�ncia ativa + Pot�ncia reativa:
P_esp = vpa(matriz_P + matriz_Q * j);

% Construindo o vetor chute X0 e o vetor coluna contendo as vari�veis livres para 
% o m�todo NR e calculo do jacobiano:
[X0 , variaveis_NR] = obter_dadosNR(Tipo_barra);


% Contando n�mero de barramentos PV e PQ:
[nPV , nPQ] = contBarramentos(Tipo_barra);

% Obtendo as equa��es b�sicas de pot�ncia:
[equacao_potencia_NR , f_potencia_geral] = func_potencia(nPV , nPQ , P_esp, Tipo_barra ,matriz_V , matriz_theta, matriz_Y);



sym_P_geral = symfun(f_potencia_geral , variaveis_NR);
P_numeric_geral = matlabFunction(sym_P_geral);

%%
% Chama-se a fun��o que resolve o sistema pelo m�todo num�rica
% Newton-Raphson:
[final_X , final_JAC , iteracoes] = NewtonRaphson(equacao_potencia_NR , variaveis_NR ,  X0, 10000, 1.0e-20);

% C�lculo do fluxo de pot�ncia nas linhas de transmiss�o:
[P_nas_LTs] = flxuo_potencia_LT(variaveis_NR , final_X , matriz_V, matriz_theta, matriz_Z);

% Mostrando na tela de comando do usu�rio os resultados obtidos:
fprintf('N�mero de itera��es = %d ', iteracoes);

cell_X = num2cell(final_X);
P_das_barras = P_numeric_geral(cell_X{:});
printP_barras(P_das_barras);

printX(variaveis_NR , final_X, matriz_V, matriz_theta);

printP_LTs(P_nas_LTs);



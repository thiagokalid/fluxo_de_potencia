clear 
clc
n = 3;

SLACK = 1;
PV = 2;
PQ = 3;
%%
matriz_Z = zeros(n,n);

matriz_Z(1,2) = 0.0047 + j*0.0474;
matriz_Z(2,1) = matriz_Z(1,2);

matriz_Z(1,3) = 0.0062 + j*0.0632;
matriz_Z(3,1) = matriz_Z(1,3);

matriz_Z(2,3) = 0.0047 + j*0.0474;
matriz_Z(3,2) = matriz_Z(2,3);

matriz_B = [0 ; 0 ; 0];


matriz_Y = matriz_admitancia(matriz_Z, matriz_B);


%%


Tipo_barra(1) = SLACK;
Tipo_barra(2) = PV;
Tipo_barra(3) = PQ;



matriz_P = sym("P" , [n , 1]);
% matriz_P(1) = -0.15;
matriz_P(2) = 2;
matriz_P(3) = -5;

matriz_Q = sym("Q" , [n , 1]);
assume(matriz_Q, 'real');
% matriz_Q(1) = ;
% matriz_Q(2) = 2.67;
matriz_Q(3) = -1;

P_esp = vpa(matriz_P + matriz_Q * i);



matriz_V = sym("V" , [1 , n]);
vars = matriz_V;
simb_V = matriz_V;
matriz_V(1) = 1;simb_V(1) = 0;
matriz_V(2) = 1.05; simb_V(2) = 0;
% matriz_V(3) = 1; simb_V(3) = 0;


matriz_theta = sym("theta" , [1 , n]);
vars = [matriz_theta vars];
simb_theta = matriz_theta;
matriz_theta(1) = 0; simb_theta(1) = 0;
% matriz_theta(2) = 0; simb_theta(2) = 0;
% matriz_theta(1) =; simb_theta(3) = 0;


%%
non_zero_theta = simb_theta(simb_theta ~= 0);
non_zero_V     = simb_V(simb_V ~= 0);

variaveis_NR = [non_zero_theta , non_zero_V];

X0   = [zeros(1, size(non_zero_theta , 2))  ones(1, size(non_zero_V, 2))]';



%%
[nPV , nPQ] = contBarramentos(Tipo_barra);
[equacao_potencia_NR , f_potencia_geral] = power_flow_equations(P_esp, Tipo_barra ,matriz_V , matriz_theta, matriz_Y);


% Q_func = symfun(Q_potencia , variaveis_NR);

sym_P_geral = symfun(f_potencia_geral , variaveis_NR);
P_numeric_geral = matlabFunction(sym_P_geral);


[X1 , final_JAC, iteracoes] = NewtonRaphson(equacao_potencia_NR , variaveis_NR ,  X0)


cell_X1 = num2cell(X1);
P_values = P_numeric_geral(cell_X1{:})


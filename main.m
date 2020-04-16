clear 
clc
n = 3;

SLACK = 1;
PV = 2;
PQ = 3;
%%
Z_base = 1190.25;           % Unidade em OhmsPode ser extendido para formula
Z_12_base = (5.55 + 56.4j); % Unidade em Ohms
Z_13_base = (7.40 + 75.2j);
Z_23_base = (5.55 + 56.4j);

Z_12 = 0.0047 + j*0.0474;
Z_13 = 0.0062 + j*0.0632;
Z_23 = 0.0047 + j*0.0474;

matriz_B = [ (j*675e-6/2) ; ((j*900e-6)/2) ; ((j*675e-6)/2) ];


matriz_Z = zeros(n,n);
matriz_Z = [0 Z_12 Z_13 ; Z_12 0 Z_23 ; Z_13 Z_12 0]; % Impedancia das linhas de transmissao. Zero igual a nao existir linha.


matriz_Y = zeros(n,n);

matriz_Y = matriz_admitancia(matriz_Z, matriz_B);

matriz_G = [0.33 -0.33 0 ; -0.33 0.4078 -0.0778 ; 0 -0.0778 0.0778];
matriz_B = [-3.2303i 3.3003i 0i ; 3.3003i -4.5154i 1.2451i; 0 1.2451i -1.2351i];
matriz_Y = matriz_G + matriz_B
%%


Tipo_barra(1) = PQ;
Tipo_barra(2) = SLACK;
Tipo_barra(3) = PV;



matriz_P = sym("P" , [n , 1]);
matriz_P(1) = -0.15;
% matriz_P(2) = ;
matriz_P(3) = 0.20;

matriz_Q = sym("Q" , [n , 1]);
matriz_Q(1) = 0.05;
matriz_Q(2) = 0;
matriz_Q(3) = 0;

P_esp = vpa(matriz_P + matriz_Q * i);



matriz_V = sym("V" , [1 , n]);
simb_V = matriz_V;
% matriz_V(1) = ;
matriz_V(2) = 1; simb_V(2) = 0;
matriz_V(3) = 1; simb_V(3) = 0;


matriz_thet = sym("theta" , [1 , n]);
simb_theta = matriz_thet;
% matriz_thet(1) =;
matriz_thet(2) = 0; simb_theta(2) = 0;
% matriz_thet(1) =;


%%
non_zero_theta = simb_theta(simb_theta ~= 0);
non_zero_V     = simb_V(simb_V ~= 0);

variables = [non_zero_theta , non_zero_V];

X0   = [zeros(1, size(non_zero_theta , 2))  ones(1, size(non_zero_V, 2))]';
cell_X0   = num2cell(X0);
%%
[m_funcao_potencia , variaveis] = m_funcao_potencia(P_esp, Tipo_barra , matriz_Y);
m_P = subs(m_funcao_potencia , variaveis , [matriz_thet matriz_V]);
f_P = symfun(m_P , variables);
mm_P = matlabFunction(f_P);
m_JAC = jacobian(m_funcao_potencia , variables);
m_JAC = subs(m_JAC , variaveis , [matriz_thet matriz_V]);
f_JAC = symfun(m_JAC , variables);
mm_JAC = matlabFunction(f_JAC);



%%
eval = f_P(cell_X0{:});
erro = norm(eval , 2);
max_iter = 20;
iter = 1;
tol  = 1.e-10;

while(erro > tol)
    P_X0 = f_P(cell_X0{:});
    JAC_X0 = mm_JAC(cell_X0{:});
    
    X1 = X0 - inv(JAC_X0) * P_X0;
    
    P_X1 = f_P(cell_X0{:});
    eval = f_P(cell_X0{:});
    erro = norm(eval , 2);
    
    if iter > max_iter
        break
    end
    X0 = X1;
    cell_X0 = num2cell(X0);
    iter = iter + 1;
    
end

variables
X1
cell_X1 = num2cell(X1);
mm_P(cell_X1{:})





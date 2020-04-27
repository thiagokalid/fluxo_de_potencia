function [X_final , final_JAC, iter] = NewtonRaphson(eq_fluxo_pot , variaveis ,  X0, max_iteracao, tolerancia)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
P_sym_function = symfun(eq_fluxo_pot , variaveis);
P_numeric_func = matlabFunction(P_sym_function);

JAC_equation = jacobian(eq_fluxo_pot , variaveis);
JAC_symfun   = symfun(JAC_equation , variaveis);
JAC_numeric_func = matlabFunction(JAC_symfun);


cell_X0   = num2cell(X0);
eval = P_numeric_func(cell_X0{:});
erro = norm(eval , 2);
max_iter = max_iteracao;
iter = 0;
tol  = tolerancia;

while((erro > tol)&&(iter < max_iter))
    P_X0 = P_numeric_func(cell_X0{:});
    JAC_X0 = JAC_numeric_func(cell_X0{:});
    
    X1 = X0 - inv(JAC_X0) * P_X0;
    
    P_X1 = P_numeric_func(cell_X0{:});
    eval = P_numeric_func(cell_X0{:});
    erro = norm(eval , 2);
    
    X0 = X1;
    cell_X0 = num2cell(X0);
    iter = iter + 1;
    
    
end



X_final = X1;
cell_X1 = num2cell(X1);
final_JAC = -JAC_numeric_func(cell_X1{:});

end


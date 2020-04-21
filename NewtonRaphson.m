function [X1 , final_JAC] = NewtonRaphson(power_equations , variables ,  X0)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
P_sym_function = symfun(power_equations , variables);
P_numeric_func = matlabFunction(P_sym_function);

JAC_equation = jacobian(power_equations , variables);
JAC_symfun   = symfun(JAC_equation , variables);
JAC_numeric_func = matlabFunction(JAC_symfun);


cell_X0   = num2cell(X0);
eval = P_numeric_func(cell_X0{:});
erro = norm(eval , 2);
max_iter = 1000;
iter = 1;
tol  = 1.e-10;

while(erro > tol)
    P_X0 = P_numeric_func(cell_X0{:});
    JAC_X0 = JAC_numeric_func(cell_X0{:});
    
    X1 = X0 - inv(JAC_X0) * P_X0;
    
    P_X1 = P_numeric_func(cell_X0{:});
    eval = P_numeric_func(cell_X0{:});
    erro = norm(eval , 2);
    
    if iter > max_iter
        break
    end
    X0 = X1;
    cell_X0 = num2cell(X0);
    iter = iter + 1;
    
end

cell_X1 = num2cell(X1);
final_JAC = -JAC_numeric_func(cell_X1{:});

end


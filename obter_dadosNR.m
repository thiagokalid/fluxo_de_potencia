
function [X0 , variaveisNR] = obter_dadosNR(Tipo_barra)
    num_barra = size(Tipo_barra , 2);
    
    NR_theta = sym("f" , [1,1]);
    NR_V     = sym("f" , [1,1]);

  
    for i = 1:1:num_barra
        switch(Tipo_barra(i))
            case 1
            case 2
                NR_theta = [NR_theta sym("theta" + i)];
            case 3
                NR_theta = [NR_theta sym("theta" + i)];
                NR_V     = [NR_V sym("V" + i)];
        end
    end
    NR_theta = NR_theta(2 : end);
    NR_V = NR_V(2 : end);
    
    
    X0_V = ones(1, size(NR_V , 2));
    X0_theta = zeros(1, size(NR_theta , 2));
    X0 = [ X0_theta , X0_V ]';
    
    variaveisNR = [NR_theta , NR_V];
    
end

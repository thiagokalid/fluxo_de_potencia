% obter_dadosNR gera dois vetores contendo os dados necess�rios para
% conseguir realizar o m�todo Newton-Raphson.
%
%[X0 , variaveisNR] = obter_dadosNR(Tipo_barra)
%
%@param Tipo_barra: Vetor linha contendo as especifica��es de qual tipo �
%cada barramento.
%@return X0: vetor coluna contendo todos os chutes inicias para as
%vari�veis independentes das equa��es de pot�ncia.
%@return variaveisNR: retorna um vetor linha contendo todas as vari�veis
%independentes das equa��es de pot�ncia para o m�todo NR.
function [X0 , variaveisNR] = obter_dadosNR(Tipo_barra)
    num_barra = size(Tipo_barra , 2);
    
    NR_theta = sym('f' , [1,1]);
    NR_V     = sym('f' , [1,1]);

  
    for i = 1:1:num_barra
        switch(Tipo_barra(i))
            case 1
            case 2
                NR_theta = [NR_theta sym(['theta' num2str(i)])];
            case 3
                NR_theta = [NR_theta sym(['theta' num2str(i)])];
                NR_V     = [NR_V sym(['V' num2str(i)])];
        end
    end
    NR_theta = NR_theta(2 : end);
    NR_V = NR_V(2 : end);
    
    
    X0_V = ones(1, size(NR_V , 2));
    X0_theta = zeros(1, size(NR_theta , 2));
    X0 = [ X0_theta , X0_V ]';
    
    variaveisNR = [NR_theta , NR_V];
    
end

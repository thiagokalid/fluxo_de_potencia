function [] = printP_LTs(fluxo_LTs)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
[ colunas , linhas ] = size(fluxo_LTs);

fprintf("\n\nFluxo de potência ativa e reativa entre os barramentos p e q.\n");
fprintf("  p -> q |    P + Q * i [p.u.]   \n");
fprintf("---------------------------------\n");
for p = 1:1:colunas
    for q = 1:1:linhas
        if(p ~= q && fluxo_LTs(p,q) ~= 0)
            fprintf(" %2.0d - %2.0d | %10.5f%+fi \n", p, q , real(fluxo_LTs(p,q)) , imag(fluxo_LTs(p,q)));
        end
    end
end

end


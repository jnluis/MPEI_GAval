function B = Adicionar_FiltroBloom(B, elemento, k,n)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here 
    pos = DJB31MA_Modified(elemento,127,k);
    pos = mod(pos,n)+1;
    B(pos)=B(pos)+1;
end
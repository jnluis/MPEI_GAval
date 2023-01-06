function B = Adicionar_FiltroBloom(B, element, k,n)
    hash = DJB31MA_Modified(element,127,k);
    h = mod(hash,n)+1;
    B(h)=B(h)+1;
end
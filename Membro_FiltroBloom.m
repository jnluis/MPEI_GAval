function count = Membro_FiltroBloom(B, element, k, n)
    hash = DJB31MA_Modified(element,127,k);
    h = mod(hash,n)+1;
    count = min(B(h));
end
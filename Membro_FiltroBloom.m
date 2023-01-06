function count = Membro_FiltroBloom(B, elemento, k, n)
    pos = DJB31MA_Modified(elemento,127,k);
    pos = mod(pos,n)+1;
    count = min(B(pos));
end
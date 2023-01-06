function hash = DJB31MA_Modified(key, seed, K)
    len = length(key);
    key = double(key);
    h = seed;
    for i = 1:len
        h = mod(31 * h + key(i), 2^32 - 1);
    end
    
    hash = zeros(1,K);
    for j = 1:K
        h = mod(31 * h + j, 2^32 - 1);
        hash(j) = h;
    end
end

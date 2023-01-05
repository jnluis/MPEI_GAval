function hash = DJB31MA_Modified(key, seed, K)
% implementation of the DJB31MA hash function based on the algorithm obtained
% in the 2014 summary (PJF) that is in C
%
%  key    array of characters with the key
%  seed   seed that allows you to get multiple hash codes for the same key
%
%  h      returned hashcode
    len = length(key);
    key = double(key);
    h = seed;
    for i = 1:len
        h = mod(31 * h + key(i), 2^32 - 1);
    end
    
    % added
    hash = zeros(1,K);
    for j = 1:K
        h = mod(31 * h + j, 2^32 - 1);
        hash(j) = h;
    end
end

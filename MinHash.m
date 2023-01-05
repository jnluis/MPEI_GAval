function signatures = MinHash(Set,numHash)

nfilms = length(Set);   %Nº elementos do Set (users)

%Nº linhas -> Nº users, Nº colunas -> Nº hash functions
signatures = Inf(nfilms,numHash);  
h = waitbar(0,'Calculating MinHash');

tic
for i = 1:nfilms
    waitbar(i/nfilms,h);
    nUsers = length(Set{i});   %Nº filmes do user
    for j = 1:nUsers
        key = num2str(Set{i}(j));
        hash = DJB31MA_Modified(key,127,numHash);
        signatures(i,:) = min(hash,signatures(i,:));
    end
end
delete (h)

end


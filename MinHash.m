function assinaturas = MinHash(Set,numHash)

%MINHASH Summary of this function goes here
%   Detailed explanation goes here

Nu = length(Set);   %Nº elementos do Set (users)

%Nº linhas -> Nº users, Nº colunas -> Nº hash functions
assinaturas = Inf(Nu,numHash);  
h = waitbar(0,'Calculating MinHash');

tic
for i = 1:Nu
    waitbar(i/Nu,h);
    Nfilmes = length(Set{i});   %Nº filmes do user
    for j = 1:Nfilmes
        key = num2str(Set{i}(j));
        h_out = DJB31MA_Modified(key,127,numHash);
        assinaturas(i,:) = min(h_out,assinaturas(i,:));
    end
end
delete (h)

end



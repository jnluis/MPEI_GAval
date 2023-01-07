clear;
clc;

[Set, films] = create_structure('u.data');

dic = readcell('users.txt', 'Delimiter', ';');
nUsers = height(dic);

dic2 = readcell('film_info.txt', 'Delimiter', '\t');
nFilms = height(dic2);

% Cálculo do MinHash correspondente aos utilizadores 
nHF = 1000;
MinHashUsers = MinHash(Set,nHF);

% Cálculo do MinHash correspondente aos interesses 
nHF = 200;
[Interests, sigInterests] = getInterests(nUsers,dic);

%MinHash Interesses
MinHashInterests = MinHash_Inte(sigInterests,Interests, nHF, nUsers);

% Cálculo do MinHash correspondente aos Titulos 
nHF = 200;
shingles = 4;
MinHashTitles = MinHashStrings(nFilms, dic2, shingles,nHF);

% Bloom Filter
n = 10000;
k =  round(n*log(2)/nFilms);
countingBF = Inicializar_FiltroBloom(n);

for i=1:nFilms
    array = Set{i};
    array(array(:,2) < 3,:) = []; %remover users que deram menos de 3
    for x = 1:length(array(:,2))
        countingBF = Adicionar_FiltroBloom(countingBF,i,k,n);
    end
end


save 'data.mat' Set dic nUsers dic2 nFilms MinHashUsers MinHashTitles MinHashInterests countingBF,
clear;
clc;

[Set, films] = create_structure('u.data');

dic = readcell('users.txt', 'Delimiter', ';');
nUsers = height(dic);

dic2 = readcell('film_info.txt', 'Delimiter', '\t');
nFilms = height(dic2);

% Cálculo do MinHash correspondente aos utilizadores 
nHF = 500;
MinHashUsers = MinHash(Set,nHF);

% Cálculo do MinHash correspondente aos interesses 
nHF = 200;
[Interests, sigInterests] = getInterests(nUsers,dic);

%MinHash Interesses
MinHashInterests = inf(nUsers, nHF);
x = waitbar(0,'A calcular MinHashInterests()...');
for k= 1 : nUsers
    waitbar(k/nUsers,x);
    interestsIdx = find(sigInterests(:, k));
    for j = 1:length(interestsIdx)
        chave = char(Interests{interestsIdx(j)});
        for i = 1:nHF
            chave = [chave num2str(i)];
            h(i) = DJB31MA(chave, 127);
        end
        MinHashInterests(k, :) = min([MinHashInterests(k, :); h]);
    end
end
delete(x);

% Cálculo do MinHash correspondente aos Titulos 
nHF = 100;
shingles = 4;
MinHashTitles = MinHashStrings(nFilms, dic2, shingles,nHF);

% Bloom Filter
n = 10000;
k = floor(n*log(2)/nFilms);
countingBF = Inicializar_FiltroBloom(n);

for i=1:nFilms
    for rate=1:size(Set{i},1)
        if Set{i}(rate,2) >= 3
            countingBF = Adicionar_FiltroBloom(countingBF,i,k,n);
        end
    end
end


save 'data.mat' Set dic nUsers dic2 nFilms MinHashUsers MinHashTitles MinHashInterests countingBF,
clear;
clc;

[Set, users] = create_structure('u.data');

dic = readcell('users.txt', 'Delimiter', ';');
nUsers = height(dic);

dic2 = readcell('film_info.txt', 'Delimiter', '\t');
nFilms = height(dic2);


% Cálculo do MinHash correspondente aos utilizadores 
nHF = 1000;
MinHashUsers = MinHash(Set,nHF);

% Cálculo do MinHash correspondente aos interesses 

% Cálculo do MinHash correspondente aos Titulos 
nHF = 100;
shingles = 4;
MinHashTitles = MinHashStrings(nFilms, dic2, shingles,nHF);

save 'data.mat' Set dic nUsers dic2 nFilms MinHashUsers MinHashTitles,
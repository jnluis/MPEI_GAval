clear;
clc;

load('data.mat');
filmID = 0;

while(filmID<1 || filmID>1682)
    filmID = input('Insert Film ID (1 to 1682): ');
    if (filmID<1 || filmID>1682)
        fprintf("ERROR: Enter a valid Film ID\n");
    end
end

menu = menu('Menu', ...
    '1 - Users that evaluated current movie', ...
    '2 - Suggestion of users to evaluate movie', ...
    '3 - Suggestion of users to based on common interests', ...
    '4 - Movies feedback based on populatrity', ...
    '5 - Exit');

while(menu ~= 5 && menu ~= 0)
    switch menu
        case 1
            fprintf('\nUsers who rate the movie "%s":\n',dic2{filmID});
            userIDs = Set{filmID};
            for i=1:length(userIDs)
                fprintf(" (ID: %3d) %s %s\n", userIDs(i), dic{userIDs(i),2}, dic{userIDs(i),3})
            end
        case 2
            nHF = 500;
            distance = zeros(nFilms, 1);
            for i = 1:nFilms
                if i ~= filmID
                    distance(i)=1-sum(MinHashUsers(filmID,:)==MinHashUsers(i,:))/nHF;
                else
                    distance(i) = 1;
                end
            end

            % ordena o array por ordem crescente
            [~, idx] = sort(distance, 'ascend');
            mostSimilar = idx(1:2); % vai buscar os dois primeiros que são os mais similares
            fprintf('\nThe two most similar films to film %d are %d and %d\n', filmID, mostSimilar);

            % Encontra os utilizadores que avalariam pelo menos um dos filmes similares  
            usersInfo = [];
            for i = 1 : length(mostSimilar)
                x = mostSimilar(i);
                c = setdiff(Set{x,:}, Set{filmID,:})';
                usersInfo = [usersInfo, c];
            end
            % Remove any duplicate recommendations.
            usersInfo = unique(usersInfo);
            % Print the titles of the recommended movies.
            fprintf('Users who rated one of the similar movies, but not the movie "%s":\n', dic2{filmID});
            for i = usersInfo
                fprintf(" (ID: %3d) %s %s\n", i, dic{i,2}, dic{i,3})
            end

        case 3
            userIDs = Set{filmID};
            threshold=0.9; % limiar da decisão para a Dist. de Jaccard
            SimilarUsersByInterest = SimilarInterests(MinHashInterests, userIDs, threshold);
            
%             % Queremos os 2 utilizadores que aparecem mais vezes
%             contagem=zeros(1, length(dic)); 
%             for i=1:length(SimilarUsersByInterest)
%                 conjunto=SimilarUsersByInterest{i};
%                 for j=1:length(conjunto)
%                     index=double(conjunto{j});
%                     contagem(index)=contagem(index)+1;
%                 end
%             end
%             [~, indexes]=sort(contagem, 'descend');
% 
%             fprintf("\nUsers with most common Sets\n")
%             % Como são só os primeiros 2, fazemos 2 prints em vez de um for
%             % é preciso ver o que vem nestes indexes
%             fprintf("%s\n", dic{Suggestion2Movies(1), 1})
%             fprintf("%s\n", dic{Suggestion2Movies(2), 1})
%             fprintf(" (ID: %5d) %s %s\n", userIDs(indexes), dic{indexes,2}, dic{indexes,3})
        case 4
        case 5
            break;
    end

    clear menu;
    menu = menu('Menu', ...
        '1 - Users that evaluated current movie', ...
        '2 - Suggestion of users to evaluate movie', ...
        '3 - Suggestion of users to based on common interests', ...
        '4 - Movies feedback based on populatrity', ...
        '5 - Exit');
end

%%
function Set = SimilarInterests(matriz, interesses, threshold)
    numInter=length(interesses);
    Set=cell(numInter, 1);
    for i=1:numInter
        Set{i}=mostSimilarUsersByInterest(interesses(i), interesses, matriz, threshold);
    end
end

function Set = mostSimilarUsersByInterest(interesse, moviesUser, matriz, threshold)
    Set={};
    k=1;
    [lines, col] = size(matriz);
    for n=1:lines % Aqui onde diz movie, não devia ser o Set gerado no .mat
        distJaccard=sum(matriz(movie, :)~=matriz(n, :))/col;
        if distJaccard<threshold && n~=movie % distância de Jaccard inferior e o não ter avaliado o filme atual 
            if find(moviesUser == n)
                continue;
                %se o filme estiver nos avaliados pelo user atual, n faz nada
            else
                Set{k}=n;
                k=k+1;
            end
        end
    end
end
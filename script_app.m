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
                fprintf(" (ID: %d) %s %s\n", userIDs(i), dic{userIDs(i),2}, dic{userIDs(i),3})
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

            usersInfo = unique(usersInfo);

            fprintf('Users who rated one of the similar movies, but not the movie "%s":\n', dic2{filmID});
            for i = usersInfo
                fprintf(" (ID: %d) %s %s\n", i, dic{i,2}, dic{i,3})
            end

        case 3
            userIDs = Set{filmID};
            threshold=0.9; % limiar da decisão para a Dist. de Jaccard
            nHF = 100;
            conjunto = [];
            count = 1;
            for i= 1:length(userIDs)
                n1 = userIDs(i);  
                for n2=1:nUsers
                    if ~ismember(n2, Set{filmID}) % se o utilizador não viu o filme atual é feito o cálculo da distância
                        distanceInterests = 1-sum(MinHashInterests(n1,:)==MinHashInterests(n2,:))/nHF;
                        if distanceInterests<threshold 
                            conjunto(count, 1) = n1;
                            conjunto(count, 2) = n2;
                            count = count + 1;
                        end
                    end
                end
            end

            %Contar quantas vezes aparecem cada user que ainda não viu o filme
            conjuntoUnique = unique(conjunto(:,2));
            counts = zeros(length(conjuntoUnique),2);

            for i=1:length(conjuntoUnique)
                u = conjuntoUnique(i);
                count = 0;
                for x=1:length(conjunto(:,2))
                    c = conjunto(x,2);
                    if c == u
                        count = count +1;
                    end
                end
                counts(i,1) = u;
                counts(i,2) = count;
            end
            
            counts = sortrows(counts, 2, "descend");

            mostCommon = counts(1:2); % vai buscar os dois primeiros que são os mais similares
            fprintf('\nThe two users who appear in more sets are:\n');
            for i = mostCommon
                fprintf(" (ID: %d) %s %s\n", i, dic{i,2}, dic{i,3})
            end

        case 4
            
    end

    clear menu;
    menu = menu('Menu', ...
        '1 - Users that evaluated current movie', ...
        '2 - Suggestion of users to evaluate movie', ...
        '3 - Suggestion of users to based on common interests', ...
        '4 - Movies feedback based on populatrity', ...
        '5 - Exit');
end
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
            % Remove any duplicate recommendations.
            usersInfo = unique(usersInfo);
            % Print the titles of the recommended movies.
            fprintf('Users who rated one of the similar movies, but not the movie "%s":\n', dic2{filmID});
            for i = usersInfo
                fprintf(" (ID: %d) %s %s\n", i, dic{1,2}, dic{i,3})
            end

        case 3


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

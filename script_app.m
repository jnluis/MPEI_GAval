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
            fprintf("\nOption 1 - \n")
            fprintf('Users who rate the movie "%s":\n',dic2{filmID});
            userIDs = Set{filmID};
            for i=1:length(userIDs)
                fprintf(" (ID: %3d) %s %s\n", userIDs(i), dic{userIDs(i),2}, dic{userIDs(i),3})
            end
        case 2
            fprintf("\nOption 2 - \n")
            nHF = 1000;
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
            fprintf('The two most similar films to film %d are %d and %d\n', filmID, mostSimilar);

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
                fprintf(" (ID: %3d) %s %s\n", i, dic{i,2}, dic{i,3})
            end

        case 3
            fprintf("\nOption 3 - \n")
            userIDs = Set{filmID};
            threshold=0.9; % limiar da decisão para a Dist. de Jaccard
            nHF = 200;
            conjunto = zeros(nUsers,3);
            count = 1;
            disp('Loading data, please wait...')
            for i= 1:length(userIDs)
                n1 = userIDs(i);  
                for n2=1:nUsers
                    if ~ismember(n2, userIDs(:,1)) 
                        distanceInterests = 1-sum(MinHashInterests(n1,:)==MinHashInterests(n2,:))/nHF;
                        if distanceInterests<threshold 
                            conjunto(count, 1) = n1;
                            conjunto(count, 2) = n2;
                            conjunto(count, 3) = distanceInterests;
                            count = count + 1;
                        end
                    end
                end
            end
            disp('Data loaded')
            %Contar quantas vezes aparecem cada user que ainda não viu o filme

            conjuntoUnique = unique(conjunto(:,2));
            counts = zeros(length(conjuntoUnique),2);
            for i=1:length(conjuntoUnique)
                u = conjuntoUnique(i);
                count = 0;
                dist = 1;
                for x=1:length(conjunto(:,2))
                    c = conjunto(x,2);
                    if c == u
                        count = count +1;
                        if dist > conjunto(x,3)
                            dist = conjunto(x,3); % guardar a menor distância
                        end
                    end
                end
                counts(i,1) = u;
                counts(i,2) = count;
                counts(i,3) = dist;

            end
            
            counts = sortrows(counts, [-2, 3]); 

            mostCommon = counts(1:2); 
            fprintf('The two users who appear in more sets are:\n');
            for i = mostCommon
                fprintf(" (ID: %3d) %s %s\n", i, dic{i,2}, dic{i,3})
            end

        case 4
            fprintf("\nOption 4 - \n")
            string = lower(input('Write a string: ','s'));
            shingle = 4;
            nHF = 200;
            MinHashString = Function_MinHashString(string, shingle,nHF);
            distanceFilms = zeros(nFilms, 1);
            for i = 1:nFilms
                distanceFilms(i)=1-sum(MinHashString(1,:)==MinHashTitles(i,:))/nHF;
            end

            [~, idx] = sort(distanceFilms, 'ascend');

            fprintf("Suggested Movies: \n")
            mostSimilar = idx(1:3); 
            n = 10000;
            k = round(n*log(2)/nFilms);

            for i=1:length(mostSimilar)
                x=mostSimilar(i);
                count = Membro_FiltroBloom(countingBF,mostSimilar(i),k,n);
                fprintf(" (ID: %3d) %s -  Nº. of times it was rated >= 3: %d \n", x, dic2{x},count)
            end
    end

    clear menu;
    menu = menu('Menu', ...
        '1 - Users that evaluated current movie', ...
        '2 - Suggestion of users to evaluate movie', ...
        '3 - Suggestion of users to based on common interests', ...
        '4 - Movies feedback based on populatrity', ...
        '5 - Exit');
end

%% Funções
function MinHashString = Function_MinHashString(string, shingle,nhf)
    MinHashString=inf(1,nhf);
    for j=1:length(string)-shingle+1
        shingles=string(j:j+shingle-1);
        h=zeros(1,nhf);
        for m=1:nhf
            shingles=[shingles num2str(m)];
            h(m)=DJB31MA(shingles,127);
        end
        MinHashString(1,:)=min(MinHashString(1,:),h);
    end
end
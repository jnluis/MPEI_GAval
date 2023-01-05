clear;
clc;

load('data.mat');
filmID = 0;

while(filmID<1 || filmID>943)
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
            fprintf("\nUsers who rate the movie:\n");
            for i=1:nUsers
                if find(filmID,Set{i})
                    fprintf(" (ID: %d) %s %s\n", i, dic{i,2}, dic{i,3})
                end
            end


        case 2

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

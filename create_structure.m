function [Set, films] = create_structure(ficheiro)
udata=load(ficheiro); % Carrega o ficheiro dos dados dos filmes
u = udata(1:end,1:3); clear udata;

% Lista de utilizadores
films = unique(u(:,2));
nFilms= length(films);

Set= cell(nFilms,1);

for n = 1:nFilms
    ind = find(u(:,2) == films(n));
    Set{n} = [Set{n} u(ind,1) u(ind,3)];
end
end
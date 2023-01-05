function [Set, users] = create_structure(ficheiro)
udata=load(ficheiro); % Carrega o ficheiro dos dados dos filmes
u = udata(1:end,1:2); clear udata;

% Lista de utilizadores
users = unique(u(:,1));
Nu = length(users);

Set= cell(Nu,1);

for n = 1:Nu
    ind = find(u(:,1) == users(n));
    Set{n} = [Set{n} u(ind,2)];
end
end
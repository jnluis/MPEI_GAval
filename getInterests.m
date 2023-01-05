function [Interests, sigInterests] = getInterests(nUsers,users)

Interests = {};
k = 1;

for i= 1:nUsers
    for j= 4:17
        if ~anymissing(users{i,j}) 
            Interests{k} = users{i,j};
            k = k+1;
        end
    end
end

Interests = unique(Interests);

nInterests = length(Interests);
sigInterests = zeros(nInterests,height(users)); %matriz de assinaturas

for i= 1:nInterests
    for n= 1:nUsers
        for k= 4:17
            if ~anymissing(users{n,k})
                if strcmp(Interests(i),users{n,k})
                    sigInterests(i,n) = 1;
                end
            end
        end
    end
end

end
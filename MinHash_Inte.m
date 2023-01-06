function MinHashInterests = MinHash_Inte(sigInterests,Interests, nHF, nUsers)
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
end


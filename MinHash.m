function signatures = MinHash(Set,numHash)

nfilms = length(Set);   
signatures = Inf(nfilms,numHash);  
h = waitbar(0,'Calculating MinHash');

tic
for i = 1:nfilms
    waitbar(i/nfilms,h);
    nUsers = length(Set{i}); 
    for j = 1:nUsers
        key = num2str(Set{i}(j));
        hash = DJB31MA_Modified(key,127,numHash);
        signatures(i,:) = min(hash,signatures(i,:));
    end
end
delete (h)

end


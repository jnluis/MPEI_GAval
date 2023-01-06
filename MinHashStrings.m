function MinHashString = MinHashStrings(n,dic,shingles,hf)

MinHashString=inf(n,hf);

x = waitbar(0,'Calculating MinHashString');
for n1=1:n
    waitbar(n1/n,x);
    string=lower(dic{n1,1});
    for n2=1:length(string)-shingles+1
        shingle=string(n2:n2+shingles-1);
        h=zeros(1,hf);
        for i=1:hf
            shingle=[shingle num2str(i)];
            h(i)=DJB31MA(shingle,127);
        end
        MinHashString(n1,:)=min([MinHashString(n1,:);h]);
    end
end
delete(x);
end
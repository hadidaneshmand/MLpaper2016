function omat = rndwalk_nobalance(mat,nodenum,edgnum)
edgi = 1; 
n = size(mat,1);
i = randi(n); 
omat = sparse(n,n);
seno = [];
while(true)
    if(size(seno,1)>=nodenum)
       break;  
    end
    inds = find(mat(i,:)~=0 & omat(i,:)==0);
    if(size(inds,2) == 0)
       i = randi(n);
       continue;
    end
    rind = randi(size(inds,2)); 
    j = inds(rind); 
    omat(i,j) = mat(i,j);
    edgi = edgi + 1;
    if(isempty(find(seno==i)))
       seno = [seno;i];
    end
    i = j;
end 
tmat = mat(seno,seno); 
edges = find(tmat~=0);
ned = length(edges);
rind = randi(ned,edgnum,1);
omat = sparse(size(tmat,1),size(tmat,2));
omat(edges(rind))=tmat(edges(rind));
end
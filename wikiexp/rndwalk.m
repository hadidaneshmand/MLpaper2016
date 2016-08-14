function omat = rndwalk(mat,edgepr)
[x ,~] = find(mat~=0); 
tedg = size(x,1);
edgi = 1; 
n = size(mat,1);
i = randi(n); 
m = floor(tedg*edgepr);
omat = sparse(n,n);
while(true)
    if(edgi>m)
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
    i = j;
end
rol = any(omat) & any(omat'); 
omat = omat(rol,rol); 
end
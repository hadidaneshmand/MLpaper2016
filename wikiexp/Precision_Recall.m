function [ P,R] = Precision_Recall( A,A_hat)

n = size(A,4);
P = cell(n,1);
R = cell(n,1);
for k=1:n
    edges=find(A(:,:,1,k)~=0);
    edgesi = size(edges,1);
    khat = A_hat(:,:,1,k);
    kedg = khat(edges);
    [sval,sind] = sort(kedg); 
    pr = [];
    rc = [];
    ss = size(sval,1);
    for i=1:ss
        min_tol = sval(i);
        nf = sum(sum(A_hat(:,:,1,k)>min_tol));
        ns = ss-i;
        pr = [pr;ns/nf];
        rc = [rc;ns/ss];
    end
    P{k,1} = pr;
    R{k,1} = rc;
end

end


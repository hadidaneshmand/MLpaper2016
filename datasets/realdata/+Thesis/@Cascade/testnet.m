function [out prob] = testnet( cas,net )
%TESTNET This method test structure of learning network (net input) base on cascade
%test sequence (cas.tseq attribute) 
    teseq = cas.tseq;%test sequence.
    leseq = cas.seq;%learn sequence.
    testimes = unique(teseq(:,1)); 
    out = zeros(1,cas.t);
    s = zeros(1,cas.t);
    ti = testimes(end);
    ts = testimes(1);
    gind = find(ts-leseq(:,1)>cas.T1 & ts-leseq(:,1)<cas.T2); 
    tjs = leseq(gind,1); js = leseq(gind,2); kjs = leseq(gind,3); 
    sij = size(tjs,1);
    S = 1; 
    H = 0;
    for j=1:sij
       delta = ti - tjs(j); 
       omat = ones(size(net(js(j),:,kjs(j),:)));
       omat = reshape(omat,[cas.m,cas.t]);
       X = delta*omat;
       alpha = net(js(j),:,kjs(j),:);
       alpha = reshape(alpha,[cas.m,cas.t]);
       sj = cas.dist.survival(X,alpha);
       S = S.*sj; 
       t1 = (ts-tjs(j)).*omat;t2 = (ti-tjs(j)).*omat;
       Fj = cas.dist.getcdf(t2,alpha) - cas.dist.getcdf(t1,alpha);
       Hj = Fj./sj;
       H = H + Hj; 
    end
    P = H.*S;
    P(js,:) = 0;
    for k=1:cas.t
        [SF,mind] = sort(P(:,k),'descend');
        tkind = find(teseq(:,3) == k); 
        if(size(tkind,1) ==0)
           continue; 
        end
        display('------------');
        display(size(mind));
        display(size(tkind,1));
        mind = mind(1:size(tkind,1));
        out(k) = out(k) + size(intersect(teseq(tkind,2),mind),1);
        s(k) = s(k) + size(tkind,1);
    end
    out = out ./s;
    prob = P;
end


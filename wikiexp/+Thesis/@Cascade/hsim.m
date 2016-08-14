function ocas = hsim(icas,net,endtime)
%Simulate hard cascade on a given network.
    ocas = icas; 
    ocas.m = size(net,1);
    ocas.t = size(net,3);
    cas.seq = cell(endtime,1);
    for i=1:endtime
        display(sprintf('simulation %dth',i));
        sc = 1;
        rind = randi(ocas.m,[1,1]); 
        rty = randi(ocas.t,[1,1]);
        curts = 1*ones([1,1]);
        seq = [curts,rind,rty];
        imat = zeros(ocas.m,1);
        imat(rind) = 1;
        while(true)
            seqsi = size(seq,1);
            if(sc>seqsi)
               ocas.seq{i,1} = sortrows(seq,1);
               break;
            end
            rt = seq(sc,1);r = seq(sc,2);rk = seq(sc,3);
            nmat = reshape(net(r,:,rk,:),[ocas.m,ocas.t]);
            nt = ocas.dist.genrand(nmat);
            if(ocas.t>1)
                [nt,ks]= min(nt');
            else
                nt = nt';
                ks = ones(size(nt));
            end
           
            nt = nt + rt;
            inwin = find(nt<ocas.w );
            inds=find(imat(inwin) == 0);
            inwin = inwin(inds);
            if(isempty(inwin))
                sc = sc + 1; 
                continue;
            end
            nt = nt(inwin);ks = ks(inwin); 
            nseq = [nt',inwin',ks'];
            imat(inwin) = 1;
            seq = [seq;nseq];
        end
    end
end


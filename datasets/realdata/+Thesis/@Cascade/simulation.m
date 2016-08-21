function ocas = simulation(cas,net,casnum)
%Simulate cascade on a given network.
    ocas = cas; 
    ocas.m = size(net,1);
    ocas.t = size(net,3);
    
    ocas.seq = cell(casnum,1);
    for count=1:casnum
        display(sprintf('cascade %dth',count));
        imat = zeros(cas.m,1);
        rind = randi(ocas.m,1); 
        rty = randi(ocas.t,1);
        seq = [0,rind,rty];
        imat(rind) = 1;
        sti = 1;
        while(true)
            seqsi = size(seq,1);
            if(sti > seqsi)
                seq = sortrows(seq,1);
                ocas.seq{count} = seq;
                break;
            end 
            i = seq(sti,2);ik = seq(sti,3);ti = seq(sti,1);
            inds = find(net(i,:,ik,:)>0);
            [rs cs] = ind2sub([ocas.m,ocas.t],inds);
            if(size(rs,1) == 0)
                sti = sti + 1;
               continue; 
            end
            rnum = randi(size(rs,1));
            j = rs(rnum);kj = cs(rnum);tj = ocas.dist.genrand(net(i,j,ik,kj));
            tj = ti + tj;
            if(imat(j) == 1 || tj>cas.w)
               sti = sti + 1; 
               continue; 
            end
            nseq = [tj,j,kj];
            imat(j) = 1;
            seq = [seq;nseq];
            sti = sti + 1;
        end
    end
end


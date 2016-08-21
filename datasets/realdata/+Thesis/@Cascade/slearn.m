%Learning cascade paramters
function onet = slearn(cas)
%Optimization 
    d1 = cas.m;d2 = d1;d3 = 2;
    net = zeros(d1,d2,d3);
    total = 0;
    for i=1:d1
        [Si,Hi] = cas.shs(i);
        scom = false;
        hcom = false;
        display(sprintf('column %d from %d is optimizing ...',i,d1));
        cvx_begin 
            variable A(d2*d3);
            if(size(Si,1)~=0)
               st = -1*sum(A(Si(:,1)).*Si(:,2));
               scom = true;
            end
            for j=1:size(Hi,1)
               hs = Hi{j};
               if(size(hs,2)== 2)
                   ht = sum(A(hs(:,1)).*hs(:,2));
                   st = st + log(ht);
                   hcom = true;
               end
            end
            if(hcom && scom) 
                maximize(st)
                subject to 
                        A >= 0;
            end      
        cvx_end
        total = total + st;
        net(:,i,:) = reshape(A,[d2,d3]);
        save('out/net','net');
%         if(mod(i,100)==1)
%            a1 = Ain(:,1:i,1,1); 
%            a2 = net(:,1:i,2);
%            b1 = Ain(:,1:i,1,2); 
%            b2 = net(:,1:i,1);
%            R(1,1) = sum(a1(:)>0 & a2(:)>.3)/sum(a1(:)>0);
%            R(1,2) = sum(a1(:)>0 & a2(:)>.3)/sum(a2(:)>.3);
%            R(2,1) = sum(b1(:)>0 & b2(:)>.3)/sum(b1(:)>0);
%            R(2,2) = sum(b1(:)>0 & b2(:)>.3)/sum(b2(:)>.3);
%            save('out/R','R');
%            save('out/i','i');
%         end
    end
    exto = exp(total);
    save('out/net','net');
    onet(:,:,1,1) = net(:,:,2); 
    onet(:,:,1,2) = net(:,:,1); 
    onet(:,:,2,2) = onet(:,:,1,1); 
    onet(:,:,2,1) = onet(:,:,1,2); 
    display(exto);
end
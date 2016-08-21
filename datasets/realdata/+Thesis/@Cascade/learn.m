%Learning cascade paramters
function net = learn(cas,from,to)
   %Optimization 
pathdef;
d1 = cas.m;d2 = to-from+1;d3 = cas.t;d4 = d3;
net = zeros(d1,d2,d3,d4);
total = 0; 
cas_num = size(cas.seq,1);
for i=from:to
    display(sprintf('column %d from %d is (from %d to %d) ...',i,d1,from,to));
    display('hs finding');
    [Si,Hi] = cas.hscoffi(i);
    display('optimizing');
    scom = false;
    hcom = false;
    cs = size(Hi,1);
    cvx_begin 
        variable A(d1*d3*d4);
        variable ht(cs);
        st = 0;
        if(size(Si,1)~=0)
           st = -1*sum(A(Si(:,1)).*Si(:,2));
           scom = true;
        end
        for j=1:size(Hi,1)
           hs = Hi{j};
           if(size(hs,2)== 2)
               if(strcmp(cas.dist.getname(),'exp') == 0)
                    ht(j) <= sum(A(hs(:,1)).*hs(:,2));
               else 
                   ht(j) == sum(A(hs(:,1)).*hs(:,2));
               end 
               st = st + log(ht(j));
               hcom = true;
           end
        end
        B = reshape(A,[d1,d3,d4]);
        if(hcom && scom) 
            maximize(st)
            subject to 
                    A >= 0;
                    B(:,1,1) == B(:,2,2);
                    B(:,1,2) == B(:,2,1);
        end      
    cvx_end
    total = total + st;
    net(:,i-from+1,:,:) = reshape(A,[cas.m,cas.t,cas.t]);
    save('out/net','net');
    save('out/i','i');
end
display(total);
end
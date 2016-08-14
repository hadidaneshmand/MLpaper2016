addpath('/cluster/home/dhadi/cvx')
cvx_setup
casnum = 2000;
%GRAPH CONSTRUCTION
types = 'wikinet-exp'; 

net =  load('wikinet');
net = net.m;
%EFFECT NETWORK GENERATING
nodenum = size(net,1);
posn = size(find(net>0),1);
negn = size(find(net<0),1);
win = 15;
d1 = size(net,1);d2 = d1;d3 = 2;d4 = d3;
A = zeros(d1,d2,d3,d4);
net = full(net);
 A(:,:,1,1) = net >0;
A(:,:,2,2) = A(:,:,1,1); 
A(:,:,1,2) = net < 0; 
A(:,:,2,1) = A(:,:,1,2); 
noise = (rand(size(A))-0.5).*(A>0);
A = A + noise;
cas = Thesis.Cascade(size(A,1),2,win,Thesis.Distribution.EXPD());
chart = sprintf('NB_%s(%d N - %d NE - %d PE - %d W - %d C - %s )',types,nodenum,negn,posn,win,casnum,cas.dist.getname());
save('out/chart','chart');
display('chart');
%CASCADE SIMULATION
display('Cascade simulating');
cas = cas.hsim(A,casnum);
save('out/cas_NB','cas');
save('out/A_NB','A');
%LEARNING 
display('learning');
t1 = cputime;
A_hat = cas.slearn(A);
t2 = cputime; 
delta = t2-t1; 
save('out/delta','delta');
%EVAL --------------
[ P,R]= Precision_Recall(A,A_hat);
fi = figure;
for k=1:size(P,1)    
    if(k==1)
        plot(R{k,1},P{k,1},'DisplayName','Positive','Color','r');
    elseif(k==2)
        plot(R{k,1},P{k,1},'DisplayName','Negative','Color','b');
    else
        plot(R{k,1},P{k,1},'DisplayName',sprintf('Type %d',k));
    end
    
    hold on;
end
xlabel('Recall')
ylabel('Precision')
title(sprintf('%s :Precision VS. Recall',types));
legend('Positive','Negative');
print(fi,'-djpeg',sprintf('NB_Edges_Precision_Recall_%s',chart));
min_tol = 0.01;
mae = mean(abs(A_hat(A>min_tol)-A(A>min_tol))./A(A>min_tol)); 
save('NB_mae','mae');
save(sprintf('A_hat_NB_%s',chart),'A_hat');


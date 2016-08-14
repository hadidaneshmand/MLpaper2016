function evp(A,A_hat,fnam,chart)
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
title(sprintf('%s :Precision VS. Recall',fnam));
legend('Positive','Negative');
print(fi,'-djpeg',sprintf('charts/Edges_Precision_Recall_%s',chart));
save(sprintf('out/A_%s',chart),'A');
save(sprintf('out/A_hat_%s',chart),'A_hat');
end
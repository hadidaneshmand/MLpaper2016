
function [given predict] = splite( cas ,samnum)
%SPLITE sequence to given and predict set for testing
 seq = cas.seq;
 init = seq(1,1); 
 given = {};
 predict = {};
 i =1 ;
 while(i<samnum)
     gind = find(seq(:,1)-init>cas.T1 & seq(:,1)-init<cas.T2);
     if(size(gind,1) <2)
        break; 
     end
     et = seq(gind(end),1);
     pind = find(seq(:,1)> et -.5 & seq(:,1)<et+.5);
     given = vertcat(given,{seq(gind,:)});
     predict = vertcat(predict,{seq(pind,:)});
     if(pind(end)+1>size(seq,1))
        break; 
     end
     init = init + 1;
     i = i+1;
 end
end


function out = BarabasiAlbert( m0,m,n )
    out = zeros(n,n);
    for i=1:1:m0
       out(i,rotate(i+1,m0)) = 1;
       out(i,rotate(i-1,m0)) = 1; 
    end
    out = max(out,out');
    for i=m0+1:1:n
       [row col val] = find(out); 
       [temsize ~] = size(row); 
       for j=1:m
           ra = randi(temsize); 
           out(i,row(ra)) = 1; 
           out(row(ra),i) = 1;
       end
    end
end
function out = rotate(a,b)
    if(a>b)
       out = a - b;
    elseif(a<1)
       out = b + a; 
    else 
        out = a;
    end
   
end


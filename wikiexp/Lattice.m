function out = Lattice( n , k )
    out = zeros(n,n); 
    for i=1:1:n 
        for j=1:1:(k/2)
            out(i,rotate(i+j,n)) = 1; 
            out(i,rotate(i-j,n)) = 1; 
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

function [ out ] = WattsStrogatz( n,k,p )
 lat = Lattice(n,k); 
 out = zeros(n,n); 
 for i=1:1:n
     for j=1:1:n
        if(lat(i,j) == 1)
           r = randi(100);
           if( r < 100*p)
               rver = randi(n); 
               if(lat(i,rver)~=1 && rver ~=i)
                  out(i,rver) = 1;
               else 
                  out(i,j) = 1;  
               end
           else 
               out(i,j) = 1;
           end
        end
     end
 end
end


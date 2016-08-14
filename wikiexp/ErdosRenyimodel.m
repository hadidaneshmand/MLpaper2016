function graph = ErdosRenyimodel( n, p)
    graph = zeros(n,n);
    for i=1:1:n
       for j=i+1:1:n
           r = randi(n);
           if(r<n*p)
              graph(i,j) = 1;  
           end
       end
    end
    graph = max(graph,graph');
end


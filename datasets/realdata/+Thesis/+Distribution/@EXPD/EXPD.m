classdef EXPD < Thesis.Distribution.Dist
    %EXPD Summary of this class goes here
    %   Detailed explanation goes here

    
    methods
        function out = getname(inD)
           out = 'exp'; 
        end
        function out = getScof(inD,tj,ti)
           out = tj-ti; 
        end
        function out = getHcof(inD,ti,tj)
           t1 = size(ti);
           t2 = size(tj);
           out = ones(max(t1,t2));
        end
        function out = genrand(inD,alpha,dim)
            out = exprnd(1./alpha);
        end
        function out = getpdf(inD,X,alpha)
           alpha = alpha + 0.000001;
           out = exppdf(X,1./alpha);
           out = out.*(out>0.000001);
        end
        function out = getcdf(inD,X,alpha)
           alpha = alpha +0.000001;
           out = expcdf(X,1./alpha);
        end
    end
    
end


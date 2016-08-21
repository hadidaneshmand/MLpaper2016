classdef RAY < Thesis.Distribution.Dist
    %EXPD Summary of this class goes here
    %   Detailed explanation goes here

    
    methods
        function out = getname(inD)
           out = 'ray'; 
        end
        function out = getScof(inD,tj,ti)
           out = ((tj-ti).^2)./2; 
        end
        function out = getHcof(inD,ti,tj)
           out = (ti-tj);
        end
        function out = genrand(inD,alpha,dim)
            out = raylrnd(1./alpha);
        end
        function out = getpdf(inD,X,alpha)
           alpha = alpha + 0.000001;
           out = raylpdf(X,1./alpha);
           out = out.*(out>0.000001);
        end
        function out = getcdf(inD,X,alpha)
           alpha = alpha +0.000001;
           out = raylcdf(X,1./alpha);
        end
    end
    
end


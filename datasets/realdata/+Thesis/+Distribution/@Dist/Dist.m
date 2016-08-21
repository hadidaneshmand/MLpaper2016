classdef Dist
    
   methods (Abstract)
        out = getname(inD);
        out = getScof(inD,ti,tj); 
        out = getHcof(inD,ti,tj);
        out = genrand(inD,alpha);
        out = getpdf(inD,X,alpha);
        out = getcdf(inD,X,alpha);
    end
   methods
       function out = survival(inD,X,alpha)
          out = 1- inD.getcdf(X,alpha); 
       end
       function out = hazard(inD,X,alpha)
          out = inD.getpdf(X,alpha)./inD.survival(X,alpha);
       end
   end
end


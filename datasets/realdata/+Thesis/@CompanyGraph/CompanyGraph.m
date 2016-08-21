classdef CompanyGraph
    %COMPANYGRAPH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        adjmat;
        ids;
    end
    
    methods
        %make adj matrix based on correlation matrix and parameter alpha
        %that is cofficient on variance of correlations.
        function out = makeadj(in,corrmat,alpha)
            out = in ; 
            corrvar = var(corrmat(:));
            corrmean = mean(corrmat(:));
            n = size(corrmat,1);
            out.adjmat = zeros(n,n);
            for i=1:n
                for j=1:n
                    if(corrmat(i,j)-corrmean>alpha*corrvar)
                        out.adjmat(i,j) = 1;
                    elseif(corrmat(i,j)-corrmean<-alpha*corrvar)
                       out.adjmat(i,j) = -1; 
                    end
                end    
            end
        end
        function csave(in)
            adjmat = in.adjmat;
            ids = in.ids;
            save('graph','adjmat','ids');
        end
    end
    methods(Static)
        function out = cload()
            out = Thesis.CompanyGraph(); 
            ldata = load('graph'); 
            out.adjmat = ldata.adjmat; 
            out.ids = ldata.ids;
        end
    end
    
end


classdef Cascade
    %This calss is a representation for cascades in companies
    
    properties
       %Cell of array that each array is n*3 sequence 
       %first col is time, second companynum, 3th cascade type.
       seq;
       %is same as seq but it used for testing 
       tseq;
       %If debug be true some plots and prints can help to debug
       debug;  
       %number of companies
       m;
       %number of types
       t;
       %distribution
       dist;
       %window size
       w;
    end
    
    methods
        function out = Cascade(m,t,w,dist)
            out.m = m; 
            out.t = t;
            out.w = w;
            out.debug = false;
            out.dist = dist;
        end
       
        
    end
end


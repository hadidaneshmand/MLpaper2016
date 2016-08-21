classdef Mdate
    %MDATE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods(Static)
        function out = str2id(str)
           out=sscanf(str,'%f-%f-%f'); 
           y = out(1);
           m = out(2); 
           d = out(3); 
           out = (y-1380)*365; 
           if(m>6)
              out = out + 6*31+(m-7)*30;
           else
              out = out + 31*(m-1);
           end
           out = out + d; 
        end
    end
    
end


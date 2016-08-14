classdef CompanyMatrix
    %This class is a container for company ids and their raw statistics
    %such as closeprice 
     properties
        %close prices matrix that each row contains each company close
        %price for 10 years. 
        closeprmat;
        %A colemn vector of company ids 
        comid;

    end
    
    methods
        %Making close price matrix for all companies (input is base on
        %xls input data)
        function out = MKclosepr(in,ids,closeprs,strdates)
           out = in; 
           [out.comid,~,indexs] = unique(ids); 
           out.closeprmat = zeros(size(out.comid,1),4133); 
           for i=1:size(indexs,1)
               dateid = Thesis.Mdate.str2id(strdates{i}); 
               out.closeprmat(indexs(i),dateid) = closeprs(i);
           end
        end
        %save file data in a file.
        function msave(in)
           mat = in.closeprmat;
           id = in.comid;
           save('compMat','mat','id');
        end
        % compute defference between each day close price with perviouse
        % day close price expecte start day of an interval and intravals
        % that price is closed.
        function outmat = closedelta(in)
            outmat = zeros(size(in.closeprmat));
            for j=1:size(in.closeprmat,1)
                for i=2:size(in.closeprmat,2)
                    if(in.closeprmat(j,i)~=0 && in.closeprmat(j,i-1)~=0)
                        outmat(j,i) = in.closeprmat(j,i)-in.closeprmat(j,i-1);
                    end
                end
            end
        end
        %Removes holidaies from matrix.
        function outcomp = removehollyday(incomp)
            outcomp = incomp;
            maxcols = max(incomp.closeprmat); 
            ind = find(maxcols ~= 0); 
            outcomp.closeprmat = incomp.closeprmat(:,ind);
        end
        %Remove <= 10 days previous days price
        function outcomp = smoothing(incomp,smoothrate)
            zeroindex = 0; 
            outcomp = incomp;
            for i=1:size(incomp.closeprmat,1)
               for j=2:size(outcomp.closeprmat,2)
                   if(outcomp.closeprmat(i,j) == 0 && zeroindex<smoothrate)
                       zeroindex = zeroindex + 1; 
                       outcomp.closeprmat(i,j) = outcomp.closeprmat(i,j-1);
                   else 
                       zeroindex = 0;
                   end              
               end
            end
        end
        %Remove company that are zero in more than percent that is given over given
        %interval (fromdatestr, todatestr).
        function outclass = companydatefilter(inclass,fromdatestr,todatestr,precent)
            fromdateid = Thesis.Mdate.str2id(fromdatestr); 
            todateid = Thesis.Mdate.str2id(todatestr);
            interval = todateid - fromdateid;
            n = size(inclass.closeprmat,1); 
            outclass = Thesis.CompanyMatrix();
            outclass.comid = []; 
            outclass.closeprmat = [];
            for i=1:n
                closeinv = inclass.closeprmat(i,fromdateid:todateid);
                zeroprec = size(find(closeinv==0),2)/interval; 
                if(zeroprec < precent)
                    outclass.comid = [outclass.comid;inclass.comid(i)];
                    outclass.closeprmat = [outclass.closeprmat;inclass.closeprmat(i,fromdateid:todateid)];
                end
            end
        end
        %Move averge filter on rows of closepr matrix hisnum is number of
        %past history for averaging. 
        function outobj = moveaverage(inobj,hisnum)
           n = size(inobj.closeprmat,1); 
           B = ones(1,hisnum);
           outobj = inobj;
           for i=1:n
              outobj.closeprmat(i,:) = filter(B,1,inobj.closeprmat(i,:));
           end
        end
        %Extracting cascade matrix if current value is > param*variance.
        function [outcas comid] = extractmat(company,param,smoothrate)
           delta = company.closedelta();
           outcas = zeros(size(delta));
           comid = [];
            B = ones(1,20);
            n = size(company.closeprmat,1); 
            m = size(company.closeprmat,2);
            outindex = 1;
            for i=1:n
               row = delta(i,:);
               row(row == Inf) = 0;
               row = filter(B,1,row);
               ind = find(row>0);
               rowvar = sqrt(var(row(ind)));
               rowmean = mean(row(ind));
               outcas(outindex,find(delta(i,:)>rowvar*param)) = 1;
               outcas(outindex,find(delta(i,:)<-1*rowvar*param)) = 2;
               preone = 0;
               index =0;
               for j=1:m
                  if(outcas(outindex,j) ~=0 && preone == 0)
                      preone =1;
                  elseif(outcas(outindex,j)~=0 && preone ==1)
                      outcas(outindex,j)=0;  
                      index = index +1;
                  elseif(outcas(outindex,j)==0 && preone ==1)
                      index = index +1; 
                      if(index>smoothrate)
                          preone = 0;
                          index  = 0;
                      end
                  end
               end
%                figure;
%                plot(delta(i,:));
%                hold on;
%                plot(rowvar*param*ones(1,m));
%                hold on; 
%                plot(-1*rowvar*param*ones(1,m));
%                figure;
%                plot(outcas(i,:));
%                figure;
%                plot(company.closeprmat(i,:));
                if(size(find(outcas(outindex,:)>0),2)>5)
                    outindex = outindex +1;
                    comid = [comid;company.comid(i)];
                end
            end
            outcas = outcas(1:outindex-1,:);
       end 
       
    end
    methods(Static)
        %load data from file
        function out = mload()
           out = Thesis.CompanyMatrix();
           ldata = load('compMat');
           out.closeprmat = ldata.mat;
           out.comid = ldata.id;
        end
    end
    
end


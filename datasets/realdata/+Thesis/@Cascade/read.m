function outc = read( inc,fname )
    outc = inc; 
    fi = fopen(fname); 
    lines = textscan(fi,'%s','Delimiter','\n','BufSize',10095);
    lines = lines{1,1};
    outc.ids = [];
    outc.seq = cell(size(lines,1),1);
    for i=1:size(lines,1)
       cascade =  textscan(lines{i,1},'%s','Delimiter','-');
       cascade = cascade{1,1}; 
       casarr = [];
       for j=1:size(cascade,1)
           caselem = textscan(cascade{j,1},'%f','Delimiter',','); 
           caselem = caselem{1,1};
           if(size(caselem,1)~=3)
              continue; 
           end
           res = find(outc.ids==caselem(2,1));
           if(~isempty(res))
               compid = res(1,1);
           else 
               compid = size(outc.ids,2)+1;
               outc.ids = [outc.ids,caselem(2,1)];           
           end
           

           %time+company+type
           casarr = [casarr;caselem(1,1)/1000,compid,caselem(3,1)];
       end
       sarr = sortrows(casarr,1);
       sarr(:,1) = sarr(:,1) -min(sarr(:,1));
       outc.seq{i,1} = sarr;
    end
    outc.m = size(outc.ids,2);

end


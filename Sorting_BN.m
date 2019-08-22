function Sort_data=Sorting_BN(Pipe)
k=1;
for i=1:size(Pipe.UGS_Cost,1)
    
    if Pipe.UGS_Cost(i,1)~=0
        Cost(k,1) = i;
        Cost(k,2) = Pipe.UGS_Cost(i,1);
        k         = k+1;
    end
    
end



for i=1:size(Cost,1)
    [Cost_temp(i,2) index]= min([Cost(:,2)]);
    Cost_temp(i,1)        = Cost(index,1);
    Cost(index,2)         = inf;
end
Cost=round(Cost_temp);
clear Cost_temp
k=1;
for i=1:size(Cost,1)
    if Cost(i,2)~=0
        S=Cost(i,2);
        R=find(Cost(:,2)==S) ;
        if size(R,1)==1
            Cost_sort(k,2)=Cost(R(1),2);
            Cost_sort(k,1)=Cost(R(1),1);
            k=k+1;
        else
            Cost_sort(k,2)=Cost(R(1),2);
            Cost_sort(k,1)=Cost(R(1),1);
            k=k+1;
            for j=2:size(R,1)
                Cost(R(j,1),2)=0;
            end
            
        end
    end
end
Sort_data= Cost_sort;
end
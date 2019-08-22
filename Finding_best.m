function [Pipe] = Finding_best(Pipe,Network_Number,Diameters,fitfun,options)
%xmin_possible,fmin_possible,sum_violation_min,fmin_dis
Const=Def_Constraint(Network_Number);
%------------------Continuous--------------------------
MinCost=inf;
Index=0;
for i=1:size(Pipe.Continuous_Sols,1)
    if Pipe.Continuous_Violation(i,end)== options.CV && Pipe.Continuous_Cost(i,end)< MinCost
        MinCost=Pipe.Continuous_Cost(i,end);
        Index=i;
    end
end
if Index~=0
    Pipe.FminC=MinCost;
    Pipe.XminC=Pipe.Continuous_Sols(Index,:);
else
    Pipe.FminC=0;
    Pipe.XminC=0;
end
disp('------------------------------------------------------')
disp(['The Best Continuous Pipe Design=',mat2str(round(Pipe.XminC,1))]);
disp(['The Best Continuous Pipe Cost=',num2str(Pipe.FminC)]);
if round(Pipe.FminC/10^6,2)==round(options.BestC/10^6,2)
    disp('---The well-known solution is founded for this Network----')
end
%--------------------Rounded----------------------
MinCost=inf;

for i=1:size(Pipe.Rounded_Sols,1)
    if Pipe.Rounded_Violation(i,end)== options.CV &&Pipe.Rounded_Cost(i,end)~=0&& Pipe.Rounded_Cost(i,end)< MinCost
        MinCost=Pipe.Rounded_Cost(i,end);
        Index=i;
    end
end
if MinCost~=inf
    Pipe.FminR=MinCost;
    Pipe.XminR=Pipe.Rounded_Sols(Index,:);
    disp('------------------------------------------------------')
    disp(['The Best Rounded Pipe Design=',mat2str(Pipe.XminR)]);
    disp(['The Best Rounded Pipe Cost=',num2str(Pipe.FminR)]);
    if round(Pipe.FminR/10^6,2)==round(options.BestC/10^6,2)
        disp('---The well-known solution is founded for this Network----')
    end
end
%-----------------------Upward Greedy Search-----------------------
if  Pipe.UGSflag==0 % Upward Greedy Search did not run
    Pipe.FminU=0;
    Pipe.XminU=0;
    return
end
MinCost=inf;
if Pipe.UGSflag==1
    for i=1:size(Pipe.UGS_Sols,1)
        if  Pipe.UGS_Cost(i,end)< MinCost && Pipe.UGS_Cost(i,end)~=0
            MinCost=Pipe.UGS_Cost(i,end);
            Index=i;
        end
    end
    if MinCost ~=inf
        Pipe.FminU=MinCost;
        Pipe.XminU=Pipe.UGS_Sols(Index,:);
        disp('------------------------------------------------------')
        disp(['The Best upward Greedy Search Pipe Design=',mat2str(Pipe.XminU)]);
        disp(['The Best upward Greedy Search Pipe Cost=',num2str(Pipe.FminU)]);
        if round(Pipe.FminU/10^6,2)==round(options.BestC/10^6,2)
            disp('---The well-known solution is founded for this Network----')
        end
    end
end
%-------------------------------------------------------------
%         if round(Pipe.Fmin/10^6,2)==round(Bestfmin(Network_Number)/10^6,2)
%            return
%         end
%         fitfun='DNYTP_Cost2';
%         %mid=round((size(Pipe.Best_Sols,1)/3));
%         for i=1:size(Pipe.Best_Sols,1)
%             if Pipe.Best_Sols(i,93)==0
%             [Cost,Pure_Cost,Pressure_Nodes,Length_Pipes]=  feval(fitfun,Pipe.Best_Sols(i,1:42)' );
%             Pipe.Best_Sols(i,43)= Pure_Cost(1);
%             Pipe.Best_Sols(i,44)= Pure_Cost(2);
%             Pipe.Best_Sols(i,45)= sum(Pure_Cost);
%             sum_Violation=zeros(2,1);
%             for k=1:2
%                 for j=1:size(Pressure_Nodes(k,:),2)
%                     if Pressure_Nodes(k,j)<0
%                         sum_Violation(k,1)=sum_Violation(k,1)+abs(Pressure_Nodes(k,j));
%                     end
%                 end
%             end
%             Pipe.Best_Sols(i,46)= sum_Violation(1);
%             Pipe.Best_Sols(i,47)= sum_Violation(2);
%             Pipe.Best_Sols(i,48)= sum(sum_Violation);
%
%             Pipe.Best_Sols(i,49:69)  = Dim_Correction(Pipe.Best_Sols(i,1:21), Diameters);
%             Pipe.Best_Sols(i,70:90)  = Dim_Correction(Pipe.Best_Sols(i,22:42), Diameters);
%             [Cost,Pure_Cost,Pressure_Nodes,Length_Pipes]=  feval(fitfun,Pipe.Best_Sols(i,49:90)' );
%             Pipe.Best_Sols(i,91)= Pure_Cost(1);
%             Pipe.Best_Sols(i,92)= Pure_Cost(2);
%             Pipe.Best_Sols(i,93)= sum(Pure_Cost);
%             sum_Violation=zeros(2,1);
%             for k=1:2
%                 for j=1:size(Pressure_Nodes(k,:),2)
%                     if Pressure_Nodes(k,j)<0
%                         sum_Violation(k,1)=sum_Violation(k,1)+abs(Pressure_Nodes(k,j));
%                     end
%                 end
%             end
%             Pipe.Best_Sols(i,94)= sum_Violation(1);
%             Pipe.Best_Sols(i,95)= sum_Violation(2);
%             Pipe.Best_Sols(i,96)= sum(sum_Violation);
%             end%end if
%         end %end for
%         [fmin_possible ,minindex]=min([Pipe.Best_Sols(mid:end,93)]);
%         xmin_possible    =  Pipe.Best_Sols(minindex+mid,49:90);
%         sum_violation_min=  Pipe.Best_Sols(minindex+mid,94:95);
%         fmin_dis=inf;
%         for i=mid:size(Pipe.Best_Sols,1)
%             if Pipe.Best_Sols(i,96)==0 &&Pipe.Best_Sols(i,93)~=0&& Pipe.Best_Sols(i,93)< fmin_dis
%                 fmin_dis= Pipe.Best_Sols(i,93);
%             end
%         end
%     case 3
%
%     case 4
%
%     case 5
%
%
% end



end
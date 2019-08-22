function [CostAll,AllViolation] = Network_Cost_50_1(Dim)

for ii=1:50
Dim1=[180,180,180,180,180,180,132,132,180,204,204,204,204,204,204,72,72,60,60,60,72];
ss=(ii-1)*21+1;
Dim_temp=[Dim1';Dim(ss:ss+20,1)];

[Pressure_Nodes,Length_Pipes]=GetComputedHydraulic(Dim_temp);

Sum_Pipe_Cost=0;
Sum_Violation=0;

for i=1:(size(Length_Pipes,2)/2) % computing the cost of all pipes
    Pipe_Cost=(1.1 * Dim_temp(21+i) ^ 1.24)* Length_Pipes(21+i);
    Sum_Pipe_Cost = Sum_Pipe_Cost + Pipe_Cost;
end
%-------------------------------------------------------------------
for i=1: size(Pressure_Nodes,2) % computing the penalty cost
    if  Pressure_Nodes(i) <0
        Sum_Violation= Sum_Violation + abs(Pressure_Nodes(i));
    end
end
if Sum_Violation ~=0
    %if Sum_Violation<=1
     %  Penalty_Pressure=10*10^6*Sum_Violation+2*10^6; 
    %else
       Penalty_Pressure=12*10^6*Sum_Violation; 
    %end
Cost(ii) = Sum_Pipe_Cost ;%+ Penalty_Pressure ; % penalty factor=12,000,000
else
Cost(ii) = Sum_Pipe_Cost  ;
end
SumViolation(ii)=Sum_Violation ;
end  % end for

CostAll=sum(Cost);
AllViolation=sum(SumViolation);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [CostAll,Pressure_Nodes,Sum_Violation] = Network_Cost_1(Dim)


Dim1=[180,180,180,180,180,180,132,132,180,204,204,204,204,204,204,72,72,60,60,60,72];
if size(Dim,1)==1
    Dim=Dim';
end
Dim_temp=[Dim1';Dim];

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

CostAll=Sum_Pipe_Cost;
end

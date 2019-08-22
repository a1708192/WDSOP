function [CostAll,Pure_Cost,Pressure_Nodes,Length_Pipes] = NYTP50_Cost(Dim)
global  G_NYTP
if size(Dim,1)==1
    Dim=Dim';
end
Sum_Pipe_Cost=zeros(1,50);
for ii=1:50
    
Dim1=[180,180,180,180,180,180,132,132,180,204,204,204,204,204,204,72,72,60,60,60,72];
ss=(ii-1)*21+1;
Dim_temp=[Dim1';Dim(ss:ss+20,1)];

for j=22:size(Dim_temp,1)
    if Dim_temp(j,1)==0
        G_NYTP.setLinkStatus(j,0)
        G_NYTP.setLinkDiameter(j,0.01) % Set new link diameter
    else
        G_NYTP.setLinkDiameter(j,Dim_temp(j,1)) % Set new link diameter
    end
end
H = G_NYTP.getComputedHydraulicTimeSeries; %Solve hydraulics in library
Pressure_Nodes(ii,:)     = H.Pressure;
Length_Pipes       = G_NYTP.LinkLength;
Head_Pressure_Nodes= H.Head;
%[Pressure_Nodes,Length_Pipes]=GetComputedHydraulic(Dim_temp);


Sum_Violation=0;

for i=1:(size(Length_Pipes,2)/2) % computing the cost of all pipes
    Pipe_Cost=(1.1 * Dim_temp(21+i) ^ 1.24)* Length_Pipes(21+i);
    Sum_Pipe_Cost(ii) = Sum_Pipe_Cost(ii) + Pipe_Cost;
end
%-------------------------------------------------------------------
for i=1: size(Pressure_Nodes,2) % computing the penalty cost
    if  Pressure_Nodes(ii,i) <0
        Sum_Violation= Sum_Violation + abs(Pressure_Nodes(ii,i));
    end
end
if Sum_Violation ~=0
    %if Sum_Violation<=1
     %  Penalty_Pressure=10*10^6*Sum_Violation+2*10^6; 
    %else
       Penalty_Pressure=12*10^6*Sum_Violation; 
    %end
Cost(ii) = Sum_Pipe_Cost(ii) + Penalty_Pressure ; % penalty factor=12,000,000
else
Cost(ii) = Sum_Pipe_Cost(ii)  ;
end
end  % end for
CostAll  =sum(Cost);
Pure_Cost=(Sum_Pipe_Cost);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

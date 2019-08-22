function [Cost,Pure_Cost,Pressure_Nodes,Length_Pipes,Head_Nodes] = Hanoi_Cost(Dim)

%[Pressure_Nodes,Length_Pipes,Head_Nodes]=GetComputedHydraulic(Dim);
%---------------------------
global  G_NYTP
NN=size(Dim,1);
if NN==1
   Dim=Dim'; 
end
for ii=1:size(Dim,1)
    if Dim(ii,1)==0
        G_NYTP.setLinkStatus(ii,0)
        G_NYTP.setLinkDiameter(ii,0.01) % Set new link diameter
    else
        G_NYTP.setLinkDiameter(ii,Dim(ii,1)) % Set new link diameter
    end
end
H = G_NYTP.getComputedHydraulicTimeSeries; %Solve hydraulics in library
Pressure_Nodes    = H.Pressure;
Length_Pipes      = G_NYTP.LinkLength;
Head_Nodes        = H.Head;

%--------------------------
Sum_Pipe_Cost=0;
Sum_Violation=0;

for i=1:(size(Length_Pipes,2)) % computing the cost of all pipes
    Dim(i)        = Dim(i)/25.4; %Converting mm to inch
    Pipe_Cost     =(1.1 * Length_Pipes(i)*(Dim(i) ^ 1.5)) ;
    Sum_Pipe_Cost = Sum_Pipe_Cost + Pipe_Cost;
end
%---------------------------applying the penalty for converting the
%continuous to discreate solutions (interval=1)
Sum_dif=0;
% for i=1:(size(Length_Pipes,2)/2)
%    dif_dim=abs(Dim(21+i)-round(Dim(21+i)));
%    if dif_dim >0
%        if dif_dim==0.5
%            Sum_dif=Sum_dif+0.5;
%        else
%       Sum_dif= (dif_dim)+Sum_dif;
%        end
%    end
% 
% end
%-------------------penalty of 12------------------------------------------
% Sum_dif=0;
% dif_dim=0;
% for i=1:(size(Length_Pipes,2)/2)
%     if Dim(21+i)<36
%         if Dim(21+i)==18
%             dif_dim=3;
%         elseif Dim(21+i)< 18
%             dif_dim=3*(Dim(21+i)/18);
%         else
%             dif_dim=3*((36-Dim(21+i))/18);
%         end
%     else
%         rem12= rem(Dim(21+i),12);
%         if rem12 ~=0
%             dif_dim= (rem12-6);
%             if dif_dim <0
%                 dif_dim=(6-abs(dif_dim)) /6;
%             elseif dif_dim==0
%                 dif_dim=1;
%             elseif dif_dim >0
%                 dif_dim= (12-rem12)/6;
%             end
%             
%         end
%     end %Dim(21+i)<36
%     Sum_dif=Sum_dif+dif_dim;
% end

%-------------------------------------------------------------------
for i=1: size(Pressure_Nodes,2) % computing the penalty cost
    if  Head_Nodes(i) < 30
        Sum_Violation= Sum_Violation + abs(30-Head_Nodes(i));
    end
end
if Sum_Violation ~=0
    %if Sum_Violation<=1
     %  Penalty_Pressure=10*10^6*Sum_Violation+2*10^6; 
    %else
       Penalty_Pressure=10^4*Sum_Violation; 
    %end
Cost = Sum_Pipe_Cost + Penalty_Pressure+ (Sum_dif * 10^5); % penalty factor=12,000,000
else
Cost = Sum_Pipe_Cost + (Sum_dif * 1000000)  ;
end
Pure_Cost=Sum_Pipe_Cost;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

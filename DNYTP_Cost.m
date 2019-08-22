function [Cost,Pure_Cost,Pressure_Nodes,Length_Pipes] = DNYTP_Cost(Pipe)
global  G_NYTP
if size(Pipe,1)==1
   Pipe=Pipe'; 
end
for k=1:2 % 2* NYTP
Dim1=[180,180,180,180,180,180,132,132,180,204,204,204,204,204,204,72,72,60,60,60,72];
Dim=[Dim1';Pipe((k-1)*21+1:k*21)];

%[Pressure_Nodes,Length_Pipes]=GetComputedHydraulic(Dim);

for ii=22:size(Dim,1)
    if Dim(ii,1)==0
        G_NYTP.setLinkStatus(ii,0)
        G_NYTP.setLinkDiameter(ii,0.01) % Set new link diameter
    else
        G_NYTP.setLinkDiameter(ii,Dim(ii,1)) % Set new link diameter
    end
end
H = G_NYTP.getComputedHydraulicTimeSeries; %Solve hydraulics in library
Pressure_Nodes(k,:) = H.Pressure;
Length_Pipes(k,:)        = G_NYTP.LinkLength;
Head_Pressure_Nodes = H.Head;

Sum_Pipe_Cost=0;
Sum_Violation=0;

for i=1:(size(Length_Pipes(k,:),2)/2) % computing the cost of all pipes
    Pipe_Cost=(1.1 * Dim(21+i) ^ 1.24)* Length_Pipes(k,21+i);
    Sum_Pipe_Cost = Sum_Pipe_Cost + Pipe_Cost;
end
%---------------------------applying the penalty for converting the
%continuous to discreate solutions (interval=1)
%Sum_dif=0;
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
for i=1: size(Pressure_Nodes(k,:),2) % computing the penalty cost
    if  Pressure_Nodes(k,i) <0
        Sum_Violation= Sum_Violation + abs(Pressure_Nodes(k,i));
    end
end
if Sum_Violation ~=0
    %if Sum_Violation<=1
     %  Penalty_Pressure=10*10^6*Sum_Violation+2*10^6; 
    %else
       Penalty_Pressure=12*10^6*Sum_Violation; 
    %end
CostT(k) = Sum_Pipe_Cost + Penalty_Pressure; %+ (Sum_dif * 1000000); % penalty factor=12,000,000
else
CostT(k) = Sum_Pipe_Cost;% + (Sum_dif * 1000000)  ;
end
Pure_CostT(k) = Sum_Pipe_Cost;
end % end for
Cost     = sum(CostT);
Pure_Cost= Pure_CostT;

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

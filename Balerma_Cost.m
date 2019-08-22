function [Cost_All,Pure_Cost,Pressure_Nodes,Length_Pipes,Head_Nodes] = Balerma_Cost(Dim)

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
Sum_Pipe_Cost     = 0;
Sum_Violation     = 0;

for i=1:(size(Length_Pipes,2)) % computing the cost of all pipes
    if Dim(i)>=0 && Dim(i)< 113
        Pipe_Cost(i)=cal_linear(0,0,113,7.22,Length_Pipes(i),Dim(i));
        
    elseif Dim(i)==113
        Pipe_Cost(i)=Length_Pipes(i)*7.22 ;
        
    elseif Dim(i)>113 && Dim(i)< 126.6
        Pipe_Cost(i)=cal_linear(113,7.22,126.6,9.10,Length_Pipes(i),Dim(i));
        
    elseif Dim(i)==126.6
        Pipe_Cost(i)=Length_Pipes(i)*9.10 ;
        
    elseif Dim(i)>126.6 && Dim(i)< 144.6
        Pipe_Cost(i)=cal_linear(126.6,9.10,144.6,11.92,Length_Pipes(i),Dim(i));
        
    elseif Dim(i)==144.6
        Pipe_Cost(i)=Length_Pipes(i)*11.92 ;
        
    elseif Dim(i)>144.6 && Dim(i)< 162.8
        Pipe_Cost(i)=cal_linear(144.6,11.92,162.8,14.84,Length_Pipes(i),Dim(i));
        
    elseif Dim(i)==162.8
        Pipe_Cost(i)=Length_Pipes(i)*14.84 ;
        
    elseif Dim(i)>162.8 && Dim(i)< 180.8
        Pipe_Cost(i)=cal_linear(162.8,14.84,180.8,18.38,Length_Pipes(i),Dim(i));
        
    elseif Dim(i)==180.8
        Pipe_Cost(i)=Length_Pipes(i)*18.38 ;
        
    elseif Dim(i)>180.8 && Dim(i)< 226.2
        Pipe_Cost(i)=cal_linear(180.8,18.38,226.2,28.6,Length_Pipes(i),Dim(i));
        
    elseif Dim(i)==226.2
        Pipe_Cost(i)=Length_Pipes(i)*28.6 ;
        
    elseif Dim(i)>226.2 && Dim(i)< 285.0
        Pipe_Cost(i)=cal_linear(226.2,28.6,285,45.39,Length_Pipes(i),Dim(i));
        
    elseif Dim(i)==285.0
        Pipe_Cost(i)=Length_Pipes(i)*45.39 ;
        
    elseif Dim(i)>285 && Dim(i)< 361.8
        Pipe_Cost(i)=cal_linear(285,45.39,361.8,76.32,Length_Pipes(i),Dim(i));
        
    elseif Dim(i)==361.8
        Pipe_Cost(i)=Length_Pipes(i)*76.32 ;
        
    elseif Dim(i)>361.8 && Dim(i)< 452.2
        Pipe_Cost(i)=cal_linear(361.8,76.32,452.2,124.64,Length_Pipes(i),Dim(i));
        
    elseif Dim(i)==452.2
        Pipe_Cost(i)=Length_Pipes(i)* 124.64;
        
    elseif Dim(i)>452.2 && Dim(i)< 581.8
        Pipe_Cost(i)=cal_linear(452.2,124.64,581.8,215.85,Length_Pipes(i),Dim(i));
        
    elseif Dim(i)==581.8
        Pipe_Cost(i)=Length_Pipes(i)*215.85 ;
        
    end
    
    Sum_Pipe_Cost = Sum_Pipe_Cost + Pipe_Cost(i);
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
for i=1: size(Pressure_Nodes,2)-4 % computing the penalty cost
    if  Pressure_Nodes(i) <20
        Sum_Violation= Sum_Violation + abs(20-Pressure_Nodes(i));
    end
end
if Sum_Violation ~=0
    %if Sum_Violation<=1
    %  Penalty_Pressure=10*10^6*Sum_Violation+2*10^6;
    %else
    Penalty_Pressure=10^5*Sum_Violation;
    %end
    Cost_All = Sum_Pipe_Cost + Penalty_Pressure;%+ (Sum_dif * 10^5); % penalty factor=12,000,000
else
    Cost_All = Sum_Pipe_Cost ;%+ (Sum_dif * 10^5)  ;
end
Pure_Cost = Sum_Pipe_Cost;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Best_Pipe,Pressure_BS,PipeCost ]=Greedy_Search_down(Best_Pipe)

global G_NYTP;

Possible_Dim=[ 0,36,48,60,72,84,96,108,120,132,144,156,168,180,192,204];
flagzero=0;
flagzero=1;
[Cost_BS,Pressure_BS,Length_Pipes,Head_Nodes]=Cost_Pip(Best_Pipe);
Sum_violation_BS = 0;

for ii=1:size(Pressure_BS ,2)
    if Pressure_BS(ii)<0
        Sum_violation_BS=Sum_violation_BS+ abs(Pressure_BS(ii));
    end
end

Sum_Head_Violation_BS = 0;
HeadNode=Head_Nodes;
disp(['Pipe size=',num2str(Best_Pipe)])
disp(['Cost Pipe=',num2str(round( Cost_BS))])
disp(['Sum violation Pressure=',num2str(Sum_violation_BS)])
%disp(['Sum HEAD violation Pressure=',num2str( Sum_Head_Violation_BS)])
Sum_violation=Sum_violation_BS;
i=1;
while (Sum_violation ==0 )
    
    Temp_Sol=Best_Pipe;
    j=1;
    
    while j<=size(Best_Pipe,2) % the number of pipe
        
        Temp_Sol=Best_Pipe;
        
        if Temp_Sol(j)==36
            Temp_Sol(j)=0;
        elseif Temp_Sol(j)==48
            Temp_Sol(j)=36;
        elseif Temp_Sol(j)==60
            Temp_Sol(j)=48;
        elseif Temp_Sol(j)==72
            Temp_Sol(j)=60;
        elseif Temp_Sol(j)==84
            Temp_Sol(j)=72;
        elseif Temp_Sol(j)==96
            Temp_Sol(j)=84;
        elseif Temp_Sol(j)==108
            Temp_Sol(j)=96;
        elseif Temp_Sol(j)==120
            Temp_Sol(j)=108;
        elseif Temp_Sol(j)==132
            Temp_Sol(j)=120;
        elseif Temp_Sol(j)==144
            Temp_Sol(j)=132;
        elseif Temp_Sol(j)==156
            Temp_Sol(j)=144;
        elseif Temp_Sol(j)==168
            Temp_Sol(j)=156;
        elseif Temp_Sol(j)==180
            Temp_Sol(j)=168;
        elseif Temp_Sol(j)==192
            Temp_Sol(j)=180;
        elseif Temp_Sol(j)==204
            Temp_Sol(j)=192;
        end
        Solution(i,j).Pipe          = Temp_Sol; % recording the solutions
        [Solution(i,j).CostPipe,Solution(i,j).Pressure,Length_Pipes,Solution(i,j).Head]=Cost_Pip(Temp_Sol);
        Table(j,1)                  = Solution(i,j).CostPipe;
        Solution(i,j).Delta_Cost    = abs(Solution(i,j).CostPipe-Cost_BS);
        Table(j,2)                  = Solution(i,j).Delta_Cost;
        Solution(i,j).Delta_Pre     = 0;
        Sum_violation               = 0;
        
        for ii=1:size(Pressure_BS ,2)
            if Solution(i,j).Pressure (ii)<0
                Sum_violation=Sum_violation+ Solution(i,j).Pressure (ii);
            end
        end
        
        Sum_Head_Violation = 0;
        Solution(i,j).Sum_violation     = Sum_violation;
        Table(j,3)                      = Solution(i,j).Sum_violation;
        
        for ii=1:size(Pressure_BS ,2)
            
            if Solution(i,j).Pressure(ii)>0 && Pressure_BS(ii)>0
                Solution(i,j).Delta_Pre=Solution(i,j).Delta_Pre+ abs(Pressure_BS(ii)-Solution(i,j).Pressure(ii));
            end
            
            if Solution(i,j).Pressure(ii)<=0 && Pressure_BS(ii)>0
                Solution(i,j).Delta_Pre=Solution(i,j).Delta_Pre+ abs(Solution(i,j).Pressure(ii));
            end
            Table(j,4)                 =  Solution(i,j).Delta_Pre;
            %                     if Solution(i,j).Pressure(ii)<0
            %                         Sum_violation=Sum_violation+ Solution(i,j).Pressure(ii);
            %                     end
            
        end
        %                 Solution(i,j).Sum_violation=Sum_violation;
        
        if Solution(i,j).Delta_Pre==0 && Solution(i,j).Delta_Cost==0
            Solution(i,j).rate_im=0;
        elseif Solution(i,j).Delta_Pre==0
            Solution(i,j).rate_im= 0;
        else
            Solution(i,j).rate_im=  Solution(i,j).Delta_Cost/Solution(i,j).Delta_Pre ;
        end
        Table(j,5)                 =  Solution(i,j).rate_im;
        j=j+1;
    end  % end while
    % selecting the feasible solutions
    k=1;
    for ii=1:size(Best_Pipe,2)
        if Solution(i,ii).Sum_violation==0 && Solution(i,ii).Sum_HeadViolation==0 && Solution(i,ii).CostPipe < Cost_BS
            Feasible(k)=Solution(i,ii);
            k=k+1;
        end
    end
    
    %finding the best candidate
    if k==1
        % i=i+1;
        break
    end
    BestSol(i)=Feasible(1);
    
    for i1=2:k-1
        if Feasible(i1).rate_im > BestSol(i).rate_im
            BestSol(i)=Feasible(i1);
        end
    end
    Best_Pipe             = BestSol(i).Pipe;
    Pressure_BS           = BestSol(i).Pressure;
    Sum_violation_BS      = BestSol(i).Sum_violation;
    Cost_BS               = BestSol(i).CostPipe;
    Sum_Head_Violation_BS = BestSol(i).Sum_HeadViolation;
    
    % disp(['Best solution Pipe size=',num2str(Best_Pipe)])
    GS_Pipe(i,:)=Best_Pipe;
    disp(['Best solution sum Pressure violation Node=',num2str(BestSol(i).Sum_violation)])
    %disp(['Best solution sum Head violation Node=',num2str(BestSol(i).Sum_HeadViolation)])
    disp(['The pipe cost=',num2str([BestSol(i).CostPipe])]);
    disp(['Number of feasiable solutions=',num2str(size(Feasible,2))])
    i=i+1;
    clear Feasible
end  % end while
PipeCost= Cost_BS;
Pipe.Best_Sols(cc,74:94)    = Best_Pipe; % 52:72 77:97
Pipe.Best_Sols(cc,95)       = Cost_BS;
Pipe.Best_Sols(cc,96)       = Sum_violation_BS ;
%             Pipe.Best_Sols(cc,97)       = Sum_Head_Violation_BS;
% end % End if Pipe.Best_Sols(cc,171)~=0
%         if flagzero==1
%             clear Solution
%             disp(['-----------------------',num2str(p),'------------------------------'])
%         end
% end % for cc=1:size(Pipe.Best_Sols,1)
%save(['CMA_ES_Continuous_NYTP_Npop_200_Sigma_102_ex',num2str(p),'.mat'],'Pipe')
%end
% if thirdpart==1
%     Best_Pipe=Dec_GS(BestSol)
% end
% Best_Pipe.Pipe
%save('Greedy_Search_sample7.mat','Solution')
% b=bar3(GS_Pipe,0.5);
%  colorbar
%  set(b,'LineStyle','none')
%  for k = 1:length(b)
%      zdata = b(k).ZData;
%      b(k).CData = zdata;
%      b(k).FaceColor = 'interp';
%  end
disp('finished')
end % End Greedy function
%--------- ------------------------------------------------------------
function [Sum_Pipe_Cost,Pressure_Nodes,Length_Pipes,Head_Pressure_Nodes]=Cost_Pip(pipe)
Dim1=[180,180,180,180,180,180,132,132,180,204,204,204,204,204,204,72,72,60,60,60,72];
sizepipe=size(pipe,1);
if sizepipe==1
    pipe=pipe';
end
Dim=[Dim1';pipe];

[Pressure_Nodes,Length_Pipes,Head_Pressure_Nodes]=Get_Pressure(Dim);

Sum_Pipe_Cost=0;
Sum_Violation=0;

for i=1:(size(Length_Pipes,2)/2) % computing the cost of all pipes
    Pipe_Cost=(1.1 * Dim(21+i) ^ 1.24)* Length_Pipes(21+i);
    Sum_Pipe_Cost = Sum_Pipe_Cost + Pipe_Cost;
end
end
%----------------------------------------------------------------------
function [Pressure_Nodes,Length_Pipes,Head_Pressure_Nodes]=Get_Pressure(Pipe)
[Pressure_Nodes,Length_Pipes,Head_Pressure_Nodes]=GetComputedHydraulic(Pipe);
end


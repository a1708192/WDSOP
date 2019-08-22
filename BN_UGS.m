
function [Pipe,countiter ]=BN_UGS(Pipe,countiter,PipeLength,Network_Number,inopts,Iter)

global G_NYTP;
flag_do=1;
Type='R';
flag_rep=rep(Pipe,countiter,Type);
PL=PipeLength/Iter;
if flag_rep==0
    for k=1:inopts.NS
        Best_Pipe=Pipe.Rounded_Sols(countiter,(k-1)*(PL)+1:k*(PL));
        [Cost_All,Cost_BS,Pressure_BS,Length_Pipes,Head_Nodes] =feval( inopts.CostF, Best_Pipe); 
        
        Sum_violation = 0;
        for ii=1:size(Pressure_BS,2)-4
            if Pressure_BS(ii)<inopts.CV
                Sum_violation=Sum_violation+ abs(inopts.CV-Pressure_BS(ii));
            end
        end
       % disp ('------------------------------------------------------')
        %disp(['k=',num2str(k),'Pipe size=',mat2str(Best_Pipe)])
        disp(['Sum Violation=',num2str(Sum_violation)])
        kk=1;
        while (Sum_violation ~=0 )
            
            Temp_Sol=Best_Pipe;
            j=1;
            
            while j<=size(Best_Pipe,2) % the number of pipe
                
                Temp_Sol=Best_Pipe;
                if Temp_Sol(j)==113
                    Temp_Sol(j)=126.6;
                elseif Temp_Sol(j)==126.6
                    Temp_Sol(j)=144.6;
                elseif Temp_Sol(j)==144.6
                    Temp_Sol(j)=162.8;
                elseif Temp_Sol(j)==162.8
                    Temp_Sol(j)=180.8;
                elseif Temp_Sol(j)==180.8
                    Temp_Sol(j)=226.2;
                elseif Temp_Sol(j)==226.2
                    Temp_Sol(j)=285;
                elseif Temp_Sol(j)==285
                    Temp_Sol(j)=361.8;
                elseif Temp_Sol(j)==361.8
                    Temp_Sol(j)=452.2;
                elseif Temp_Sol(j)==452.2
                    Temp_Sol(j)=581.8;
                end
                Solution(kk,j).Pipe                                  = Temp_Sol; % recording the solutions
                [~,Solution(kk,j).CostPipe,Solution(kk,j).Pressure,~]= Balerma_Cost(Temp_Sol);
                Solution(kk,j).Delta_Cost                            = (Solution(kk,j).CostPipe-Cost_BS);
                Solution(kk,j).Delta_Pre                             = 0;
                Solution(kk,j).Sum_violation                         = 0;
                Sum_violation                                        = 0;
                
                for ii=1:size(Solution(kk,j).Pressure,2)-4
                    
                    if Solution(kk,j).Pressure(ii)<inopts.CV && Pressure_BS(ii)<inopts.CV
                        Solution(kk,j).Delta_Pre=Solution(kk,j).Delta_Pre+ abs(Pressure_BS(ii)-Solution(kk,j).Pressure(ii));
                    end
                    
                    if Solution(kk,j).Pressure(ii)>=inopts.CV && Pressure_BS(ii)<inopts.CV
                        Solution(kk,j).Delta_Pre=Solution(kk,j).Delta_Pre+ abs(Pressure_BS(ii));
                    end
                    
                    if Solution(kk,j).Pressure(ii)<inopts.CV
                        Sum_violation=Sum_violation+abs(inopts.CV-Solution(kk,j).Pressure(ii));
                    end
                    
                end
                Solution(kk,j).Sum_violation=Sum_violation;
                
                if Solution(kk,j).Delta_Pre==0 && Solution(kk,j).Delta_Cost==0
                    Solution(kk,j).rate_im=0;
                    
                elseif Solution(kk,j).Delta_Pre~=0 && Solution(kk,j).Delta_Cost==0
                    Solution(kk,j).rate_im=0;
                    
                else
                    Solution(kk,j).rate_im= Solution(kk,j).Delta_Pre / Solution(kk,j).Delta_Cost;
                end
                
                j=j+1;
            end  % end while
            %finding the best candidate
            BestSol(kk)=Solution(kk,1);
            for i1=1:j-1
                if Solution(kk,i1).rate_im > BestSol(kk).rate_im
                    BestSol(kk)=Solution(kk,i1);
                end
                
            end
            Best_Pipe      = BestSol(kk).Pipe;
            Pressure_BS    = BestSol(kk).Pressure;
            Sum_violation  = BestSol(kk).Sum_violation;
            
           % disp(['Best solution Pipe size=',mat2str(Best_Pipe)])
            %disp(['The pipe cost=',num2str([BestSol(kk).CostPipe]),'::Sum_violation= ',num2str(Sum_violation)]);
            if kk > 1
            if round(BestSol(kk).CostPipe,2)== round(BestSol(kk-1).CostPipe,2)
                disp('---------- Upward Greedy Search is stopped ----------')
                break % there is not any improvement
            end
            end
            kk=kk+1;
        end % end while
        
         if kk >1
            PipeCost = [BestSol(kk-1).CostPipe];
        else
            PipeCost= Cost_BS;% 
        end
        Pipe.UGS_Sols(countiter,(k-1)*(PL)+1:k*(PL))= Best_Pipe;
        Pipe.UGS_Cost(countiter,k)= PipeCost;
        
        if k==inopts.NS
            Pipe.UGS_Cost(countiter,inopts.NS+1)=sum(Pipe.UGS_Cost(countiter,1:inopts.NS))  ;
        end
        
        if round(PipeCost/10^6,3)==round(inopts.BestC/10^6,3)/inopts.NS
            disp(['---------The well-known Network design is founded ',num2str(k),'---------'])
            
        end
        clear Solution
    end  % for k=1:Iter
else
    Pipe.UGS_Cost(countiter,:)=0;
    Pipe.UGS_Sols(countiter,:)=0;
   % disp ('-------The rounded pipe cost is repeatable-------')
end %end if rep
if flag_rep==0
    [MinCost]  = min(nonzeros(Pipe.UGS_Cost(:,end)));
    %     fmin_dis = MinCost;
    index      = find(round(Pipe.UGS_Cost(:,end))==round(MinCost));
    Pipe.XminU = Pipe.UGS_Sols(index(1),:);
    Pipe.FminU = MinCost;
    %     fmin_dis = MinCost;
    % end
    disp ('----------------Upward Greedy Search is finished-----------------')
   % disp(['The best design of Upward Greedy Search =',num2str(MinCost)])
    disp([',Pipe cost=',num2str(round(Pipe.UGS_Cost(countiter,end)))])
    %disp(['Pipe sizes 2=',mat2str([Pipe._Sols(countiter,118:138)]),',Pipe cost=',num2str(Pipe.Best_Sols(countiter,140))])
end

end
   
    

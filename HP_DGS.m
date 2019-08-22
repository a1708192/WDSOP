function  Pipe=HP_DGS(Pipe,Network_Number,PipeLength,inopts,Iter)

global G_NYTP;
%fitfun=Def_fitfun(Network_Number);
%Iter=Def_Iter(Network_Number);

% index=141;
count=0;
PL=PipeLength/Iter;
Type='U';
for h=1:size(Pipe.UGS_Sols,1)
    if Pipe.UGS_Cost(h,end)==0
        count=count+1;
    end
end
if count==size(Pipe.UGS_Sols,1)
    disp('There is not proper solution for applying Downward Greedy Search')
    return
end
for cc=1:size(Pipe.UGS_Sols,1)
    
    if Pipe.UGS_Cost(cc,end)~=0
        flag_rep=0;
        flag_rep=rep(Pipe,cc,Type);
        if flag_rep==0
            for k1=1:inopts.NS %2* NYTP
                if round(Pipe.UGS_Cost(cc,k1)/10^6,2)==round((inopts.BestC/10^6),2) % saving the runtime
                    disp('---------Best known pipe design-----------------')
                    disp(['Pipe size =',mat2str(Pipe.UGS_Sols(cc,(k1-1)*(PL)+1:k1*(PL)))])
                    disp(['Cost Pipe =',num2str(round( Pipe.UGS_Cost(cc,k1)))])
                    Pipe.DGS_Sols(cc,(k1-1)*(PL)+1:k1*(PL))= Pipe.UGS_Sols(cc,(k1-1)*(PL)+1:k1*(PL));
                    Pipe.DGS_Cost(cc,k1)                   =  Pipe.UGS_Cost(cc,k1);
                    if k1==inopts.NS
                        Pipe.DGS_Cost(cc,inopts.NS+1) = sum(Pipe.DGS_Cost(cc,1:inopts.NS))   ;
                    end
                    continue
                end
                Best_Pipe=Pipe.UGS_Sols(cc,(k1-1)*(PL)+1:k1*(PL));
                %[Cost_BS,Pressure_BS,Length_Pipes,Head_Nodes]=Cost_Pip(Best_Pipe);
                [Cost_All,Cost_BS,Pressure_BS,Length_Pipes] = feval(inopts.CostF, Best_Pipe);
                Sum_violation_BS = 0;
                
                for ii=1:size(Pressure_BS ,2)
                    if Pressure_BS(ii)<inopts.CV
                        Sum_violation_BS=Sum_violation_BS+ abs(Pressure_BS(ii));
                    end
                end
                disp('-----------------------------------')
                disp(['Pipe size before applying the DGS=',mat2str(Best_Pipe)])
                disp(['Cost Pipe before applying the DGS=',num2str(round( Cost_BS))])
                disp(['Sum violation Pressure=',num2str(Sum_violation_BS)])
                Sum_violation=Sum_violation_BS;
                i=1;
                
                while (Sum_violation ==0 )
                    
                    Temp_Sol=Best_Pipe;
                    j=1;
                    
                    while j<=size(Best_Pipe,2) % the number of pipe
                        
                        Temp_Sol=Best_Pipe;
                        
                        if Temp_Sol(j)==406.4
                            Temp_Sol(j)=304.8;
                        elseif Temp_Sol(j)==508
                            Temp_Sol(j)=406.4;
                        elseif Temp_Sol(j)==609.6
                            Temp_Sol(j)=508;
                        elseif Temp_Sol(j)==762
                            Temp_Sol(j)=609.6;
                        elseif Temp_Sol(j)==1016
                            Temp_Sol(j)=762;
                        end
                        Solution(i,j).Pipe          = Temp_Sol; % recording the solutions
                        [~,Solution(i,j).CostPipe,Solution(i,j).Pressure,Length_Pipes] = feval(inopts.CostF, Temp_Sol);
                        
                        Table(j,1)                  = Solution(i,j).CostPipe;
                        Solution(i,j).Delta_Cost    = abs(Solution(i,j).CostPipe-Cost_BS);
                        Table(j,2)                  = Solution(i,j).Delta_Cost;
                        Solution(i,j).Delta_Pre     = 0;
                        Sum_violation               = 0;
                        
                        for ii=1:size(Pressure_BS ,2)
                            if Solution(i,j).Pressure (ii)<inopts.CV
                                Sum_violation=Sum_violation+ Solution(i,j).Pressure (ii);
                            end
                        end
                        
                        Solution(i,j).Sum_violation     = Sum_violation;
                        Table(j,3)                      = Solution(i,j).Sum_violation;
                        
                        for ii=1:size(Pressure_BS ,2)
                            
                            if Solution(i,j).Pressure(ii)>inopts.CV  && Pressure_BS(ii)>inopts.CV
                                Solution(i,j).Delta_Pre=Solution(i,j).Delta_Pre+ abs(Pressure_BS(ii)-Solution(i,j).Pressure(ii));
                            end
                            
                            if Solution(i,j).Pressure(ii)<=inopts.CV  && Pressure_BS(ii)>inopts.CV
                                Solution(i,j).Delta_Pre=Solution(i,j).Delta_Pre+ abs(Solution(i,j).Pressure(ii));
                            end
                            Table(j,4)                 =  Solution(i,j).Delta_Pre;
                            
                        end
                        
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
                        if Solution(i,ii).Sum_violation==0 && Solution(i,ii).CostPipe < Cost_BS
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
                    
                    disp(['Best solution sum Pressure violation after applying the DGS=',num2str(BestSol(i).Sum_violation)])
                    disp(['The pipe cost after applying the DGS=',num2str([BestSol(i).CostPipe])]);
                    disp(['The pipe sizes after applying the DGS=',mat2str(Best_Pipe)])
                    disp(['Number of feasiable solutions=',num2str(size(Feasible,2))])
                    i=i+1;
                    clear Feasible
                end  % end while
                
                PipeCost                               = Cost_BS;
                Pipe.DGS_Sols(cc,(k1-1)*(PL)+1:k1*(PL))= Best_Pipe;
                Pipe.DGS_Cost(cc,k1)                   = PipeCost;
                if k1==inopts.NS
                    Pipe.DGS_Cost(cc,inopts.NS+1) =sum(Pipe.DGS_Cost(cc,1:inopts.NS))   ;
                end
                
                clear Solution
                clear BestSol
                clear Table
            end % end for k1=1:inopts.NS
            
        end % end if rep
    end % end if
end % end for
disp('Downward Greedy Search is finished')
[MinCost]= min(nonzeros(Pipe.DGS_Cost(:,end)));
% fmin_dis = MinCost;
index      = find(round(Pipe.DGS_Cost(:,end))==round(MinCost));
Pipe.XminD = Pipe.DGS_Sols(index(1),:);
Pipe.FminD = MinCost;
% fmin_dis = MinCost;
disp(['The best design of Downward Greedy Search =',num2str(MinCost)])
disp(['Pipe sizes 1=',mat2str([Pipe.DGS_Sols(index(1),:)]),',Pipe cost=',num2str(Pipe.DGS_Cost(index(1),end))])

end
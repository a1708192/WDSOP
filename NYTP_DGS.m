function [Pipe]=NYTP_DGS(Pipe)
global G_NYTP;

for cc=1:size(Pipe.Best_Sols,1)
       
    if Pipe.Best_Sols(cc,68)~=0
        flag_rep=0;
        flag_rep=rep(Pipe,cc);
        if flag_rep==0
            Best_Pipe= Pipe.Best_Sols(cc,47:67);
            %[Cost_BS,Pressure_BS,Length_Pipes,Head_Nodes]=Cost_Pip(Best_Pipe);
            [Cost_All,Cost_BS,Pressure_BS,Length_Pipes] = NYTP_Cost(Best_Pipe);
            Sum_violation_BS = 0;
            
            for ii=1:size(Pressure_BS ,2)
                if Pressure_BS(ii)<0
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
                    % [Solution(i,j).CostPipe,Solution(i,j).Pressure,Length_Pipes,Solution(i,j).Head]=Cost_Pip(Temp_Sol);
                    [~,Solution(i,j).CostPipe,Solution(i,j).Pressure,Length_Pipes] = NYTP_Cost(Temp_Sol);
                    
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
                GS_Pipe(i,:)          = Best_Pipe;
                disp(['Best solution sum Pressure violation after applying the DGS=',num2str(BestSol(i).Sum_violation)])
                disp(['The pipe cost after applying the DGS=',num2str([BestSol(i).CostPipe])]);
                disp(['The pipe sizes after applying the DGS=',mat2str(Best_Pipe)])
                disp(['Number of feasiable solutions=',num2str(size(Feasible,2))])
                i=i+1;
                clear Feasible
            end  % end while
            PipeCost                    = Cost_BS;
            Pipe.Best_Sols(cc,69:89)    = Best_Pipe; % 52:72 77:97
            Pipe.Best_Sols(cc,90)       = Cost_BS;
            Pipe.Best_Sols(cc,91)       = Sum_violation_BS ;
        end % end if rep
    end % end if
end % end for
disp('Downward Greedy Search is finished')

end
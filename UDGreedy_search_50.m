function []=UDGreedy_search_50()
clc
load('CMA_ES_Continuous_NYTP50_Npop_1000_Sigma_102_ex2.mat')
load('ColData.mat')
k=1;
WNet(1).index=0;
for i=1:size (Pipe.Best_Sols,1)
    if Pipe.Best_Sols(i,2101) < 1.9*10^9
        WNet(k).index=i;
        for j=1:50
             WNet(k).SubN(j).RPipe=Pipe.Best_Sols(i,1051+(j-1)*21:1071+(j-1)*21)  ;
            [WNet(k).SubN(j).Rcost,~,WNet(k).SubN(j).RSum_Violation] = Network_Cost_1(WNet(k).SubN(j).RPipe);
            [Mpipe,flag]=finding(ColData,WNet(k).SubN(j).RPipe);
            
            if flag==1
                disp(['found------i=',num2str(i),'----j=',num2str(j),'------------'])
                WNet(k).SubN(j).UGcost=Mpipe.UGcost;
                WNet(k).SubN(j).UGPipe=Mpipe.UGpipe;
                WNet(k).SubN(j).DGPipe=Mpipe.DGpipe;
                WNet(k).SubN(j).DGcost=Mpipe.DGcost;
            else
                %disp(['Not found------i=',num2str(i),'----j=',num2str(j),'------------'])
                WNet(k).SubN(j).UGcost=[];
                WNet(k).SubN(j).UGPipe=[];
                WNet(k).SubN(j).DGPipe=[];
                WNet(k).SubN(j).DGcost=[];
            end
            
            
        end
        
      k=k+1;  
    end
end
save('All_CMA_ES_Continuous_NYTP50_Npop_1000_2.mat','WNet')
end
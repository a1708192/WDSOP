function [Pipe]=Downward_Greedy_Search(Network_Number,Pipe,PipeLength,inopts,Iter)
disp ('----------------------Downward Greedy Search is run----------------')
switch Network_Number
    
    case 1
        Pipe=NYTP2_DGS2(Pipe,Network_Number,PipeLength,inopts,Iter);
        
    case 2
       
        Pipe=NYTP2_DGS2(Pipe,Network_Number,PipeLength,inopts,Iter);
        
    case 3
        Pipe=NYTP2_DGS2(Pipe,Network_Number,PipeLength,inopts,Iter);
        
    case 4
        Pipe=HP_DGS(Pipe,Network_Number,PipeLength,inopts,Iter);
        
    case 5
        Pipe=BN_DGS(Pipe,Network_Number,PipeLength,inopts,Iter);
        
end
end
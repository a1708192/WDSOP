function [Pipe,countiter]=Upward_Greedy_Search(Pipe,countiter,PipeLength,Network_Number,inopts,Iter)
%disp ('----------------------Upward Greedy Search is run----------------')
switch Network_Number
    
    case 1
         [Pipe,countiter]=NYTP2_UGS2(Pipe,countiter,PipeLength,Network_Number,inopts,Iter);
        
    case 2
        
        [Pipe,countiter]=NYTP2_UGS2(Pipe,countiter,PipeLength,Network_Number,inopts,Iter);
        
    case 3
         [Pipe,countiter]=NYTP2_UGS2(Pipe,countiter,PipeLength,Network_Number,inopts,Iter);
        
    case 4
        [Pipe]=HP_UGS(Pipe,countiter,PipeLength,Network_Number,inopts,Iter);
        
    case 5
        [Pipe]=BN_UGS(Pipe,countiter,PipeLength,Network_Number,inopts,Iter);
        
end
end
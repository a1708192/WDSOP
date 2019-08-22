function MaxEval   = set_Max_Eval(Network_Number,PopSize)


switch Network_Number
    
    case 1
        
        if PopSize <200
            MaxEval=1*10^5;
        else
            MaxEval=2*(10^5);
        end
        
    case 2
        
        if PopSize <200
            MaxEval=10^5;
        else
            MaxEval=2*(10^5);
        end
        
    case 3
        
        MaxEval=1*10^6;
        
    case 4
        
        if PopSize <200
            MaxEval=1.2*10^5;
        else
            MaxEval=4*(10^5);
        end
        
    case 5
        MaxEval=2*10^6;
        
end


end

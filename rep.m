function flag_rep=rep(Pipe,i,Type)
flag_rep=0;


switch Type
    
    case 'C'
        for j=1:i-1
            if round(Pipe.Continuous_Cost(j,end))==round(Pipe.Continuous_Cost(i,end))
                flag_rep=1;
                break
            end
        end
        
    case 'R'
        for j=1:i-1
            if round(Pipe.Rounded_Cost(j,end))==round(Pipe.Rounded_Cost(i,end))
                flag_rep=1;
                break
            end
        end
    case 'U'
        for j=1:i-1
            if round(Pipe.UGS_Cost(j,end))==round(Pipe.UGS_Cost(i,end))
                flag_rep=1;
                break
            end
        end
    case 'D'
        for j=1:i-1
            if round(Pipe.DGS_Cost(j,end))==round(Pipe.DGS_Cost(i,end))
                flag_rep=1;
                break
            end
        end
        
end
end
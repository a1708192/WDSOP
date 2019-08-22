function TolFun=Def_TolFun(Network_Number)

switch  Network_Number
    
    case 1
        TolFun=4*10^4;%2
        
    case 2
        TolFun=8*10^4;%4
        
    case 3
        TolFun=50*10^4;
        
    case 4
        TolFun=1*10^2;%7*10^3;
        
    case 5
        
        TolFun=1*10^2; 
end
end
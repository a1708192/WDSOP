function [fsminall ]= set_Bestfmin(Network_Number)
switch  Network_Number
    
    case 1
        fsminall=38.6435*10^6;
        
    case 2
        fsminall=38.6435*10^6*2;
        
    case 3
        fsminall=38.6435*10^6*50;
        
    case 4
        fsminall=6.081*10^6;
        
    case 5
        fsminall=1.927*10^6;
        
end
end
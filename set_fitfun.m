function fitfun= set_fitfun(Network_Number)

switch Network_Number
    
    case 1
        fitfun= 'NYTP_Cost';
        
    case 2
        fitfun= 'DNYTP_Cost';
        
    case 3
        fitfun= 'NYTP50_Cost';
        
    case 4
        fitfun= 'Hanoi_Cost';
        
    case 5
        fitfun= 'Balerma_Cost';
end


end
function Network_Name  = set_Network_name(Network_Number)


switch Network_Number
    
    case 1
        Network_Name= 'NewYorkdouble.inp';
        
    case 2
        Network_Name= 'NewYorkdouble.inp'; % 2 * NYTP
        
    case 3
        Network_Name= 'NewYorkdouble.inp'; %(50 * NYTP)
        
    case 4
        Network_Name= 'Hanoi.inp';
        
    case 5
        Network_Name= 'Balerma.inp';
end

end

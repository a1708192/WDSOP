function xstart= initialize_xstart(Network_Number,Min_Dim,Max_Dim,Num_Pipes)


switch Network_Number
    
    case 1
        xstart=unifrnd(Min_Dim,Max_Dim,[1 Num_Pipes/2] );
        
    case 2
        xstart=unifrnd(Min_Dim,Max_Dim,[1 Num_Pipes] ); %2*NYTP
        
        
    case 3
        xstart=unifrnd(Min_Dim,Max_Dim,[1 21*50] );  % 50 * NYTP
        
        
    case 4
        xstart=unifrnd(Min_Dim,Max_Dim,[1 Num_Pipes] );
        
    case 5
       
        xstart=unifrnd(Min_Dim,Max_Dim,[1 Num_Pipes] );
        
end

end
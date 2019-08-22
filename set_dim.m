function Diameters         = set_dim(Network_Number)

switch Network_Number
    
    case 1
       Diameters         = [0,36,48,60,72,84,96,108,120,132,144,156,168,180,192,204] ;
    case 2
        Diameters         = [0,36,48,60,72,84,96,108,120,132,144,156,168,180,192,204];
    case 3
        Diameters         = [0,36,48,60,72,84,96,108,120,132,144,156,168,180,192,204];
    case 4
        Diameters         = [304.8 406.4 508 609.6 762 1016];
    case 5
        Diameters         = [113 126.6 144.6 162.8 180.8 226.2 285 361.8 452.2 581.8]; %(mm)
end
end
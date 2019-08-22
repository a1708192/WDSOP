function [Head,Demand,Flow,Velocity,Energy]=getNodeDetails(Xmin)

global  G_NYTP
Dim1=[180,180,180,180,180,180,132,132,180,204,204,204,204,204,204,72,72,60,60,60,72];
Dim=[Dim1';Xmin];
for ii=22:size(Dim,1)
    if Dim(ii,1)==0
        G_NYTP.setLinkStatus(ii,0)
        G_NYTP.setLinkDiameter(ii,0.01) % Set new link diameter
    else
        G_NYTP.setLinkDiameter(ii,Dim(ii,1)) % Set new link diameter
    end
end
H = G_NYTP.getComputedHydraulicTimeSeries; %Solve hydraulics in library
Head     = H.Head;
Demand   = H.Demand;
Flow     = H.Flow;
Velocity = H.Velocity;
Energy   = H.Energy;
end
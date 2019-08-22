function [Pressure_Nodes,Length_Pipes,Head_Pressure_Nodes]=GetComputedHydraulic(arx)

global  G_NYTP
for ii=22:size(arx,1)
    if arx(ii,1)==0
        G_NYTP.setLinkStatus(ii,0)
        G_NYTP.setLinkDiameter(ii,0.01) % Set new link diameter
    else
        G_NYTP.setLinkDiameter(ii,arx(ii,1)) % Set new link diameter
    end
end
H = G_NYTP.getComputedHydraulicTimeSeries; %Solve hydraulics in library
Pressure_Nodes    = H.Pressure;
Length_Pipes      = G_NYTP.LinkLength;
Head_Pressure_Nodes=H.Head;

end
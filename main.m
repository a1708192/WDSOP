function []=main()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%   Optimizing the water distribution system by Covariance Matrix
%%%%%   Adaptation Greedy Search
%%%%%   PhD student : Mehdi Neshat (Computer Science Department, Adelaide
%%%%%   University, neshat_mehdi@gmail.com)
%%%%%   Supervisors : Dr.Alexander & Dr.Simpson
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%    13/03/2018     Implementation is started

% cmaes.m, Version 3.61.beta, last change: April, 2012
% CMAES implements an Evolution Strategy with Covariance Matrix
% Adaptation (CMA-ES) for nonlinear function minimization.
% cmaes.m runs with MATLAB (Windows, Linux) and,
% without data logging and plotting, it should run under Octave
% (Linux, package octave-forge is needed).
% http://cma.gforge.inria.fr/cmaes_sourcecode_page.html#matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calling the toolkit of the EPANET (OpenWaterAnalytics/?EPANET-Matlab-Toolkit)
% https://au.mathworks.com/matlabcentral/fileexchange/25100-openwateranalytics-epanet-matlab-toolkit
%clear
clc
global G_NYTP;

%% Setting up the Model
start_toolkit()
% Setting the path of C compiler for Matlab
mw_mingw64_log()
% Simulating the New york Tunnel Problem layout by EPANET
Network_Number= 1;
Network_Name  = set_Network_name(Network_Number);
% 'NYTP          ==> 1'
% 'NewYorkdouble ==> 2'
% 'NYTP50        ==> 3'
% 'Hanoi         ==> 4'
% 'Balerma       ==> 5'
G_NYTP= epanet(Network_Name);

% all properties of the pipe model
properties(G_NYTP)
Max_Iter         = 30;
% N number different commercially available pipe diameters for WDS
Diameters         = set_dim(Network_Number);
Min_Dim           = min (Diameters)
Max_Dim           = max (Diameters)
Diameters_Pipes   = G_NYTP.LinkDiameter;
Num_Pipes         = G_NYTP.LinkPipeCount;
Length_Pipes      = G_NYTP.LinkLength;
Num_Nodes         = G_NYTP.NodeCount;
elevations        = G_NYTP.NodeElevations;
Num_Reservoir     = G_NYTP.NodeReservoirCount;
methods(G_NYTP)   % Lists all available methods
G_NYTP.plot       % Plots the network in a MATLAB figure
disp ('Please Press a key..................')
pause(1)
close(figure(1));
H                 = G_NYTP.getComputedHydraulicTimeSeries ;% Solve hydraulics in library
Pressure_Nodes    = H.Pressure;
Flow_Pipes        = H.Flow;

%% CMA-ES SETUPS
for ii=1:Max_Iter
    fitfun             = set_fitfun(Network_Number);
    options.CostF      = Def_fitfun(Network_Number);     % Up and Downward greedy cost function 
    options.NS         = Def_Iter(Network_Number);       % the iterative network sections
    options.CV         = Def_Constraint(Network_Number); % Nodal pressure head constraints
    options.BestC      = set_Bestfmin(Network_Number);   % Estimation of the best founded network cost design
    xstart             = initialize_xstart(Network_Number,Min_Dim,Max_Dim,Num_Pipes);
    varargin           = [];
    inopts.DispModulo  = 1;
    inopts.LBounds     = min(Diameters);
    inopts.UBounds     = max(Diameters);
    inopts.PopSize     = 200;
    inopts.TolFun      = Def_TolFun(Network_Number);
    inopts.MaxFunEvals = set_Max_Eval(Network_Number,inopts.PopSize);
    inopts.StopIter    = round(inopts.MaxFunEvals/inopts.PopSize);
    insigma            = 0.5*(inopts.UBounds-inopts.LBounds);
    Pipe.UGSflag       = 0;
    Pipe.DGSflag       = 0;
    %%
    %% CMA-ES
    
    [   counteval, ... % number of function evaluations done
        stopflag, ...  % stop criterion reached
        out, ...       % struct with various histories and solutions
        bestever, ...   % struct containing overall best solution (for convenience)
        Pipe] = cmaes( fitfun, ...    % name of objective/fitness function
        xstart, ...    % objective variables initial point, determines N
        insigma, ...   % initial coordinate wise standard deviation(s)
        inopts, ...    % options struct, see defopts below
        Network_Number,...
        Diameters,...
        Pipe,...
        options,...
        varargin ...   % arguments passed to objective function
        );
    %%
    %% Correcting the diameters of the best solution
    %Pipe.xmin=xmin;
    
%     disp(['Best Network design=',mat2str(round(xmin,2))])
%     disp(['Total cost=',num2str(fmin)])
    %Pipe.fmin=fmin;
    
    [Pipe] = Finding_best(Pipe,Network_Number,Diameters,fitfun,options);
   Iter=Def_Iter(Network_Number);
        if  Pipe.DGSflag==1
    [Pipe]=Downward_Greedy_Search(Network_Number,Pipe,length(xstart),options,Iter);
        else
            Pipe.XminD=0;
            Pipe.FminD=0;
        end
    
    save(['CMA_UGS_DGS_Network_small_',num2str(Network_Number),'_Npop_',num2str(inopts.PopSize),'_Sigma_',num2str(round(insigma)),'_ex',num2str(ii),'.mat'],'Pipe')
    pause(2)
    clc
    clear Pipe
end
exit
end


function [Solution]= Dim_Correction (Solution,dim,Network_Number)

Iter=Def_Iter(Network_Number);
N=size(Solution,1);
if N==1
    Solution=Solution';
end
N=round(size(Solution,1)/Iter);
for f=1:Iter
    sol=Solution((f-1)*N+1:f*N);
    for i=1: size(sol,1)
        flag  = 0;
        t_dim = dim;
        for j=1:size(dim,2)
            if sol(i,1)== dim(j)
                flag=1;
                break % the variable is feasible
            end
        end
        if flag==0             % the variable is infeasible
            t_dim(end+1)= sol(i,1);
            t_dim       = sort(t_dim);
            k_index           = find(t_dim==sol(i,1));
            if k_index == 1
                sol(i,1)=t_dim(2);
            end
            if k_index == size(t_dim,2)
                sol(i,1)=t_dim(k_index-1);
            end
            if k_index~=1 && k_index ~= size(t_dim,2)
                dif1        = t_dim(k_index+1)- t_dim(k_index);
                dif2        = t_dim(k_index)- t_dim(k_index-1);
                if dif1 > dif2
                    sol(i,1)= t_dim(k_index-1);
                elseif dif1 < dif2
                    sol(i,1)= t_dim(k_index+1);
                elseif  dif1==dif2
                    r=randi([0 1]);
                    if r==0
                        sol(i,1)= t_dim(k_index+1);
                    else
                        sol(i,1)= t_dim(k_index-1);
                    end
                end
            end
        end
    end
  Solution((f-1)*N+1:f*N)=sol;  
    
    
    
end %end for Iter
end
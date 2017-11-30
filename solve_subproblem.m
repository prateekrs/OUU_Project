function [model,terminate] = solve_subproblem(model,points,labels,budget,val_w,val_w0,tau)
terminate=1;
% implement your code here
N=size(points,1); %number of points in dataset
x=points;

%define parameters for model
K=budget; %budget for flipping labels
M=500; %big M constant

%define second stage primal/dual variables
pi=sdpvar(N,1); 
y=sdpvar(N,1);
z=binvar(N,1);

%define scenario variables
zi=binvar(N,1); %auxilliary 0-1 variable 
v=sdpvar(N,1);

Objective=-sum(y);%define objective
Constraints=[pi<=1-z y>=0 pi>=0 pi<=1 y<=M*(1-z)];  %define constraints for first stage variables

for n=1:N
Constraints=[Constraints y(n)-1+(2*zi(n)-1)*(sum(val_w.*x(n,:)')-val_w0)<=M*z(n) y(n)>=1-(2*zi(n)-1)*(sum(val_w.*x(n,:)')-val_w0)];
end

Constraints=[Constraints v>=zi-labels v>=labels-zi sum(v)<=K];
options = sdpsettings('verbose', 0, 'solver', 'mosek');

sol = optimize(Constraints,Objective,options);

zi_val=round(value(zi));
obj_val=value(Objective);

fprintf('Inner Subproblem Objective: %f \n \n',-obj_val);

norm_diff=abs(tau-(-obj_val));
if norm_diff > 1e-4
    str=mat2str(zi_val');
    len=size(str,2);
    str=str(2:len-1);
    scen=str(find(~isspace(str)));
    model.(genvarname(['y' scen]))=sdpvar(N,1);
model.Constraints=[model.Constraints model.tau>=sum(eval(['model.y' scen])) eval(['model.y' scen])>=0  eval(['model.y' scen])>=1-(2*zi_val-1).*(points*model.w - model.w0)]; 
terminate=0;
end
end
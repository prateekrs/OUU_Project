function [zi_val,z_val,y_val,sol] = subproblem(points,labels,w,w0,budget)

% implement your code here
N=size(points,1); %number of points in dataset
x=points;

%define parameters for model
K=budget %budget for flipping labels
M=10000; %big M constant

%define second stage primal/dual variables
pi=sdpvar(N,1); 
y=sdpvar(N,1);
z=binvar(N,1);

%define scenario variables
zi=binvar(N,1); %auxilliary 0-1 variable 
v=sdpvar(N,1);

Objective=-sum(y);%define objective
Constraints=[pi<=1-z y>=0 pi>=0 pi<=1];  %define constraints for first stage variables

for n=1:N
Constraints=[Constraints y(n)-1+(2*zi(n)-1)*(sum(w.*x(n,:)')-w0)<=M*z(n) y(n)>=1-(2*zi(n)-1)*(sum(w.*x(n,:)')-w0)];
end

Constraints=[Constraints v>=zi-labels v>=labels-zi sum(v)<=K];
options = sdpsettings('verbose', 0, 'solver', 'mosek');

sol = optimize(Constraints,Objective,options)

zi_val=value(zi);
obj_val=value(Objective)
y_val=value(y)
z_val=value(z)
end
function [w,w0,zi_val] = SVM_BestCase(points,labels,budget)
options = sdpsettings('verbose', 0, 'solver', 'mosek');

[N,dims] = size(points);
K=budget

y = sdpvar(N,1);
w = sdpvar(dims,1);
w0 = sdpvar();
zi = binvar(N,1);
v=sdpvar(N,1);


e = ones(N,1);
M = 10000
obj = e'*y;

cons = [y>=0; y>=1+(points*w-w0)-M*zi ; y>=1-(points*w-w0)-M*(1-zi)];
cons=[cons; v>=zi-labels; v>=labels-zi sum(v)<=K];

out = optimize(cons,obj,options);

value(obj)
zi_val=value(zi)
w = double(w);
w0 = double(w0);
end
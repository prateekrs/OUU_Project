function [w,w0] = SVM_Classic(points,labels)
options = sdpsettings('verbose', 0, 'solver', 'mosek');

[N,dims] = size(points);

y = sdpvar(N,1);
w = sdpvar(dims,1);
w0 = sdpvar();
e = ones(N,1);
obj = e'*y;

cons = [y>=0;y >= 1 - (2*labels-1).*(points*w - w0)];
out = optimize(cons,obj,options);

w = double(w);
w0 = double(w0);
end
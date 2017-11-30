function [model] = create_master(points)

[model.N,model.K]=size(points);
model.tau=sdpvar();
model.w=sdpvar(model.K,1);
model.w0=sdpvar();

model.Objective=model.tau;
model.Constraints=[];
end
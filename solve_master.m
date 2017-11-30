function [sol,val_obj,val_tau,val_w,val_w0] = solve_master(model,options)
val_obj=-inf;
val_tau=-inf;
val_w=ones(model.K,1);
val_w0=0;

sol = optimize(model.Constraints,model.Objective,options);
if sol.problem==0
val_obj=value(model.Objective);
val_tau=value(model.tau);
val_w=value(model.w);
val_w0=value(model.w0);
end
end
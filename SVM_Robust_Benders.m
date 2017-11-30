function [val_w , val_w0] = SVM_Robust_Benders(points,labels,budget)
timerVal = tic;
options = sdpsettings('verbose', 0, 'solver', 'mosek');

model=create_master(points)
fprintf('Base Model Created');

terminate=0;
iter=0;
while terminate==0
    iter=iter+1;
    [sol,val_obj,val_tau,val_w,val_w0]=solve_master(model,options);
    fprintf('Iter:%d , Val_Obj:%f \n',iter,val_obj);
    [model,terminate]=solve_subproblem(model,points,labels,budget,val_w,val_w0,val_tau);
end

end
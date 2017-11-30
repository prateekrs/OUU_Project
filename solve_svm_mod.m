sample_size1=50;
sample_size2=50;


mu1=[5,5]';
sigma1=[1,0;0,1];
r1 = mvnrnd(mu1,sigma1,sample_size1);

mu2=[-2,-2]';
sigma2=[1,0;0,1];
r2 = mvnrnd(mu2,sigma2,sample_size2);
points=[r1;r2];

labels1=zeros(size(r1,1),1);
labels2=ones(size(r2,1),1);
labels2((r2(:,1)>=-2)+(r2(:,2)>=-2)==2)=0;
labels=[labels1;labels2];

budget = 10;


hold on;
x=points(:,1);
y=points(:,2);
plot(x(labels==1),y(labels==1),'+')
plot(x(labels==0),y(labels==0),'*')

%plot classic SVM classifier
[w_c,w0_c] = SVM_Classic(points,labels);
x1 = linspace(-5,5,100);
x2 = (w0_c - w_c(1)*x1)/w_c(2);
scatter(x1,x2,'.r');

%plot robust SVM classifier
[w_r,w0_r] = SVM_Robust(points,labels,budget);
x1 = linspace(-5,5,100);
x2 = (w0_r - w_r(1)*x1)/w_r(2);
scatter(x1,x2,'.k');

%plot worst case labels for robust SVM classifier
[zi_val,z_val,y_val,sol]=subproblem(points,labels,w_r,w0_r,2)
worst_labels=points(zi_val~=labels,:)
plot(worst_labels(:,1),worst_labels(:,2),'o')

%plot best SVM classifier
x1 = linspace(-5,5,100);
[w_b,w0_b,zi_val] = SVM_BestCase(points,labels,budget);
x2 = (w0_b - w_b(1)*x1)/w_b(2);
scatter(x1,x2,'.g');
best_labels=points(zi_val~=labels,:)
plot(best_labels(:,1),best_labels(:,2),'o')

%plot robust SVM classifier
[w_benders,w0_benders] = SVM_Robust_Benders(points,labels,budget);
x1 = linspace(-5,5,100);
x2 = (w0_benders - w_benders(1)*x1)/w_benders(2);
scatter(x1,x2,'.g');
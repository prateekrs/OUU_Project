% N = 20;
% dims = 2;
% points = rand(N,dims);
% labels = zeros(N,1);
% for i = 1:N
%     if points(i,1)>points(i,2)
%         labels(i) = 1;
%     end
% end

sample_size1=7;
sample_size2=7;


mu1=[5,5]';
sigma1=[1,0;0,1];
r1 = mvnrnd(mu1,sigma1,sample_size1);

mu2=[-2,-2]';
sigma2=[1,0;0,1];
r2 = mvnrnd(mu2,sigma2,sample_size2);
points=[r1;r2];
labels1=zeros(size(r1,1),1);
labels2=ones(size(r2,1),1);
labels2((r2(:,1)>=-2)+(r2(:,2)>=-2)==2)=1;
labels=[labels1;labels2];

budget = 2;

[w_c,w0_c] = SVM_Classic(points,labels);

[w_r,w0_r] = SVM_Robust(points,labels,budget);

hold on;
p = points(labels==1,:);
scatter(p(:,1),p(:,2),10,'r');
p = points(labels==0,:);
scatter(p(:,1),p(:,2),10,'b');

x1 = linspace(0,1,100);
x2 = (w0_c - w_c(1)*x1)/w_c(2);
scatter(x1,x2,'.k');

x1 = linspace(0,1,100);
x2 = (w0_r - w_r(1)*x1)/w_r(2);
scatter(x1,x2,'.g');
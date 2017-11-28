
sample_size1=50;
sample_size2=50;


mu1=[5,5]';
sigma1=[1,0;0,1]
r1 = mvnrnd(mu1,sigma1,sample_size1);

mu2=[-2,-2]';
sigma2=[1,0;0,1];
r2 = mvnrnd(mu2,sigma2,sample_size2);


points=[r1;r2];
labels1=zeros(size(r1,1),1);
labels2=ones(size(r2,1),1);
labels2((r2(:,1)>=-2)+(r2(:,2)>=-2)==2)=0;
labels=[labels1;labels2];

hold on
x=points(:,1);
y=points(:,2);
plot(x(labels==1),y(labels==1),'+')
plot(x(labels==0),y(labels==0),'*')
options = sdpsettings('verbose', 0, 'solver', 'mosek');


N=size(points,1);
dims=size(points,2);
    
y = sdpvar(N,1);
w = sdpvar(dims,1);
w0 = sdpvar();
e = ones(N,1);
obj = e'*y;

cons = [y>=0;y >= 1 - (2*labels-1).*(points*w - w0)];
out = optimize(cons,obj,options);


w0=value(w0);
w1=value(w(1));
w2=value(w(2));

x=-5:0.1:5;
y=(w0-w1*x)/w2;
plot(x,y)

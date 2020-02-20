%���˹�˺���
load('disease_circRNA_A.mat');
%���㼲���ĸ�˹
Gaussian_Dis = zeros(89,89);
pare_a=0; %����
sum=0; %��¼����
temp=0;
%���������а������ģ�
for i=1:89   %����
    temp=norm(A(i,:));
    sum=sum+temp^2;
end
pare_a=1/(sum/89);

for i=1:89
    i
    for j=1:89
        Gaussian_Dis(i,j)=exp(-pare_a*(norm(A(i,:)-A(j,:))^2));
    end
end

%����miRNA�ĸ�˹
Gaussian_cricR = zeros(533,533);
pare_b=0; %����
sum=0; %��¼����
temp=0;
%��������
for i=1:533   %����
    temp=norm(A(:,i));
    sum=sum+temp^2;
end
pare_b=1/(sum/533);

for i=1:533
    i
    for j=1:533
        Gaussian_cricR(i,j)=exp(-pare_b*(norm(A(:,i)-A(:,j))^2));
    end
end

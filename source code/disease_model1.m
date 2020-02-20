% %-------�ⲿ�ֲ���ÿ�ζ��ܣ��Ѿ��������----------
% DirStr=['./data/MeshID.txt'];
% fidin=fopen(DirStr);             % ��txt�ļ�    
% 
% MeshID=cell(11241,2);  %����MeshID���ݣ��ֳ����ֺͽṹ������
% i=1;
% while ~feof(fidin)                                                       % �ж��Ƿ�Ϊ�ļ�ĩβ               
%     tline=fgetl(fidin); 
%     if tline 
%         SStr = regexp(tline, ';', 'split');
%         MeshID(i,1)=SStr(1);
%         MeshID(i,2)=SStr(2);
%         i=i+1;
%     end
% end
% fclose(fidin);
% %����ΪMeshID.mat 


%-------�ⲿ�ֲ���ÿ�ζ��ܣ��Ѿ��������----------
load('CircR2Disease.mat');
load('Mesh_disease.mat');
load('MeshID_DV_all.mat');
load('MeshID.mat');













%�Ȼ����½ڵ�Ľṹ����
disease_Str=cell(4594,2); %����ڵ�Ľṹ���У�4594ΪmeshID�нڵ������
for i=1:4594
    i
   disease_Str(i,1)=strtrim(cellstr(Mesh_Disease(i)));
   for j=1:11241
       if strcmpi(disease_Str(i),MeshID(j,1))
           disease_Str(i,2)=strcat(disease_Str(i,2),MeshID(j,2),'-');
       end
   end
end

 Dise_Num=89;%����������
% 
 DV=cell(Dise_Num,10); %��һ�б���ڵ��DVֵ�����汣��ڵ�ṹ��һ�д���һ�㣬���ǺŸ���
% 
% ����õ�DV�Ľڵ�
for i=1:Dise_Num
    i    
    j=3; %DV�ӵ����п�ʼ���溢�ӽڵ㣬�ڶ��б����Լ�
    DV=add_node(i,j,DV,disease{i,1},disease_Str,MeshID);
    DV(i,2)=strcat(disease(i,1),'*');
end










%��ʱ�õ���DV����ȫ�����У�Ҫ��ͷɨ�裬����ȥ���ظ��ģ���������ʵ����󻯽ڵ���
for i=1:Dise_Num
    i
    for j=3:10
        if isempty(DV{i,j})
            break;
        else
            Temp3=regexp(DV{i,j}, '*', 'split');
            [h3,l3] = size(Temp3);
            for k=1:l3  %ȥ���ظ���
                for p=j:10  
                    if ~isempty(DV{i,p})
                        Temp5=regexp(DV{i,p}, '*', 'split');
                        [h5,l5]=size(Temp5);
                        for q=1:l5 %�����صģ����Լ�Ҳɾȥ���ں�������Լ�
                            if strcmpi(Temp3(1,k),Temp5(1,q))
                                Temp5{1,q}=[]; %��cell����ֵ
                            end
                        end
                        if p==j %���Լ��ǲ㣬����
                            Temp5=[Temp5,Temp3(1,k)];
                        end
                        
                        %����д��ȥ�غ��DV,ÿ��DVֵ���涼���˸�'*'
                        DV{i,p} = [];
                        [h6,l6]=size(Temp5);
                        for q=1:l6
                            if ~isempty(Temp5{1,q})
                                DV(i,p) = strcat(Temp5(1,q),'*',DV(i,p));
                            end
                        end
                    end
                    
                end
            end
        end
    end
end

%����DV��ֵ
for i=1:Dise_Num
     if isempty(DV{i,3}) 
        DV(i,1)=num2cell(1);
     else
        j=3;
        value=1;
        aa=0.5  %��Ĳ���
        while  j<=10 && ~isempty(DV{i,j})
            Temp3 = regexp(DV{i,j}, '*', 'split'); %��ȥ�غ��DV��i,j���м����ڵ�
            [h3,l3] = size(Temp3);
            value = value + aa*(l3-1); %��¼ֵ
            aa=aa*0.5;  %ÿ��һ�㣬��˸�0.5
            j=j+1;
        end
        DV(i,1)=num2cell(value);
     end
end
%%%%%%%%%%%%%%%����DV 


%-------DV_all�Ǵ�MeshID_str���ģ��ⲿ�ֲ���ÿ�ζ��ܣ��Ѿ��������----------
%����DV_all��ֵ��DV_all�Ǵ�MeshID_str.mat����
for i=1:4594
     if isempty(DV_all{i,3}) 
        DV_all(i,1)=num2cell(1);  
     else
        j=3;
        value=1;
        aa=0.5  %��Ĳ���
        while ~isempty(DV_all{i,j})
            Temp3 = regexp(DV_all{i,j}, '*', 'split'); %��ȥ�غ��DV_all��i,j���м����ڵ�
            [h3,l3] = size(Temp3);
            value = value + aa*(l3-1); %��¼ֵ
            aa=aa*0.5;  %ÿ��һ�㣬��˸�0.5
            j=j+1;
        end
        DV_all(i,1)=num2cell(value);
     end
end
%%%%%%%%%%%%����DV_all



% 
S=zeros(Dise_Num,Dise_Num); %���յľ���
%�������������������ǵĹ�ͬ�ڵ㣬�����
for i=1:Dise_Num
    i
    for j=1:Dise_Num
        if i==14 && j==12
           aaa=[]; 
        end
        %�������i�򼲲�j����DV�У�S(i,j)=0
        if isempty(DV{i,3})|| isempty(DV{j,3})
            S(i,j)=0;
        else
            %�ҵ����������¸��Եĺ��ӽڵ�
            dis1_str='';
            dis2_str='';
            for k=2:10
                if ~isempty(DV{i,k})
                    dis1_str=strcat(dis1_str,DV{i,k});
                end
            end
            for k=2:10
                if ~isempty(DV{j,k})
                    dis2_str=strcat(dis2_str,DV{j,k});
                end
            end
            
            
            %��mesh����
            dis1=regexp(dis1_str,'*','split');  %����1�����к��ӽڵ�
            dis2=regexp(dis2_str,'*','split');  %����2�����к��ӽڵ�
            %����ͬ�ڵ�
            [h5,l5] = size(dis1);
            [h6,l6] = size(dis2);
            for p=1:l5-1
                for q=1:l6-1  
                    if strcmpi(dis1(1,p),dis2(1,q))
                        value_Same=0;  %��ʼ����ͬ�ڵ�ļ���ֵ
                        value_Same1=0;  %��ʼ����ͬ�ڵ�ļ���ֵ
                        value_Same2=0;  %��ʼ����ͬ�ڵ�ļ���ֵ
                        for k=1:4594  %��ͬ�ļ���������ֵ
                            if strcmpi(dis1(1,p),disease_Str(k,1))
%                                 jj=2;%�ӵ�һ���ң����㿪ʼ��
%                                 aa=0.5;  %��Ĳ���
%                                 value5=0;
%                                 while ~isempty(DV_all{k,jj})
%                                     Temp5 = regexp(DV_all{k,jj},'*','split'); %���¿�ȥ�غ��DV��i,j���м����ڵ�
%                                     [h7,l7] =  size(Temp5);
%                                     value5 = value5 + aa*(l7-1); %��¼ֵ
%                                     aa=aa*0.5;  %ÿ��һ�㣬��˸�0.5
%                                     jj=jj+1;
%                                 end
%                                 value_Same=value5;
                                  value_Same=0.5*DV_all{k,1}; %��DV_all�е�ֵ�������ټ�����
                                  break;
                            end
                        end
                        %���ڵ�1�ڸü����ĵڼ��㣬��ȫ��mesh��
                        [bool,inx1]=ismember(disease{i,1},disease_Str(:,1));
                        if inx1 > 0
                            C_num=2; %��ʼ���ڵ�һ��
                            for r=2:10
                                if ~isempty(DV_all{inx1,r})
                                    Temp6 = regexp(DV_all{inx1,r},'*','split');
                                    [h8,l8]=size(Temp6);
                                    for rr=1:l8
                                        if strcmpi(dis1(1,p),Temp6(1,rr))
                                            C_num=r;
                                            break;
                                        end
                                    end 
                                end
                            end
                           value_Same1=0.5^(C_num-3)*value_Same; 
                        end
             
                         %���ڵ�2�ڸü�������ĵڼ���
                        [bool,inx2]=ismember(disease{j,1},disease_Str(:,1));
                        if inx2 > 0
                            C_num2=2; %��ʼ���ڵ�һ��
                            for r2=2:10
                                if ~isempty(DV_all{inx2,r2}) && inx2~=0
                                    Temp7 = regexp(DV_all{inx2,r2},'*','split');
                                    [h9,l9]=size(Temp7);
                                    for rr=1:l9
                                        if strcmpi(dis2(1,q),Temp7(1,rr))
                                            C_num2=r2;
                                            break;
                                        end
                                    end 
                                end
                            end
                           value_Same2=0.5^(C_num2-3)*value_Same;
                        end
                        
                        value_s=(value_Same1+value_Same2)/(DV{i,1}+DV{j,1});
                        if S(i,j)<value_s  %%ֻ���������
                            S(i,j)=value_s;
                            break;    %%�ҵ����������
                        end
                       break;
                    end
                end
            end
        end
        
        %���ͬһ���������Խ��ߣ���i=j����ֵΪ1
        if i==j
            S(i,j)=1;
        end
    end
end
%%%%%%%%%%%%%%%����S

    %�ݹ麯������DV�ӽڵ�
function  DV=add_node(i,j,DV,node,disease_Str,MeshID)
    %j
    str=find_node(node,disease_Str,MeshID);
    
     if ~isempty(str{1,1}) 
        [hh3,ll3]=size(str);
        for aa=1:ll3 
           for bb=aa+1:ll3
               if strcmp(str(1,aa),str(1,bb))
                    str{1,bb}=[];
               end
           end
        end
        
        if ~isempty(DV{i,j})  
            Temp_a=regexp(DV{i,j},'*','split');
            [hh1,ll1]=size(Temp_a);
            for aa=1:ll1
                for bb=1:ll3
                    if strcmp(Temp_a(1,ll1),str(1,ll3))
                        str{1,ll3}=[];
                    end
                end
            end
        end
        
        for k=1:ll3
            if ~isempty(str{1,k}) 
                DV(i,j)=strcat(DV(i,j),'*',str(1,k));
            end
        end

        for k=1:ll3
            DV=add_node(i,j+1,DV,str{1,k},disease_Str,MeshID);
        end
    end
end


function str  = find_node(node,disease_Str,MeshID)
    for i=1:4594 
        if strcmpi(node,disease_Str(i,1))
           Temp1=regexp(disease_Str{i,2}, '-', 'split'); 
           [h1,l1] = size(Temp1);
           node_num=cell(1,l1-1); 
           str=cell(1,l1-1);
           for j=1:l1-1
                Temp2=regexp(Temp1{1,j}, '\.', 'split');
                [h2,l2] = size(Temp2);
                for k=1:l2-1   
                    if k==1
                        node_num(j) = Temp2(1,k);
                    else
                        node_num(j) = strcat(node_num(j),'.',Temp2(1,k));
                    end
                end
                for k=1:11241
                   if  strcmpi(node_num(j),MeshID(k,2))
                       str(1,j)=MeshID(k,1);
                   end
                end
           end  
           break;
           
        else
         str=cell(1,1);   
        end
        
    end
end



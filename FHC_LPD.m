% Please kindly cite the paper Junyi Guan, Sheng li, Xiongxiong He, Jinhui Zhu, and Jiajia Chen 
%"Fast hierarchical clustering of local density peaks via an association degree transfer method," 
% Neurocomputing,2021,Doi:10.1016/j.neucom.2021.05.071

% The code was written by Junyi Guan in 2021.

function [CL] = FHC_LPD(data,k,C)
%k: the number of neighbors
%C: the number of clusters
close all
[n,d]  = size(data); 

%% Normalization
data=(data-min(data))./(max(data)-min(data));
data(isnan(data))=0;
%% Fast KNN based on kd-tree (when dimension is not large than 10)
if d<=11
    [knn,knn_dist] = knnsearch(data,data,'k',k);
else
    dist = pdist2(data,data,'euclidean');
    [knn_dist,knn] = sort(dist,2);
end
%% calculate the knn-density value
rho=knn_dist(:,k).^-1; %% 
%% search for NPN(neighbor-parent node) and record depth value
[~,OrdRho]=sort(rho,'descend');
for i=1:n
    omega(i)= 0; % omega: depth value
end
for i=1:n
    for j=2:k
        neigh=knn(OrdRho(i),j);
        if(rho(OrdRho(i))<rho(neigh))
            NPN(OrdRho(i))=neigh;
            omega(OrdRho(i))= omega(neigh) + 1;
            break
        end
    end
end
%% find sub-cluster centers(namely local density peaks)
sub_centers = find(omega==0);
n_sc = length(sub_centers);
%% generate sub-clsuters
for i=1:n
    sub_L(i)=-1; 
end
sub_L(sub_centers) = (1:n_sc);
for i=1:n
    if (sub_L(OrdRho(i))==-1)
        sub_L(OrdRho(i))=sub_L(NPN(OrdRho(i)));
    end
end
%% calculate center-association degree PHI
lambda = 0.9; % lambda: the association degree between each point and its neighbor-parent node.
AAA = lambda .^ (0:n-1);
for i=1:n
    PHI(i) = AAA(omega(i)+1);
end
%% calculate SIM(similarity) matrix between sub-clusters
PHIMatrix = zeros(n_sc,n_sc);
for i=1:n
    for j = 2:k
        jj = knn(i,j);
        PHISum = PHI(jj)+PHI(i);
        if sub_L(i)~=sub_L(jj) & PHIMatrix(sub_L(i),sub_L(jj))<PHISum
            if find(knn(jj,2:k)==i)
                PHIMatrix(sub_L(i),sub_L(jj)) = PHISum;
                PHIMatrix(sub_L(jj),sub_L(i)) = PHISum;
            end
        end
    end
end
SIM = zeros(n_sc,n_sc);
SIM_list = [];
for i=1:n_sc-1
    for j =i+1:n_sc
        if PHIMatrix(i,j)>0 & PHIMatrix(j,i)>0
            SIM(i,j) = PHIMatrix(i,j)/2; %% InterPenetration of cl=i and cl=j;
        end
        SIM_list = [SIM_list SIM(i,j)];
    end
end
%% SingleLink clustering of sub-clusters according to SIM
SingleLink = linkage(1-SIM_list,'single');
F_sub_L = cluster(SingleLink,C); 
%% assign final cluster label
for i=1:n_sc
    AA = find(sub_L==i);
    CL(AA) = F_sub_L(i); %% CL: the cluster label
end

%% draw result
scrsz = get(0,'ScreenSize');
figure('Position',[650 472 scrsz(3)/2 scrsz(4)/1.5]);
cmap = colormap;
%% show dendrogram
subplot(2,2,1:2)
dendrogram(SingleLink,0);
axis([0 n_sc+1 0 1]);
xlabel ('sub-cluster','FontSize',20.0);
ylabel ('similarity','FontSize',20.0);

title('dendrogram','FontSize',20);
set(gca,'YTickLabel','');
hold on
%% show sub-clusters
subplot(2,2,3)
for i=1:n_sc
    ic=int8((i*64.)/(n_sc*1.));
    AA = find(sub_L== i);
    plot(data(AA,1),data(AA,2),'o','MarkerSize',4,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
    text(data(sub_centers(i),1)-0.010,data(sub_centers(i),2), num2str(i),'FontSize',10,'Color','r','FontWeight','Bold');
    hold on
end
title('sub-clusters','FontSize',20);
set(gca,'XTickLabel','');
set(gca,'YTickLabel','');
%% show clustering result
subplot(2,2,4)
for i=1:C
    ic=int8((i*64.)/(C*1.));
    AA = find(CL== i);
    plot(data(AA,1),data(AA,2),'o','MarkerSize',4,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
    hold on
end
set(gca,'XTickLabel','');
set(gca,'YTickLabel','');
hold on
title('clustering Result','FontSize',20);







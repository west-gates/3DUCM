function spb(fileseq)

filename=['temp/file_',num2str(fileseq),'_maxgl.mat'];
load(filename);
g=maxgl(:,:,:,1);
siz=size(g);

vect2=zeros(siz(1),siz(2),siz(3),17);


filename=['temp/file_',num2str(fileseq),'_Eigs.mat'];
load(filename);


for v=1:17
    vect2(:, :, :,v) = reshape(EigVect_reduce(:, v), [siz(1) siz(2) siz(3)]);
end

for v=1:17
    vect2(:,:,:,v)=(vect2(:,:,:,v)-min(min(min(vect2(:,:,:,v)))))/(max(max(max(vect2(:,:,:,v))))-min(min(min(vect2(:,:,:,v)))));
end

spb_val=zeros(siz);

for v=1:17
	disp(['Computing sPb, file ',num2str(fileseq),' eigen ',num2str(v)]);
	tic
	lambda=EVal_reduce(v+1,v+1);
	spb_val=spb_val+(1/sqrt(lambda))*ncc_grad(vect2(:,:,:,v));
	toc
end

spb_val=spb_val/max(max(max(spb_val)));
g=g/max(max(max(g)));

gpb=(spb_val+g)/2;

% nonzero_strength=gpb(find(gpb>0));

% highthresh=prctile(nonzero_strength(:),80);
% lowthresh=prctile(nonzero_strength(:),10);

% ind = find (gpb > highthresh);
% BW = gpb >  lowthresh;
% e = selectCc (BW,6,single(ind));
% edges=gpb.*e;
% %ee=edges/max(max(max(edges)));
% %imshow(squeeze(ee(:,50,:)));


% w=watershed(edges);
% wt=zeros(siz);
% wt(w==0)=1;


% imshow(squeeze(wt(:,50,:)));

%save('spb_mpnr2.mat','spb_val');
svname=['temp/file_',num2str(fileseq),'_sPb.mat'];
save(svname,'spb_val');

svname=['temp/file_',num2str(fileseq),'_gPb.mat'];
save(svname,'gpb');



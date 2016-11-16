function thin_g = ncc_grad(intensity)



%scales=[2,4,6];
scales=[4];
dirs=directions(4);
ndirs=size(dirs,2);
%weights=[1;1;1];
weights=[1];

%fname='ibsr_1_raw.mat';

% load(fname);
% intensity=reduce_size(data_raw,size(data_raw),max(scales));
intensity_2=intensity.^2;

nx=size(intensity,1);
ny=size(intensity,2);
nz=size(intensity,3);

ncc1=zeros(ndirs,nx,ny,nz,length(scales));
idx=1;

for radius=scales
	[x,y,z]=meshgrid(-radius:radius,-radius:radius,-radius:radius);
	sphere_mask=double((x.^2+y.^2+z.^2)<=(radius*radius));
	nnonz=nnz(sphere_mask);
	
	EX=imfilter(intensity,sphere_mask,'replicate');
	EX2=imfilter(intensity_2,sphere_mask,'replicate');
	variance=sqrt(max(0,EX2-(EX.^2/nnonz)));
	var_reciprocal=1./(mean(variance(:))+variance);

	for i = 1:ndirs
		dir=dirs(:,i);
		dx=dir(1)*ones(2*radius+1,2*radius+1,2*radius+1);
		dy=dir(2)*ones(2*radius+1,2*radius+1,2*radius+1);
		dz=dir(3)*ones(2*radius+1,2*radius+1,2*radius+1);

		prodx=x.*dx;
		prody=y.*dy;
		prodz=z.*dz;

		prod_mask=(prodx+prody+prodz).*sphere_mask;
		prod_mask=sign(prod_mask);

		prod_mask=prod_mask-mean(prod_mask(:));
		prod_mask=prod_mask/norm(prod_mask(:));

		grad=abs(imfilter(intensity,prod_mask,'replicate'));
		ncc1(i,:,:,:,idx)=grad.*var_reciprocal;
		%ncc1(i,:,:,:,idx)=grad;
	end

	idx=idx+1;
end

ncc2 = reshape(ncc1(:), ndirs*nx*ny*nz, length(scales));
w = weights./ sum(weights);
all_strength = reshape(ncc2 * w, ndirs, nx,ny,nz);


max_strength=zeros(nx,ny,nz);
max_xdir=zeros(nx,ny,nz);
max_ydir=zeros(nx,ny,nz);
max_zdir=zeros(nx,ny,nz);
maxgl=zeros(nx,ny,nz,3);
thin_strength=false(nx,ny,nz);

for i = 1:ndirs
	dir=dirs(:,i);
	strength = squeeze(all_strength(i,:,:,:));
	changes = find(strength > max_strength);
	maximas=strength>max_strength;
	max_strength = max(strength, max_strength);
	max_xdir(changes)=dir(1);
	max_ydir(changes)=dir(2);
	max_zdir(changes)=dir(3);

	suppressed=nonmax(strength,dir);

	thin_strength=(maximas&suppressed)|(~maximas&thin_strength);
	%thin_strength=thin_strength|suppressed;
end
thin_g=max_strength.*thin_strength;
% maxgl(:,:,:,1)=max_strength.*thin_strength;
% %maxgl(:,:,:,1)=max_strength;
% maxgl(:,:,:,2)=max_xdir;
% maxgl(:,:,:,3)=max_ydir;
% maxgl(:,:,:,4)=max_zdir;



%subplot(121)
%imshow(squeeze(grad(:,:,50)/max(max(max(grad(:,:,:))))));
% imshow(squeeze(thin_strength(:,50,:)));
% subplot(122)
% imshow(squeeze(max_strength(:,50,:)/max(max(max(strength(:,:,:))))));


% nonzero_strength=max_strength(find(max_strength>0));

% highthresh=prctile(nonzero_strength(:),70);
% lowthresh=prctile(nonzero_strength(:),20);

% ind = find (max_strength > highthresh);
% BW = thin_strength & (max_strength >  lowthresh);
% e = selectCc (BW, [],ind);
% edges=max_strength.*e;
% ee=edges/max(max(max(edges)));
% imshow(squeeze(ee(:,50,:)));


% zeroind=find(edges==0);
% max_xdir(zeroind)=0;
% max_ydir(zeroind)=0;
% max_zdir(zeroind)=0;

% maxgl(:,:,:,1)=edges;
% maxgl(:,:,:,2)=max_xdir;
% maxgl(:,:,:,3)=max_ydir;
% maxgl(:,:,:,4)=max_zdir;

% save('maxg_ncc.mat','maxgl');


% g_cut=prctile(unsuppressed(:),30);
% g_wt=unsuppressed.*(unsuppressed>g_cut);
% wt=watershed(g_wt);
% wts=zeros(size(wt));
% wts(find(wt==0))=1;
% imshow(squeeze(wts(:,50,:)));
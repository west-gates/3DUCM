function max_grad(scales,fileseq)

dirs=directions(4);
ndirs=size(dirs,2);

filename=['temp/file_',num2str(fileseq),'_siz.mat'];
load(filename);

nx=siz(1);
ny=siz(2);
nz=siz(3);

nchannels=3;

maxgl=zeros(nx,ny,nz,4);
max_g=zeros(nx,ny,nz);
max_gx=zeros(nx,ny,nz);
max_gy=zeros(nx,ny,nz);
max_gz=zeros(nx,ny,nz);



for j =1:nchannels



	max_strength=zeros(nx,ny,nz);
	max_xdir=zeros(nx,ny,nz);
	max_ydir=zeros(nx,ny,nz);
	max_zdir=zeros(nx,ny,nz);
	thin_strength=false(nx,ny,nz);

	for i = 1:ndirs
		dir=dirs(:,i);
		filename=['grad/file_',num2str(fileseq),'_channel_',num2str(j),'_dir_',num2str(i),'.mat'];
		load(filename)
		strength=gl(:,:,:,1);
		changes = find(strength > max_strength);
		maximas=strength>max_strength;
		max_strength = max(strength, max_strength);
		max_xdir(changes)=dir(1);
		max_ydir(changes)=dir(2);
		max_zdir(changes)=dir(3);

		suppressed=nonmax(strength,dir);

		thin_strength=(maximas&suppressed)|(~maximas&thin_strength);
		disp(['max gradient, file ',num2str(fileseq),' channel ',num2str(j),' direction ',num2str(i)]);
		%thin_strength=thin_strength|suppressed;
	end

	%max_strength=max_strength/max(max_strength(:));

	updates=find(max_strength>max_g);
	max_g=max_g+max_strength;
	max_gx(updates)=max_xdir(updates);
	max_gy(updates)=max_ydir(updates);
	max_gz(updates)=max_zdir(updates);

end

%thin_g=max_strength.*thin_strength;
%maxgl(:,:,:,1)=thin_g;
maxgl(:,:,:,1)=max_g;
maxgl(:,:,:,2)=max_gx;
maxgl(:,:,:,3)=max_gy;
maxgl(:,:,:,4)=max_gz;

svname=['temp/file_',num2str(fileseq),'_maxgl.mat'];
save(svname,'maxgl');

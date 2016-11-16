function multiscale_grads(data,scales,fileseq,channel_num)
dirs=directions(4);

%siz_raw=size(data_raw);

%data=reduce_size(data_raw,siz_raw,max(scales));
data=smooth3(data,'gaussian',[3 3 3],sqrt(3));
siz=size(data);

x_range=1:siz(1);
y_range=1:siz(2);
z_range=1:siz(3);

gl=zeros(siz(1),siz(2),siz(3),4);



for m = 1:length(dirs)
	nvector=dirs(:,m)';

	dif=sign(floor(nvector*10));


	for i = x_range
		disp(['file ',num2str(fileseq),', Generating gradients, dir ',num2str(m),' channel ',num2str(channel_num),' now x level ', num2str(i)]);
		for j = y_range
			for k = z_range
				for l = scales
					gvalue=grad_local([i,j,k],nvector,l,siz,data);
					gl(i,j,k,1)=gl(i,j,k,1)+gvalue;
				end
				gl(i,j,k,2:4)=dirs(:,m);
			end
		end
	end

	filename=['grad/file_',num2str(fileseq),'_channel_',num2str(channel_num),'_dir_',num2str(m),'.mat'];
	save(filename,'gl');

	% %non-maximum suppression
	% for i = x_range
	% 	disp(['Non-maximum suppression, dir No. ',num2str(m),', now x level ', num2str(i)]);
	% 	for j = y_range
	% 		for k =z_range
	% 			if gl(i,j,k,1)<max([gl(i,j,k,1),gl(i+dif(1),j+dif(2),k+dif(3),1),gl(i-dif(1),j-dif(2),k-dif(3),1)])
	% 				gl(i,j,k,1)=0;
	% 			end
	% 		end
	% 	end
	% end

	% filename=['nms_grad/nms_dir_',num2str(m),'.mat'];
	% save(filename,'gl');

end

% x_range=1:siz(1);
% y_range=1:siz(2);
% z_range=1:siz(3);

% max_mgnt=zeros(length(x_range),length(y_range),length(z_range));
% max_vecx=zeros(length(x_range),length(y_range),length(z_range));
% max_vecy=zeros(length(x_range),length(y_range),length(z_range));
% max_vecz=zeros(length(x_range),length(y_range),length(z_range));

% for m = 1:13
% 	nvector=dirs(:,m);
% 	filename=['grad/grad_dir_',num2str(m),'.mat'];
% 	load(filename);
% 	gl=gl(x_range,y_range,z_range,:);
% 	magnitude=squeeze(gl(:,:,:,1));
% 	changes=find(magnitude>=max_mgnt);
% 	max_mgnt(changes)=magnitude(changes);
% 	max_vecx(changes)=nvector(1);
% 	max_vecy(changes)=nvector(2);
% 	max_vecz(changes)=nvector(3);
% end

% maxgl=zeros(length(x_range),length(y_range),length(z_range),4);
% maxgl(:,:,:,1)=max_mgnt;
% maxgl(:,:,:,2)=max_vecx;
% maxgl(:,:,:,3)=max_vecy;
% maxgl(:,:,:,4)=max_vecz;

% svname=['temp/max_mgnt.mat'];
% save(svname,'maxgl');

% max_mgnt=zeros(length(x_range),length(y_range),length(z_range));
% max_vecx=zeros(length(x_range),length(y_range),length(z_range));
% max_vecy=zeros(length(x_range),length(y_range),length(z_range));
% max_vecz=zeros(length(x_range),length(y_range),length(z_range));

% for m = 1:13
% 	nvector=dirs(:,m);
% 	filename=['nms_grad/nms_dir_',num2str(m),'.mat'];
% 	load(filename);
% 	gl=gl(x_range,y_range,z_range,:);
% 	magnitude=squeeze(gl(:,:,:,1));
% 	changes=find(magnitude>=max_mgnt);
% 	max_mgnt(changes)=magnitude(changes);
% 	max_vecx(changes)=nvector(1);
% 	max_vecy(changes)=nvector(2);
% 	max_vecz(changes)=nvector(3);
% end

% maxgl=zeros(length(x_range),length(y_range),length(z_range),4);
% maxgl(:,:,:,1)=max_mgnt;
% maxgl(:,:,:,2)=max_vecx;
% maxgl(:,:,:,3)=max_vecy;
% maxgl(:,:,:,4)=max_vecz;


% svname=['temp/max_nms_mgnt.mat'];
% save(svname,'maxgl');
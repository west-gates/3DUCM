function affinity_block(fileseq)

edge_radius=2;
nblocks=10;

filename=['temp/file_',num2str(fileseq),'_maxgl.mat'];
load(filename);

max_mgnt=maxgl(:,:,:,1);
max_vecx=maxgl(:,:,:,2);
max_vecy=maxgl(:,:,:,3);
max_vecz=maxgl(:,:,:,4);

% x_range=1:100;
% y_range=30:36;
% z_range=1:100;
% max_mgnt=max_mgnt(x_range,y_range,z_range);
% max_vecx=max_vecx(x_range,y_range,z_range);
% max_vecy=max_vecy(x_range,y_range,z_range);
% max_vecz=max_vecz(x_range,y_range,z_range);


clear maxgl;

mmm=max(max(max(max_mgnt)));
max_mgnt=max_mgnt/mmm;

siz=size(max_mgnt);

block_size=floor(siz(3)/nblocks);

zstarts=(0:(nblocks-1))*block_size+1;
zends=(1:nblocks)*block_size;
zends(end)=siz(3);
nodestarts=(zstarts-1)*siz(2)*siz(1)+1;
nodeends=((zends-1)*siz(2)+siz(2)-1)*siz(1)+siz(1);


for l = 1:nblocks
	rowindex=zeros(1,(nodeends(l)-nodestarts(l)+1)*(2*edge_radius+1)^3);
	columnindex=zeros(1,(nodeends(l)-nodestarts(l)+1)*(2*edge_radius+1)^3);
	affinities=zeros(1,(nodeends(l)-nodestarts(l)+1)*(2*edge_radius+1)^3);
	count=1;
	for k = zstarts(l):zends(l)
		tic
		for j = 1:siz(2)
			for i = 1:siz(1)
				edge_neighbors=get_edge_neighbors(i,j,k,siz,edge_radius);
				neighbor_size=size(edge_neighbors,1);
				for p = 1:neighbor_size
					nx=edge_neighbors(p,1);
					ny=edge_neighbors(p,2);
					nz=edge_neighbors(p,3);
					[origin_ind,neighbor_ind,affinity_val]=get_affinity(i,j,k,nx,ny,nz,siz,max_mgnt,max_vecx,max_vecy,max_vecz);
					rowindex(count)=neighbor_ind;
					columnindex(count)=origin_ind;
					affinities(count)=affinity_val;
					count=count+1;
				end
			end
		end
		disp(['Affinity, file ',num2str(fileseq),' Block ',num2str(l),' now at z level ',num2str(k)]);
		toc
	end
	rowindex=rowindex(1:(count-1));
	columnindex=columnindex(1:(count-1));
	affinities=affinities(1:(count-1));
	columnindex=columnindex-nodestarts(l)+1;
	W=sparse(rowindex,columnindex,affinities,prod(siz),(nodeends(l)-nodestarts(l)+1));
	svname=['blockfile/file_',num2str(fileseq),'aff_block_',num2str(l),'.mat'];
	save(svname,'W');
	clear affinity_matrix,W;
end


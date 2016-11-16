function L_eigs(fileseq)

filename=['temp/file_',num2str(fileseq),'_maxgl.mat'];
load(filename);
mpb=maxgl(:,:,:,1);

% x_range=1:100;
% y_range=30:36;
% z_range=1:100;
% mpb=mpb(x_range,y_range,z_range);
siz=size(mpb);
disp(['Generating L, file ',num2str(fileseq)]);
tic

neib_rd=1;
neib_sz=2*neib_rd+1;
sigma=3;

labels=watershed(mpb);

neighbors = im3col(double(padarray(labels,[neib_rd neib_rd neib_rd])), [neib_sz neib_sz neib_sz]);

[X,Y,Z] = meshgrid(-neib_rd:neib_rd,-neib_rd:neib_rd,-neib_rd:neib_rd);

weight = exp(-(X.^2 + Y.^2 + Z.^2)/(sigma^2));

neighbor_weights = bsxfun(@times, (neighbors > 0), weight(:));

neighbor_weights = bsxfun(@times, neighbor_weights, 1./sum(neighbor_weights,1));

maxlabel = max(labels(:));

neighbors(neighbors == 0) = maxlabel + 1;

col_idx = repmat (1:numel(labels), size(neighbors,1), 1);

L = sparse (col_idx(:), neighbors(:), neighbor_weights(:));

L(:,end) = [];

%save('L_2.mat','L');
toc

disp(['Multiplication by blocks, file ',num2str(fileseq)]);
tic

%load('L_2.mat');

nblocks=10;

block_size=floor(siz(3)/nblocks);
zstarts=(0:(nblocks-1))*block_size+1;
zends=(1:nblocks)*block_size;
zends(end)=siz(3);
nodestarts=(zstarts-1)*siz(2)*siz(1)+1;
nodeends=((zends-1)*siz(2)+siz(2)-1)*siz(1)+siz(1);

[wx,wy]=size(L);

Dvalue=zeros(1,wx);
W2=sparse(zeros(wy));

for l = 1:nblocks
	tic
	filename=['blockfile/file_',num2str(fileseq),'aff_block_',num2str(l),'.mat'];
	load(filename);
	LW=L'*W;
	Dvalue(nodestarts(l):nodeends(l))=full(sum(W,1));
	clear W;
	svname=['blockfile/file_',num2str(fileseq),'LW_',num2str(l),'.mat'];
	save(svname,'LW');
	clear LW;
	toc
end

D=sparse(1:wx,1:wx,Dvalue,wx,wx);
D2=L'*D*L;
clear D,Dvalue;


for l = 1:nblocks
	tic
	filename=['blockfile/file_',num2str(fileseq),'LW_',num2str(l),'.mat'];
	load(filename);
	W2=W2+LW*L(nodestarts(l):nodeends(l),:);
	clear LW;
	toc
end
toc
disp(['Solving Eigens, file ',num2str(fileseq)]);
opts.issym=1;
opts.isreal = 1;
neigs=17;

tic

[EigVect, EVal_reduce] = eigs(D2 - W2, D2, neigs+1, 'sm', opts);

toc

[evs, sort_order] = sort(full(diag(EVal_reduce)));
EigVect = EigVect(:, sort_order);

EigVect_reduce = L * EigVect(:,2:end);

svname=['temp/file_',num2str(fileseq),'_Eigs.mat'];
save(svname,'EVal_reduce','EigVect_reduce');


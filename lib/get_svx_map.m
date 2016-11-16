function [nodex,nodey,edgevalue,wnb]=get_svx_map(fileseq,L,A,B)

filename=['temp/file_',num2str(fileseq),'_maxgl.mat'];
load(filename);
filename=['temp/file_',num2str(fileseq),'_gPb.mat'];
load(filename);
gx=maxgl(:,:,:,2);
gy=maxgl(:,:,:,3);
gz=maxgl(:,:,:,4);

nonzero_strength=gpb(find(gpb>0));

highthresh=prctile(nonzero_strength(:),80);
lowthresh=prctile(nonzero_strength(:),10);

ind = find (gpb > highthresh);
BW = gpb >  lowthresh;
e = selectCc (BW,6,single(ind));
edges=gpb.*e;

w=watershed(edges);

maxLabel=max(w(:));

dirs=directions(4);
siz=size(w);
wnb=w;
superaff=zeros(maxLabel,maxLabel);

boundary=find(w==0);

for i = 1:length(boundary)
	disp(['file_',num2str(fileseq),'_processing boundary ',num2str(i),'/',num2str(length(boundary))]);

	[x,y,z]=ind2sub(siz,boundary(i));
	Lx=L(x,y,z);
	Ax=A(x,y,z);
	Bx=B(x,y,z);

	nnx=0;
	nny=0;
	nnz=0;
	nndist=inf;



	[x_range,y_range,z_range] =  get_boundary_neighbor(siz,x,y,z,1);

	neighborhood=w(x_range,y_range,z_range);
	max_neighbor=max(neighborhood(:));




	if max_neighbor>0
		for l = x_range
			for m = y_range
				for n = z_range
					if w(l,m,n)~=0
						Ln=L(l,m,n);
						An=A(l,m,n);
						Bn=B(l,m,n);
						distance=sqrt((Lx-Ln)^2+(Ax-An)^2+(Bx-Bn)^2);

						if distance<nndist
							nnx=l;
							nny=m;
							nnz=n;
							nndist=distance;
						end
					end
				end
			end
		end
	else
		[x_range,y_range,z_range] =  get_boundary_neighbor(siz,x,y,z,2);
		for l = x_range
			for m = y_range
				for n = z_range
					if w(l,m,n)~=0
						Ln=L(l,m,n);
						An=A(l,m,n);
						Bn=B(l,m,n);
						distance=sqrt((Lx-Ln)^2+(Ax-An)^2+(Bx-Bn)^2);

						if distance<nndist
							nnx=l;
							nny=m;
							nnz=n;
							nndist=distance;
						end
					end
				end
			end
		end
	end

	wnb(boundary(i))=w(nnx,nny,nnz);


	for j = 1:length(dirs)
		dir=dirs(:,j);
		shiftunit=sign(fix(10*dir));
		nx=x-shiftunit(1);
		ny=y-shiftunit(2);
		nz=z-shiftunit(3);
		px=x+shiftunit(1);
		py=y+shiftunit(2);
		pz=z+shiftunit(3);

		if (nx>0)&(nx<=siz(1))&(ny>0)&(ny<=siz(2))&(nz>0)&(nz<=siz(3))&(px>0)&(px<=siz(1))&(py>0)&(py<=siz(2))&(pz>0)&(pz<=siz(3))

			nneighbour=min(w(nx,ny,nz),w(px,py,pz));
			pneighbour=max(w(nx,ny,nz),w(px,py,pz));


			if (pneighbour-nneighbour ~= 0)&(nneighbour+pneighbour >= 2)&(nneighbour*pneighbour~=0)
				superaff(nneighbour,pneighbour) = 1;
			end
		end
	end

end


[nodex,nodey,edgexy]=find(superaff>0);

edgevalue=zeros(length(nodex),1);

% for i = 1:length(nodex)
% 	disp(['file_',num2str(fileseq),'_getting chi ',num2str(i),'/',num2str(length(nodex))]);
% 	LabelX=nodex(i);
% 	LabelY=nodey(i);

% 	edgevalue(i)=get_chi(LabelX,LabelY,wnb,L,A,B);
% end
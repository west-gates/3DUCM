function hierarchical_watershed(fileseq)

% fileseq=1;

disp(['Watershed, file ',num2str(fileseq),' supervoxel affinity']);
tic;

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

superaff=single(zeros(maxLabel,maxLabel));
superaff_weight=single(zeros(maxLabel,maxLabel));
boundary=find(w==0);

dirs=directions(4);
siz=size(w);
wnb=w;



for i = 1:length(boundary)
	[x,y,z]=ind2sub(siz,boundary(i));
	mxgx=gx(x,y,z);
	mxgy=gy(x,y,z);
	mxgz=gz(x,y,z);

	[x_range,y_range,z_range] =  get_boundary_neighbor(siz,x,y,z,1);
	neighborhood=w(x_range,y_range,z_range);
	max_neighbor=max(neighborhood(:));

	if max_neighbor>0
		wnb(boundary(i))=max_neighbor;
	else
		[x_range,y_range,z_range] =  get_boundary_neighbor(siz,x,y,z,2);
		neighborhood=w(x_range,y_range,z_range);
		max_neighbor=max(neighborhood(:));
		wnb(boundary(i))=max_neighbor;
	end

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

			nneighbour=w(nx,ny,nz);
			pneighbour=w(px,py,pz);

			if (nneighbour-pneighbour ~= 0)&(nneighbour+pneighbour >= 2)&(nneighbour*pneighbour~=0)
				superaff(nneighbour,pneighbour) = superaff(nneighbour,pneighbour)+1;
				superaff(pneighbour,nneighbour) = superaff(pneighbour,nneighbour)+1;
				weight=abs(gpb(x,y,z)*(mxgx*dir(1)+mxgy*dir(2)+mxgz*dir(3)));
				superaff_weight(nneighbour,pneighbour)=superaff_weight(nneighbour,pneighbour)+weight;
				superaff_weight(pneighbour,nneighbour)=superaff_weight(pneighbour,nneighbour)+weight;
			end
		end
	end

	

end

toc;


tic;
dvdsuperaff=single(superaff);
dvdsuperaff(dvdsuperaff==0)=1;
weights=single(superaff_weight./dvdsuperaff);
clear dvdsuperaff;
% weights=superaff_weight;

nonzero_ind=find(weights>0);
nonzero_weights=weights(nonzero_ind);
indmin=find(weights==min(nonzero_weights(:)));

hier=zeros(size(w));
level=1;
labels=1:maxLabel;

while length(indmin)>0
	current_ind=indmin(1);
	[indnx,indny]=ind2sub(size(weights),current_ind);
	labelx=labels(indnx);
	labely=labels(indny);
	interregion=find_interregion(w,labelx,labely);
	hier(interregion)=level;

	if (maxLabel-level) == 1
		break;
	end

	affx=superaff(indnx,:);
	wghtsx=superaff_weight(indnx,:);
	affy=superaff(indny,:);
	wghtsy=superaff_weight(indny,:);
	affz=affx+affy;
	wghtsz=wghtsx+wghtsy;

	superaff([indnx,indny],:)=[];
	superaff(:,[indnx,indny])=[];
	new_superaff=single(superaff);
	clear superaff;
	superaff=single(zeros(maxLabel-level,maxLabel-level));
	superaff(1:end-1,1:end-1)=new_superaff;
	clear new_superaff;
	affz([indny,indnx])=[];
	superaff(end,1:end-1)=affz;
	superaff(1:end-1,end)=affz;

	superaff_weight([indnx,indny],:)=[];
	superaff_weight(:,[indnx,indny])=[];
	new_superaff_weight=single(superaff_weight);
	clear superaff_weight;
	superaff_weight=single(zeros(maxLabel-level,maxLabel-level));
	superaff_weight(1:end-1,1:end-1)=new_superaff_weight;
	clear new_superaff_weight;
	wghtsz([indny,indnx])=[];
	superaff_weight(end,1:end-1)=wghtsz;
	superaff_weight(1:end-1,end)=wghtsz;

	labels([indnx,indny])=[];
	labels=[labels,maxLabel+level];
	w(w==labelx)=maxLabel+level;
	w(w==labely)=maxLabel+level;
	wnb(wnb==labelx)=maxLabel+level;
	wnb(wnb==labely)=maxLabel+level;

	if ((maxLabel-level)<1000)&(mod((maxLabel-level),100)==0)
		svname=['results/file_',num2str(fileseq),'_level_',num2str(maxLabel-level),'.mat'];
		save(svname,'wnb');
	elseif (mod((maxLabel-level),1000)==0)
		svname=['results/file_',num2str(fileseq),'_level_',num2str(maxLabel-level),'.mat'];
		save(svname,'wnb');
	end



	disp(['Watershed, file ',num2str(fileseq),' merging ',num2str(maxLabel-level),'/',num2str(maxLabel)]);
	

	level=level+1;

	dvdsuperaff=single(superaff);
	dvdsuperaff(dvdsuperaff==0)=1;
	weights=single(superaff_weight./dvdsuperaff);
	clear dvdsuperaff;
	%weights=superaff_weight;

	nonzero_ind=find(weights>0);

	if length(nonzero_ind) == 0
		break;
	end

	nonzero_weights=weights(nonzero_ind);
	indmin=find(weights==min(nonzero_weights(:)));
end

toc;









% tic;
% superaff(superaff==0)=1;
% weights=superaff_weight./superaff;


% nonzero_ind=find(weights>0);
% nonzero_weights=weights(nonzero_ind);
% [indnx,indny]=ind2sub(size(weights),nonzero_ind);

% [weights_sort,I]=sort(nonzero_weights);

% affrank=zeros(size(superaff));
% affrank(nonzero_ind)=I;






% hier=zeros(size(w));


% for i = 1:length(nonzero_ind)
% 	interregion=find_interregion(w,indnx(I(i)),indny(I(i)));
% 	hier(interregion)=i;
% 	disp(i);
% end


% for i = 1:length(boundary)
% 	adjmtx=adjacencies{i};
% 	cnt=adjmtx(length(dirs)+1,1);
% 	finalrank=0;
% 	if cnt>1
% 		for j = 1:(cnt-1);
% 			rx=adjmtx(j,1);
% 			ry=adjmtx(j,2);
% 			temprank=max(affrank(rx,ry),affrank(ry,rx));
% 			finalrank=max(temprank,finalrank);
% 		end

% 		hier(boundary(i))=finalrank;
% 	end
% end



%hier=hier/max(hier(:));
% imshow(squeeze(hier(:,50,:)));
% toc;
% wt=zeros(size(hier));
% wt(hier>0.9999)=1;
% imshow(squeeze(wt(:,50,:)));
svname=['results/file_',num2str(fileseq),'_hierarchy.mat'];
save(svname,'hier');




% wt=zeros(size(hier));
% wt(b>0.9)=1;
% imshow(squeeze(wt(:,50,:)));












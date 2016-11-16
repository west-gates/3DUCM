function interregion = find_interregion(w,p,q)

indb=find(w==0);

dirs=directions(4);

siz=size(w);
w(1,:,:)=0;
w(siz(1),:,:)=0;
w(:,1,:)=0;
w(:,siz(2),:)=0;
w(:,:,1)=0;
w(:,:,siz(3))=0;


indp=find(w==p);
[px,py,pz]=ind2sub(size(w),indp);

for i = 1:length(dirs)
	dir=dirs(:,i);
	shiftunit=sign(fix(10*dir));
	pxs=px+shiftunit(1);
	pys=py+shiftunit(2);
	pzs=pz+shiftunit(3);
	indps=sub2ind(size(w),pxs,pys,pzs);
	indp=union(indp,indps);

	pxs=px-shiftunit(1);
	pys=py-shiftunit(2);
	pzs=pz-shiftunit(3);
	indps=sub2ind(size(w),pxs,pys,pzs);
	indp=union(indp,indps);
end


indq=find(w==q);
[qx,qy,qz]=ind2sub(size(w),indq);

for i = 1:length(dirs)
	dir=dirs(:,i);
	shiftunit=sign(fix(10*dir));
	qxs=qx+shiftunit(1);
	qys=qy+shiftunit(2);
	qzs=qz+shiftunit(3);
	indqs=sub2ind(size(w),qxs,qys,qzs);
	indq=union(indq,indqs);
	qxs=qx-shiftunit(1);
	qys=qy-shiftunit(2);
	qzs=qz-shiftunit(3);
	indqs=sub2ind(size(w),qxs,qys,qzs);
	indq=union(indq,indqs);
end

interregion=intersect(indp,indq);
interregion=intersect(interregion,indb);
function [origin_ind,neighbor_ind,affinity_val]=get_affinity(x,y,z,nx,ny,nz,siz,max_mgnt,max_vecx,max_vecy,max_vecz);
%input:
%x,y,z: origin voxel's coordinate
%nx,ny,nz: neighbor voxel's coordinate
%siz: size of the volume
%max_mgnt,max_vecx,max_vecy,max_vecz: the gradient information
%output:
%origin_ind: origin voxel's index in affinity matrix
%neighbor_ind: neighbor voxel's index in affinity matrix
%affinity_val: corresponding affinity value


lx=nx-x;
ly=ny-y;
lz=nz-z;

dirnorm=sqrt(lx^2+ly^2+lz^2);

if dirnorm == 1
	origin_ind=x+siz(1)*(y-1+siz(2)*(z-1));
	affinity_val=1;
	neighbor_ind=nx+siz(1)*(ny-1+siz(2)*(nz-1));
else
	lx=lx/dirnorm;
	ly=ly/dirnorm;
	lz=lz/dirnorm;

	%get the in between voxesls near the line
	x_range=min(x,nx):max(x,nx);
	y_range=min(y,ny):max(y,ny);
	z_range=min(z,nz):max(z,nz);

	[meshX,meshY,meshZ]=meshgrid(x_range,y_range,z_range);
	ix=meshX(:);
	iy=meshY(:);
	iz=meshZ(:);

	ox=ix-x;
	oy=iy-y;
	oz=iz-z;

	projectionO=ox*lx+oy*ly+oz*lz;
	hypotenuseO=ox.*ox+oy.*oy+oz.*oz;
	distances=real(sqrt(hypotenuseO-projectionO.^2));

	onx=ix-nx;
	ony=iy-ny;
	onz=iz-nz;

	projectionON=onx*lx+ony*ly+onz*lz;
	hypotenuseON=onx.*onx+ony.*ony+onz.*onz;

	cosProd=projectionO.*projectionON;

	index=find(cosProd<0&hypotenuseO>0&hypotenuseON>0&distances<=1);

	origin_ind=x+siz(1)*(y-1+siz(2)*(z-1));
	affinity_val=1;
	neighbor_ind=nx+siz(1)*(ny-1+siz(2)*(nz-1));

	if length(index)==0
		%inprod=abs(lx*max_vecx(nx,ny,nz)+ly*max_vecy(nx,ny,nz)+lz*max_vecz(nx,ny,nz));
		%affinity_val=exp(-inprod*max_mgnt(nx,ny,nz)/0.1);
		affinity_val=1;
	else
		for j = 1:length(index)
			i=index(j);
			inprod=abs(lx*max_vecx(ix(i),iy(i),iz(i))+ly*max_vecy(ix(i),iy(i),iz(i))+lz*max_vecz(ix(i),iy(i),iz(i)));
			affinity_val=min(affinity_val,exp(-inprod*max_mgnt(ix(i),iy(i),iz(i))/0.1));
			%affinity_val=min(affinity_val,exp(-inprod*max_mgnt(ix(i),iy(i),iz(i))));
		end
	end
end




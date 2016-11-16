function suppressed = nonmax(strength,dir)
shiftunit=sign(fix(10*dir));
nx=size(strength,1);
ny=size(strength,2);
nz=size(strength,3);

center=zeros(nx+4,ny+4,nz+4);
shift1=zeros(nx+4,ny+4,nz+4);
shift2=zeros(nx+4,ny+4,nz+4);
shift3=zeros(nx+4,ny+4,nz+4);
shift4=zeros(nx+4,ny+4,nz+4);

xidx=3:(2+nx);
yidx=3:(2+ny);
zidx=3:(2+nz);

center(xidx,yidx,zidx)=strength;

shifting=shiftunit;
xidxshft=xidx+shifting(2);
yidxshft=yidx+shifting(1);
zidxshft=zidx+shifting(3);
shift1(xidxshft,yidxshft,zidxshft)=strength;

shifting=-shiftunit;
xidxshft=xidx+shifting(2);
yidxshft=yidx+shifting(1);
zidxshft=zidx+shifting(3);
shift2(xidxshft,yidxshft,zidxshft)=strength;

shifting=2*shiftunit;
xidxshft=xidx+shifting(2);
yidxshft=yidx+shifting(1);
zidxshft=zidx+shifting(3);
shift3(xidxshft,yidxshft,zidxshft)=strength;

shifting=-2*shiftunit;
xidxshft=xidx+shifting(2);
yidxshft=yidx+shifting(1);
zidxshft=zidx+shifting(3);
shift4(xidxshft,yidxshft,zidxshft)=strength;

suppressed=(center>shift1)&(center>shift2)&(center>shift3)&(center>shift4);
suppressed=suppressed(xidx,yidx,zidx);

% subplot(141)
% imshow(squeeze(shift1(:,:,50)/max(max(max(shift1(:,:,:))))));
% subplot(142)
% imshow(squeeze(shift2(:,:,50)/max(max(max(shift2(:,:,:))))));
% subplot(143)
% imshow(squeeze(shift3(:,:,50)/max(max(max(shift3(:,:,:))))));
% subplot(144)
% imshow(squeeze(shift4(:,:,50)/max(max(max(shift4(:,:,:))))));
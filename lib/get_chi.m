function ev=get_chi(LabelX,LabelY,wnb,L,A,B)


RegionLX=L(find(wnb==LabelX));
RegionLY=L(find(wnb==LabelY));
RegionAX=A(find(wnb==LabelX));
RegionAY=A(find(wnb==LabelY));
RegionBX=B(find(wnb==LabelX));
RegionBY=B(find(wnb==LabelY));

RegionLX_h=histc(RegionLX,0:5:100);
RegionLY_h=reshape(histc(RegionLY,0:5:100),size(RegionLX_h));
RegionAX_h=histc(RegionAX,-50:5:50);
RegionAY_h=reshape(histc(RegionAY,-50:5:50),size(RegionAX_h));
RegionBX_h=histc(RegionBX,-50:5:50);
RegionBY_h=reshape(histc(RegionBY,-50:5:50),size(RegionBX_h));

nnzL=find((RegionLX_h+RegionLY_h)~=0);
nnzA=find((RegionAX_h+RegionAY_h)~=0);
nnzB=find((RegionBX_h+RegionBY_h)~=0);

RegionLX_h=RegionLX_h(nnzL)./sum(RegionLX_h);
RegionLY_h=RegionLY_h(nnzL)./sum(RegionLY_h);
RegionAX_h=RegionAX_h(nnzA)./sum(RegionAX_h);
RegionAY_h=RegionAY_h(nnzA)./sum(RegionAY_h);
RegionBX_h=RegionBX_h(nnzB)./sum(RegionBX_h);
RegionBY_h=RegionBY_h(nnzB)./sum(RegionBY_h);

chiL=0.5*sum(((RegionLX_h-RegionLY_h).^2)./(RegionLX_h+RegionLY_h));
chiA=0.5*sum(((RegionAX_h-RegionAY_h).^2)./(RegionAX_h+RegionAY_h));
chiB=0.5*sum(((RegionBX_h-RegionBY_h).^2)./(RegionBX_h+RegionBY_h));

ev=chiL+chiA+chiB;
function gl = grad_local(voxel,nvector,radius,siz,raw_data)
x=voxel(1);
y=voxel(2);
z=voxel(3);


x_low=max(1,x-radius);
x_high=min(siz(1),x+radius);
y_low=max(1,y-radius);
y_high=min(siz(2),y+radius);
z_low=max(1,z-radius);
z_high=min(siz(3),z+radius);

x_range=x_low:x_high;
y_range=y_low:y_high;
z_range=z_low:z_high;

num_voxels=length(x_range)*length(y_range)*length(z_range);
pos_half=zeros(1,ceil(num_voxels/2));
neg_half=zeros(1,ceil(num_voxels/2));
pos_count=1;
neg_count=1;

for i =x_range
	for j = y_range
		for k =z_range
			if (((i-x)*nvector(1)+(j-y)*nvector(2)+(k-z)*nvector(3))>0)&&(((x-i)^2+(y-j)^2+(z-k)^2)<=radius^2)
				pos_half(pos_count)=raw_data(i,j,k);
				pos_count=pos_count+1;
			elseif (((i-x)*nvector(1)+(j-y)*nvector(2)+(k-z)*nvector(3))<0)&&(((x-i)^2+(y-j)^2+(z-k)^2)<=radius^2)
				neg_half(neg_count)=raw_data(i,j,k);
				neg_count=neg_count+1;
			end
		end
	end
end


if(pos_count-1)*(neg_count-1) == 0
	gl=0;
else
	pos_half=pos_half(1:(pos_count-1));
	neg_half=neg_half(1:(neg_count-1));

	pos_hist=histc(pos_half,0:0.1:1);
	neg_hist=histc(neg_half,0:0.1:1);

	nonzeros=find((pos_hist+neg_hist)~=0);

	pos_hist=pos_hist(nonzeros);
	neg_hist=neg_hist(nonzeros);

	pos_hist=pos_hist/sum(pos_hist);
	neg_hist=neg_hist/sum(neg_hist);

	gl=0.5*sum(((pos_hist-neg_hist).^2)./(pos_hist+neg_hist));
end
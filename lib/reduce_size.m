function data_reduced = reduce_size(raw_data,siz,radius)

for i = 1:siz(1)
	if(max(max(squeeze(raw_data(i,:,:))))>0)
		x_low=max(1,i);
		break;
	end
end

for i = siz(1)-(0:(siz(1)-1))
	if(max(max(squeeze(raw_data(i,:,:))))>0)
		x_high=min(siz(1),i);
		break;
	end
end

for i = 1:siz(2)
	if(max(max(squeeze(raw_data(:,i,:))))>0)
		y_low=max(1,i);
		break;
	end
end

for i = siz(2)-(0:(siz(2)-1))
	if(max(max(squeeze(raw_data(:,i,:))))>0)
		y_high=min(siz(2),i);
		break;
	end
end

for i = 1:siz(3)
	if(max(max(squeeze(raw_data(:,:,i))))>0)
		z_low=max(1,i);
		break;
	end
end

for i = siz(3)-(0:(siz(3)-1))
	if(max(max(squeeze(raw_data(:,:,i))))>0)
		z_high=min(siz(3),i);
		break;
	end
end

data_reduced=raw_data(x_low:x_high,y_low:y_high,z_low:z_high);

%data_reduced((radius+1):(radius+1+x_high-x_low),(radius+1):(radius+1+y_high-y_low),(radius+1):(radius+1+z_high-z_low))=raw_data(x_low:x_high,y_low:y_high,z_low:z_high);
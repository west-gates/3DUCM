function dirs = directions(seg_num)

unit=1/seg_num;

theta=1:(seg_num-1);
fai=0:(seg_num-1);

theta=theta*pi*unit;
fai=fai*pi*unit;

angles=zeros(2,length(theta)*length(fai)+1);

count=1;

for i = 1:length(theta)
	for j = 1:length(fai)
		angles(1,count)=theta(i);
		angles(2,count)=fai(j);
		count=count+1;
	end
end

angles(1,count)=0;
angles(2,count)=0;

dirs=zeros(3,length(angles));


for k = 1:length(angles)
	dirs(1,k)=sin(angles(1,k))*cos(angles(2,k));
	dirs(2,k)=sin(angles(1,k))*sin(angles(2,k));
	dirs(3,k)=cos(angles(1,k));
end
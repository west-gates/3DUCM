function nn=get_edge_neighbors(x,y,z,siz,edge_radius);
%input:
%i,j,k: the coordinate of the origin voxel
%siz:size of the volume
%edge_radius: the side length of the output cube
%output: the neighbors, 3*N matrix

x_low=max(1,x-edge_radius);
y_low=max(1,y-edge_radius);
z_low=max(1,z-edge_radius);
x_high=min(siz(1),x+edge_radius);
y_high=min(siz(2),y+edge_radius);
z_high=min(siz(3),z+edge_radius);

[X,Y,Z]=meshgrid(x_low:x_high,y_low:y_high,z_low:z_high);
nn=[X(:),Y(:),Z(:)];

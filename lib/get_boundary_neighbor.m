function [x_range,y_range,z_range] =  get_boundary_neighbor(siz,x,y,z,radius)


x_low=max(1,x-radius);
x_high=min(siz(1),x+radius);
y_low=max(1,y-radius);
y_high=min(siz(2),y+radius);
z_low=max(1,z-radius);
z_high=min(siz(3),z+radius);

x_range=x_low:x_high;
y_range=y_low:y_high;
z_range=z_low:z_high;


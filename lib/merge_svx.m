function [nodex,nodey,edgevalue,wnb_prev,wnb_new,remain_count,cur_max_lb]=merge_svx(nodex,nodey,edgevalue,wnb,wnb_prev,wnb_new,remain_count,cur_max_lb,min_size,level,L,A,B,c_reg,multiplier,fileseq,foldername)
disp(['start merge, at level ',num2str(1)]);

edge_remain=zeros((remain_count-1),3);
remain_count=1;

merge_count=0;
%[edge_sort,edge_index]=sort(edgevalue);
edge_sort=edgevalue;
edge_index=1:length(edgevalue);

for i = 1:length(edge_sort)
	cur_nd_x=nodex(edge_index(i));
	cur_nd_y=nodey(edge_index(i));

	ind_nd_x=find(wnb==cur_nd_x);
	prev_lb_x=wnb_prev(ind_nd_x(1));
	ind_nd_y=find(wnb==cur_nd_y);
	prev_lb_y=wnb_prev(ind_nd_y(1));


	cur_lb_x=wnb_new(ind_nd_x(1));
	cur_lb_y=wnb_new(ind_nd_y(1));

	if cur_lb_x~=cur_lb_y
		[std_x,size_x]=get_std(L,A,B,wnb_prev,prev_lb_x);
		[std_y,size_y]=get_std(L,A,B,wnb_prev,prev_lb_y);

		if (edge_sort(i)<(multiplier*std_x+c_reg/size_x))&(edge_sort(i)<(multiplier*std_y+c_reg/size_y))
			merge_region=union(find(wnb_new==cur_lb_x),find(wnb_new==cur_lb_y));
			wnb_new(merge_region)=cur_max_lb;
			cur_max_lb=cur_max_lb+1;
			merge_count=merge_count+1;
			disp(['file_',num2str(fileseq),'_level ',num2str(level),' ',num2str(i),'/',num2str(length(edge_sort)),', merge']);
		else
			edge_remain(remain_count,1)=cur_nd_x;
			edge_remain(remain_count,2)=cur_nd_y;
			remain_count=remain_count+1;
			disp(['file_',num2str(fileseq),'_level ',num2str(level),' ',num2str(i),'/',num2str(length(edge_sort)),', remain']);
		end
	end
end

for i = 1:(remain_count-1)
	rem_node_x=edge_remain(i,1);
	rem_node_y=edge_remain(i,2);


	ind_rem_x=find(wnb==rem_node_x);
	rem_cur_x=wnb_new(ind_rem_x(1));
	ind_rem_y=find(wnb==rem_node_y);
	rem_cur_y=wnb_new(ind_rem_y(1));

	edge_remain(i,3)=get_chi(rem_cur_x,rem_cur_y,wnb_new,L,A,B);
	disp(['file_',num2str(fileseq),'_level ',num2str(level),' ',num2str(i),'/',num2str(remain_count-1),', updating']);
end

edge_remain=edge_remain(1:(remain_count-1),:);
nodex=edge_remain(:,1);
nodey=edge_remain(:,2);
edgevalue=edge_remain(:,3);
wnb_prev=wnb_new;

function [nodex,nodey,edgevalue,wnb_prev,wnb_new,remain_count,multiplier,cur_max_lb,n_nodes_rem,sizes,stds]=merge_small_svx(nodex,nodey,edgevalue,wnb,wnb_prev,wnb_new,remain_count,cur_max_lb,min_size,level,merge_count,L,A,B,c_reg,fileseq,foldername)

edge_remain=zeros((remain_count-1),3);
remain_count=1;


[edge_sort,edge_index]=sort(edgevalue);


for i = 1:length(edgevalue)
	cur_nd_x=nodex(edge_index(i));
	cur_nd_y=nodey(edge_index(i));

	ind_nd_x=find(wnb==cur_nd_x);
	prev_lb_x=wnb_prev(ind_nd_x(1));
	ind_nd_y=find(wnb==cur_nd_y);
	prev_lb_y=wnb_prev(ind_nd_y(1));

	cur_lb_x=wnb_new(ind_nd_x(1));
	cur_lb_y=wnb_new(ind_nd_y(1));

	if cur_lb_x~=cur_lb_y
		size_x=length(find(wnb_new==cur_lb_x));
		size_y=length(find(wnb_new==cur_lb_y));

		if (size_x<min_size)||(size_y<min_size)
			merge_region=union(find(wnb_new==cur_lb_x),find(wnb_new==cur_lb_y));
			wnb_new(merge_region)=cur_max_lb;
			cur_max_lb=cur_max_lb+1;
			merge_count=merge_count+1;
			disp(['file_',num2str(fileseq),'_level ',num2str(level),' ',num2str(i),'/',num2str(length(edgevalue)),', size merge']);
		else
			edge_remain(remain_count,1)=cur_nd_x;
			edge_remain(remain_count,2)=cur_nd_y;
			remain_count=remain_count+1;
			disp(['file_',num2str(fileseq),'_level ',num2str(level),' ',num2str(i),'/',num2str(length(edgevalue)),', size remain']);
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
	disp(['file_',num2str(fileseq),'_level ',num2str(level),' ',num2str(i),'/',num2str(remain_count-1),', size updating']);
end

uni_lbs=unique(wnb_new);
stds=zeros(1,length(uni_lbs));
sizes=zeros(1,length(uni_lbs));
n_nodes_rem=length(uni_lbs);


for i = 1:n_nodes_rem
	[stds(i),sizes(i)]=get_std(L,A,B,wnb_new,uni_lbs(i));
end

edge_remain=edge_remain(1:(remain_count-1),:);
nodex=edge_remain(:,1);
nodey=edge_remain(:,2);
edgevalue=edge_remain(:,3);
wnb_prev=wnb_new;

multiplier=(prctile(edgevalue,20)-c_reg/median(sizes))/median(stds);

svname=[foldername,'/level_',num2str(level),'.mat'];
save(svname,'wnb_new');

disp(['file_',num2str(fileseq),'_level ',num2str(level),' finished, ',num2str(merge_count),' changes has been made']);
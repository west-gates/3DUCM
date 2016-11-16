function [std_x,size_x]=get_std(L,A,B,wnb_prev,cur_lb_x)

RL=L(find(wnb_prev==cur_lb_x));
RA=A(find(wnb_prev==cur_lb_x));
RB=B(find(wnb_prev==cur_lb_x));

size_x=length(find(wnb_prev==cur_lb_x));

std_x=(std(RL)/100)+(std(RA)/100)+(std(RB)/100);
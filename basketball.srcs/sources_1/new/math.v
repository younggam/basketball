function collide_dot;
    input [9:0] x;
    input [9:0] y;
    input [9:0] radius;
    input [9:0] dot_x;
    input [9:0] dot_y;
    
    collide_dot=(x-dot_x)*(x-dot_x)+(y-dot_y)*(y-dot_y)<=radius*radius;
endfunction

function collide_line;
    input [9:0] x;
    input [9:0] y;
    input [9:0] radius;
    input [9:0] line_x_left;
    input [9:0] line_x_right;
    input [9:0] line_y;
    
    collide_line=line_x_left+radius<=x&&x<=line_x_right-radius&&line_y>=y&&y>=line_y-radius;
endfunction

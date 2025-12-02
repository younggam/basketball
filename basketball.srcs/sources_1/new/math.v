function collide_dot;
    input [9:0] x;
    input [9:0] y;
    input [9:0] radius;
    input [9:0] dot_x;
    input [9:0] dot_y;
    
    reg signed [11:0] diff_x; // 뺄셈 결과가 음수가 될 수 있으므로 비트 확장 + signed
    reg signed [11:0] diff_y;
    reg signed [23:0] dist_sq; // 제곱 결과를 담을 충분한 공간
    reg signed [23:0] rad_sq;
    
    begin
        // 1. 입력을 signed로 확장하여 뺄셈 수행 (음수 보존)
        diff_x = $signed({1'b0, x}) - $signed({1'b0, dot_x});
        diff_y = $signed({1'b0, y}) - $signed({1'b0, dot_y});
        
        // 2. 제곱 계산
        dist_sq = diff_x * diff_x + diff_y * diff_y;
        rad_sq  = radius * radius;
        
        // 3. 비교 반환
        collide_dot = (dist_sq <= rad_sq);
    end
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

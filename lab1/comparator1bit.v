module comparator(
  output reg less,
  output reg equal,
  output reg greater,
  input a,
  input b
    );
    always@* begin
    less = 0;
        equal = 0;
        greater = 0;
    if(a>b)begin
    greater =1;
    end
    if(a<b)begin
    less=1;
    end
    if(a==b)begin
    equal=1;
    end
    end
endmodule
module sequential_multiplier #(
    parameter DATA_WIDTH = 8,
    // Rezultatul trebuie sa fie dublu ca sa incapa inmultirea
    parameter RESULT_WIDTH = DATA_WIDTH * 2
) (
    input clk,
    input rst_n,

    // Inputuri de control
    input write,        // Incarcam operanzii
    input multiply,     // Calculam produsul
    input display,      // Scoatem rezultatul pe output

    // Date
    input [DATA_WIDTH-1:0] a_in,
    input [DATA_WIDTH-1:0] b_in,
    output reg [RESULT_WIDTH-1:0] out   // Rezultatul final
);

// --- Codificarea starilor ---
localparam [1:0] 
    IDLE          = 2'b00,  // Asteptam
    WRITE_OP      = 2'b01,  // Scriem A si B
    MULTIPLY_OP   = 2'b10,  // Facem inmultirea
    DISPLAY_OUT   = 2'b11;  // Afisam

reg [1:0] current_state, next_state;

// --- Semnale interne ---
// Fire pentru registrele de operanzi
wire [DATA_WIDTH-1:0] reg_a_out, reg_b_out;
wire [DATA_WIDTH-1:0] reg_a_disp, reg_b_disp;
reg reg_a_we, reg_b_we, reg_a_oe, reg_b_oe;

// Fire pentru registrul rezultat
wire [RESULT_WIDTH-1:0] reg_c_out, reg_c_disp;
reg reg_c_we, reg_c_oe;

// Aici tinem rezultatul inmultirii inainte de a-l baga in registru
reg [RESULT_WIDTH-1:0] multiplication_result;

// ----------------------------------------------------
// I. INSTANTIERE MODULE
// ----------------------------------------------------

// Registru pentru primul numar (A)
Register #(
    .DATA_WIDTH(DATA_WIDTH)
) RegA (
    .clk(clk),
    .rst_n(rst_n),
    .we(reg_a_we),
    .oe(reg_a_oe), 
    .data_in(a_in),
    .data_out(reg_a_out),
    .disp_out(reg_a_disp)
);

// Registru pentru al doilea numar (B)
Register #(
    .DATA_WIDTH(DATA_WIDTH)
) RegB (
    .clk(clk),
    .rst_n(rst_n),
    .we(reg_b_we),
    .oe(reg_b_oe), 
    .data_in(b_in),
    .data_out(reg_b_out),
    .disp_out(reg_b_disp)
);

// Registru pentru rezultat (C) - e mai mare (dublu)
Register #(
    .DATA_WIDTH(RESULT_WIDTH)
) RegC (
    .clk(clk),
    .rst_n(rst_n),
    .we(reg_c_we),
    .oe(reg_c_oe), // Cand e 1, scoatem datele pe portul out
    .data_in(multiplication_result),
    .data_out(reg_c_out),
    .disp_out(reg_c_disp)
);

// Logică pentru iesire (un fel de buffer tri-state simulat)
// Daca nu avem permisiunea sa afisam (OE), tinem linia pe 0
always @(*) begin
    out = reg_c_oe ? reg_c_disp : {RESULT_WIDTH{1'b0}}; 
end


// ----------------------------------------------------
// II. ACTUALIZARE STARE (Secvential)
// ----------------------------------------------------
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE; // Reset asincron
    end else begin
        current_state <= next_state;
    end
end

// ----------------------------------------------------
// III. TRANZITII STARI (Combinational)
// ----------------------------------------------------
always @(*) begin
    next_state = current_state; // Default ramanem unde suntem

    case (current_state)
        IDLE: begin
            // Verificam ce comanda am primit
            if (write) begin
                next_state = WRITE_OP;
            end else if (multiply) begin
                next_state = MULTIPLY_OP;
            end else if (display) begin
                next_state = DISPLAY_OUT;
            end
        end
        
        WRITE_OP: begin
            // Prioritati: Scrierea e cea mai importanta aici
            if (write) begin
                next_state = WRITE_OP; 
            end else if (multiply) begin
                next_state = MULTIPLY_OP;
            end else if (display) begin
                next_state = DISPLAY_OUT;
            end else begin
                next_state = IDLE; // Daca nu mai e nimic activ, mergem in repaus
            end
        end

        MULTIPLY_OP: begin
            // Dupa calcul verificam ce facem mai departe
            if (write) begin
                next_state = WRITE_OP;
            end else if (multiply) begin
                next_state = MULTIPLY_OP; 
            end else if (display) begin
                next_state = DISPLAY_OUT;
            end else begin
                next_state = IDLE;
            end
        end

        DISPLAY_OUT: begin
            // Ramanem in afisare cat timp semnalul e sus
            if (write) begin
                next_state = WRITE_OP;
            end else if (multiply) begin
                next_state = MULTIPLY_OP;
            end else if (display) begin
                next_state = DISPLAY_OUT; 
            end else begin
                next_state = IDLE;
            end
        end

        default: next_state = IDLE;
    endcase
end

// ----------------------------------------------------
// IV. LOGICA DE CONTROL SI CALCUL
// ----------------------------------------------------
always @(*) begin
    // Initializam totul pe 0 ca sa nu facem latch-uri
    reg_a_we = 0;
    reg_b_we = 0;
    reg_c_we = 0;
    reg_c_oe = 0;
    
    // Calculam produsul tot timpul (combinational), dar il salvam doar cand trebuie
    multiplication_result = reg_a_disp * reg_b_disp;

    case (current_state)
        
        WRITE_OP: begin
            // Activam scrierea in registrele de intrare
            reg_a_we = 1;
            reg_b_we = 1;
        end
        
        MULTIPLY_OP: begin
            // Scriem rezultatul inmultirii in C
            reg_c_we = 1;
        end
        
        DISPLAY_OUT: begin
            // Activam iesirea
            reg_c_oe = 1; 
        end
        
        IDLE: begin
            // Nu facem nimic
        end
        
    endcase
end

endmodule
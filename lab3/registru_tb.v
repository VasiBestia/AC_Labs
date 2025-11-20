`timescale 1ns/1ps

module Register_tb;

    // Setari de baza: 8 biti si ceas de 10ns (adica 100MHz)
    localparam DATA_WIDTH = 8;
    localparam CLK_PERIOD = 10; 

    // Input-urile pentru modul (ce controlam noi)
    reg clk;
    reg rst_n;
    reg we; // Write Enable
    reg oe; // Output Enable
    reg [DATA_WIDTH-1:0] data_in;

    // Iesirile (ce monitorizam)
    wire [DATA_WIDTH-1:0] data_out;
    wire [DATA_WIDTH-1:0] disp_out; // Iesirea de debug, mereu activa

    // Conectam modulul pe care il testam (DUT)
    Register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) DUT (
        .clk(clk),
        .rst_n(rst_n),
        .we(we),
        .oe(oe),
        .data_in(data_in),
        .data_out(data_out),
        .disp_out(disp_out)
    );

    // Facem ceasul sa bata la infinit
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk; 
    end

    // Aici incepe testarea propriu-zisa
    initial begin
        // --- ADAUGAT PENTRU WAVEFORM ---
        $dumpfile("wave.vcd"); 
        $dumpvars(0, Register_tb);
        // -------------------------------

        $display("------------------------------------------------------------------");
        $display("Start Simulare: Registru");
        
        // 0. Resetam totul la inceput
        rst_n = 0;   
        we    = 0;
        oe    = 0;
        data_in = 8'hAA; // Punem o valoare la intrare, dar n-ar trebui sa intre inca

        #(CLK_PERIOD * 2); 
        
        // Verificam daca resetul a mers
        $display("T=%0t | RESET: Valoarea interna (disp_out) trebuie sa fie 0. E: 0x%h", $time, disp_out);
        rst_n = 1;   // Scoatem resetul
        
        // 1. Test scriere (Write Enable = 1)
        we = 1;
        oe = 1; // Activam si iesirea ca sa vedem ce se intampla
        data_in = 8'hC5;
        #(CLK_PERIOD); // Asteptam un ciclu sa se scrie
        
        $display("T=%0t | WRITE: Am scris 0xC5. disp_out: 0x%h, data_out: 0x%h", $time, disp_out, data_out);
        
        // 2. Test pastrare valoare (Write Enable = 0)
        we = 0;
        data_in = 8'hFF; // Schimbam intrarea, dar nu dam WE. Valoarea veche trebuie sa ramana.
        #(CLK_PERIOD * 2); 
        
        $display("T=%0t | HOLD: Am schimbat inputul la FF dar WE=0. Ramane C5? -> disp_out: 0x%h", $time, disp_out);

        // 3. Test Output Enable (oe) - Asincron
        
        // A. OE = 0 (High Z sau 0, depinde cum e implementat, aici e 0)
        oe = 0;
        #5; // Asteptam jumatate de ciclu
        $display("T=%0t | OE CHECK (OFF): data_out trebuie sa fie 0. E: 0x%h", $time, data_out);
        
        // B. OE = 1 (Trebuie sa apara valoarea stocata C5)
        oe = 1;
        #5; 
        $display("T=%0t | OE CHECK (ON): data_out trebuie sa revina la C5. E: 0x%h", $time, data_out);
        
        // 4. Test combinat: Scriere noua + OE oprit temporar
        we = 1;
        data_in = 8'h3A;
        
        #(CLK_PERIOD/2);
        
        // Verificam in timp ce pregatim scrierea
        oe = 0; 
        $display("T=%0t | COMBO: Pregatesc scrierea 3A, dar cu OE=0. data_out: 0x%h", $time, data_out);
        
        #(CLK_PERIOD/2); // Aici s-a facut scrierea pe front
        
        $display("T=%0t | COMBO: S-a scris intern 3A? disp_out: 0x%h", $time, disp_out);
        $display("T=%0t | COMBO: Dar iesirea e inca blocata? data_out: 0x%h", $time, data_out);

        // Dam drumul la iesire
        oe = 1;
        #5;
        $display("T=%0t | FINAL: OE=1. Acum vedem 3A si pe iesire: 0x%h", $time, data_out);
        
        #(CLK_PERIOD);
        $display("------------------------------------------------------------------");
        $display("Gata simularea.");
        $finish;
    end
    
endmodule
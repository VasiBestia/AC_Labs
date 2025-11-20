`timescale 1ns / 1ps

module sequential_multiplier_tb;

    // Configurare: lucrez pe 4 biti intrare -> 8 biti iesire (4*4=16 max)
    localparam DATA_WIDTH = 4; 
    localparam RESULT_WIDTH = DATA_WIDTH * 2;
    localparam CLK_PERIOD = 10;

    // Semnalele de care am nevoie sa "butonez" modulul
    reg clk;
    reg rst_n;

    reg write;
    reg multiply;
    reg display;

    reg [DATA_WIDTH-1:0] a_in;
    reg [DATA_WIDTH-1:0] b_in;

    wire [RESULT_WIDTH-1:0] out;

    // Conectez modulul pe care l-am facut (DUT - Device Under Test)
    sequential_multiplier #(
        .DATA_WIDTH(DATA_WIDTH),
        .RESULT_WIDTH(RESULT_WIDTH)
    ) DUT (
        .clk(clk),
        .rst_n(rst_n),
        .write(write),
        .multiply(multiply),
        .display(display),
        .a_in(a_in),
        .b_in(b_in),
        .out(out)
    );

    // Generatorul de ceas: simplu, face toggle la fiecare jumatate de perioada
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Aici incepe treaba serioasa - scenariile de test
    initial begin
        // --- LINII ADAUGATE PENTRU WAVEFORM ---
        // Asta iti genereaza fisierul pentru GTKWave
        $dumpfile("wave.vcd"); 
        $dumpvars(0, sequential_multiplier_tb); 
        // --------------------------------------

        $display("------------------------------------------------------------------");
        $display("Start Simulare: Multiplicator Secvential (DATA_WIDTH=%0d)", DATA_WIDTH);
        
        // 0. Pornim cu un Reset curat
        rst_n = 0;   // Tinem resetul activ
        write = 0;
        multiply = 0;
        display = 0;
        a_in = 4'hA; // Pregatim 10 (0xA)
        b_in = 4'h3; // Pregatim 3
        
        #(CLK_PERIOD * 2); 
        rst_n = 1;   // Eliberam resetul
        $display("T=%0t | INIT: Reset dezactivat. Iesirea e: 0x%h", $time, out);

        // 1. SCENARIU BASIC: Scriem -> Calculam -> Afisam
        
        // Pasul 1: Incarcam datele (Write)
        $display("--- TEST 1: Functionare Normala (10 * 3 = 30) ---");
        write = 1;
        a_in = 4'hA; 
        b_in = 4'h3; 
        
        #(CLK_PERIOD); // Asteptam un ceas sa prinda comanda
        write = 0;
        $display("T=%0t | WRITE: Am scris A=10, B=3. Iesirea inca e 0x%h", $time, out);
        
        // Pasul 2: Dam comanda de inmultire (Multiply)
        multiply = 1;
        #(CLK_PERIOD); // Acum FSM-ul calculeaza si salveaza intern rezultatul
        multiply = 0;
        $display("T=%0t | MULTIPLY: Calcul facut. Rezultatul (30/0x1E) e in registrul intern.", $time, out);
        
        // Pasul 3: Scoatem rezultatul la "lumina" (Display)
        display = 1;
        #5; // Asteptam putin (asincron) sa se propage semnalul
        $display("T=%0t | DISPLAY: Iesirea arata: 0x%h. Corect ar fi 0x1E (30)", $time, out);
        
        #(CLK_PERIOD * 1);
        display = 0; // Oprim afisarea
        $display("T=%0t | IDLE: Am oprit display-ul. Iesirea revine la 0x%h", $time, out);
        
        // 2. SCENARIU PRIORITATI: Ce se intampla daca apasam mai multe butoane odata?
        $display("--- TEST 2: Verificare Prioritati (WRITE bate tot) ---");

        // Cazul A: Write + Multiply in acelasi timp
        write = 1;
        multiply = 1; // Asta ar trebui ignorat
        a_in = 4'h5; // 5
        b_in = 4'h6; // 6
        
        #(CLK_PERIOD); // Ar trebui sa intre in starea WRITE_OP
        
        write = 0;
        $display("T=%0t | PRIORITY CHECK 1: Am dat Write+Multiply. S-au scris noile valori (5, 6).", $time);

        // Cazul B: Multiply + Display in acelasi timp (Multiply bate Display)
        multiply = 1;
        display = 1; // Asta ar trebui ignorat momentan
        
        #(CLK_PERIOD); // Ar trebui sa intre in MULTIPLY_OP (5 * 6 = 30)
        
        multiply = 0;
        $display("T=%0t | PRIORITY CHECK 2: Am dat Multiply+Display. S-a facut calculul (5*6=30).", $time);

        // Acum verificam daca intr-adevar a calculat 30
        display = 1;
        #5;
        $display("T=%0t | VERIFICARE: Iesirea este 0x%h. (Trebuie sa fie 1E)", $time, out);

        #(CLK_PERIOD);
        display = 0;

        // 3. SCENARIU MAXIM: Testam limitele (15 * 15)
        $display("--- TEST 3: Limita maxima (15 * 15 = 225 / 0xE1) ---");
        
        // Facem toti pasii rapid unul dupa altul
        write = 1;
        a_in = 4'hF; // 15 (maxim pe 4 biti)
        b_in = 4'hF; 
        #(CLK_PERIOD);
        write = 0;
        
        multiply = 1;
        #(CLK_PERIOD);
        multiply = 0;
        
        display = 1;
        #5;
        $display("T=%0t | MAX VALUE: Rezultatul e 0x%h. Corect: 0xE1 (225)", $time, out);
        
        #(CLK_PERIOD);
        display = 0;

        $display("------------------------------------------------------------------");
        $display("Gata simularea.");
        $finish; // Oprim tot
    end
    
endmodule
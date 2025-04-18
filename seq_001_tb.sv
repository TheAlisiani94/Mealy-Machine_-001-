// Testbench for the Mealy Machine sequence detector (detects "001").
module seq_001_tb;
    // Testbench signals
    reg inp;         // Serial input bit
    reg clk;         // Clock
    reg reset;       // Synchronous reset
    wire det;        // Detection output

    // Instantiate the Mealy Machine (unit under test)
    seq_001 uut (
        .inp(inp),
        .clk(clk),
        .reset(reset),
        .det(det)
    );

    // Clock generation: 10 time units period (5 units high, 5 units low)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus process
    initial begin
        // Initialize inputs
        inp = 0;
        reset = 1;

        // Monitor inputs and outputs, including states
        $monitor("Time=%0t clk=%b reset=%b inp=%b pr_state=%b det=%b",
                 $time, clk, reset, inp, uut.pr_state, det);

        // Test sequence
        #10; // Wait for initial stabilization

        // Test 1: Reset the machine
        @(negedge clk);
        reset = 1;
        @(negedge clk);
        reset = 0;

        // Test 2: Input sequence "001" (should detect)
        @(negedge clk);
        inp = 0;  // First 0
        @(negedge clk);
        inp = 0;  // Second 0
        @(negedge clk);
        inp = 1;  // 1 (should detect here, det=1)
        @(negedge clk);
        inp = 0;

        // Test 3: Input sequence "010" (should not detect)
        @(negedge clk);
        inp = 0;  // First 0
        @(negedge clk);
        inp = 1;  // 1 (breaks sequence)
        @(negedge clk);
        inp = 0;  // 0 (no detection)

        // Test 4: Input sequence "111" (should not detect)
        @(negedge clk);
        inp = 1;
        @(negedge clk);
        inp = 1;
        @(negedge clk);
        inp = 1;

        // Test 5: Overlapping sequence "001001" (should detect twice)
        @(negedge clk);
        inp = 0;  // First 0
        @(negedge clk);
        inp = 0;  // Second 0
        @(negedge clk);
        inp = 1;  // 1 (first detection)
        @(negedge clk);
        inp = 0;  // First 0
        @(negedge clk);
        inp = 0;  // Second 0
        @(negedge clk);
        inp = 1;  // 1 (second detection)

        // Test 6: All zeros (should not detect)
        @(negedge clk);
        inp = 0;
        @(negedge clk);
        inp = 0;
        @(negedge clk);
        inp = 0;

        // Test 7: Reset in the middle of a sequence
        @(negedge clk);
        inp = 0;
        @(negedge clk);
        inp = 0;
        reset = 1;  // Reset while in s2
        @(negedge clk);
        reset = 0;
        inp = 1;

        // End simulation
        #20 $finish;
    end
endmodule

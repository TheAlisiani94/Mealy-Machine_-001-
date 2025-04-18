// A Mealy Machine that detects the sequence "001" in a serial input stream.
// The output det is set to 1 when the sequence "001" is detected (i.e., after seeing 00 followed by 1).
module seq_001 (
    input inp,           // Serial input bit
    input clk,           // Clock for state transitions
    input reset,         // Synchronous reset (active high)
    output reg det       // Output signal (1 when sequence "001" is detected)
);
    // State encoding using parameters
    parameter s0 = 2'b00;  // Initial state, no zeros seen
    parameter s1 = 2'b01;  // One zero seen
    parameter s2 = 2'b10;  // Two zeros seen (waiting for 1)

    // State registers
    reg [1:0] pr_state;    // Present state
    reg [1:0] nxt_state;   // Next state

    // State transition: synchronous, with reset
    always @(posedge clk) begin
        if (reset)
            pr_state <= s0;  // Reset to initial state
        else
            pr_state <= nxt_state;  // Update state to next state
    end

    // Next state logic: combinational, depends on current state and input
    always @(inp, pr_state) begin
        case (pr_state)
            s0: if (inp)
                    nxt_state = s0;  // Stay in s0 on 1 (no zeros seen)
                else
                    nxt_state = s1;  // Move to s1 on 0 (one zero seen)
            s1: if (inp)
                    nxt_state = s0;  // Return to s0 on 1 (sequence broken)
                else
                    nxt_state = s2;  // Move to s2 on 0 (two zeros seen)
            s2: if (inp)
                    nxt_state = s0;  // Return to s0 on 1 (sequence detected, reset)
                else
                    nxt_state = s2;  // Stay in s2 on 0 (still waiting for 1)
            default: nxt_state = s0;  // Default to s0 for safety
        endcase
    end

    // Output logic: combinational, depends on current state and input (Mealy machine)
    always @(inp, pr_state) begin
        case (pr_state)
            s0: det = 1'b0;  // No detection in s0
            s1: det = 1'b0;  // No detection in s1
            s2: if (inp)
                    det = 1'b1;  // Detect "001" in s2 when inp is 1
                else
                    det = 1'b0;  // No detection if inp is 0
            default: det = 1'b0;  // Default output is 0 for safety
        endcase
    end
endmodule

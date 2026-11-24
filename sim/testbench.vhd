library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.custom_pack.all;

entity testbench is
end testbench;

architecture beh of testbench is

    -------------------------------------------------------------------------
    -- DUT signals
    -------------------------------------------------------------------------
    signal clk       : std_logic := '0';
    signal data_w_en : arr_2d_b(0 to 4)(0 to 2);
    signal out_w_en  : arr_2d_b(0 to 4)(0 to 2);
    signal op_w_en   : std_logic := '0';
    
    signal run_sel   : std_logic := '0';

    signal ext_A     : arr_1d(0 to 2);
    signal ext_B     : arr_1d(0 to 2);
    signal op_in     : op_arr_2d(0 to 4)(0 to 2);
    
    signal selA_mux2 : sel1_arr_2d(0 to 2)(0 to 2);
    signal selB_mux2 : sel1_arr_2d(0 to 2)(0 to 2);
    
    signal selA_mux4 : sel2_arr_2d(3 to 4)(0 to 2);
    signal selB_mux4 : sel2_arr_2d(3 to 4)(0 to 2);

    signal top_Y     : arr_1d(0 to 2);

    constant Tclk : time := 10 ns;

begin

    -------------------------------------------------------------------------
    -- DUT
    -------------------------------------------------------------------------
    DUT : entity work.fabric5x3_top
        port map (
            clk       => clk,
            
            data_w_en => data_w_en,
            op_w_en   => op_w_en,
            out_w_en   => out_w_en,
            
            run_sel   => run_sel,

            ext_A     => ext_A,
            ext_B     => ext_B,
            
            selA_mux2 => selA_mux2,
            selB_mux2 => selB_mux2,
            
            selA_mux4 => selA_mux4,
            selB_mux4 => selB_mux4,

            op_in     => op_in,
            
            top_Y     => top_Y
        );

    -------------------------------------------------------------------------
    -- Clock
    -------------------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            clk <= '0'; wait for Tclk/2;
            clk <= '1'; wait for Tclk/2;
        end loop;
    end process;

    -------------------------------------------------------------------------
    -- Stimulus
    -------------------------------------------------------------------------
    stim_proc : process
    begin
         ---------------------------------------------------------------------
        -- RUN 1
        ---------------------------------------------------------------------
        run_sel <= '0';

        ext_A <= ("1011","1101","0011");
        ext_B <= ("1101","0010","0100");

        -- Row 0
        selA_mux2(0)(0) <= "0"; selA_mux2(0)(1) <= "0"; selA_mux2(0)(2) <= "0";
        selB_mux2(0)(0) <= "0"; selB_mux2(0)(1) <= "0"; selB_mux2(0)(2) <= "0";
        
        -- Row 1
        selA_mux2(1)(0) <= "0"; selA_mux2(1)(1) <= "0"; selA_mux2(1)(2) <= "0";
        selB_mux2(1)(0) <= "0"; selB_mux2(1)(1) <= "0"; selB_mux2(1)(2) <= "0";
        
        -- Row 2
        selA_mux2(2)(0) <= "1"; selA_mux2(2)(1) <= "0"; selA_mux2(2)(2) <= "1";
        selB_mux2(2)(0) <= "0"; selB_mux2(2)(1) <= "1"; selB_mux2(2)(2) <= "0";
        
        -- Row 3
        selA_mux4(3)(0) <= "10"; selA_mux4(3)(1) <= "10"; selA_mux4(3)(2) <= "00";
        selB_mux4(3)(0) <= "00"; selB_mux4(3)(1) <= "01"; selB_mux4(3)(2) <= "01";
        
        -- Row 4
        selA_mux4(4)(0) <= "00"; selA_mux4(4)(1) <= "01"; selA_mux4(4)(2) <= "10";
        selB_mux4(4)(0) <= "01"; selB_mux4(4)(1) <= "00"; selB_mux4(4)(2) <= "10";
        
        op_w_en   <= '0';
        
        op_in(0)(0) <= ANDo; op_in(0)(1) <= LSLo;  op_in(0)(2) <= MULTo;
        op_in(1)(0) <= RSRo; op_in(1)(1) <= NANDo; op_in(1)(2) <= NORo;
        op_in(2)(0) <= XORo; op_in(2)(1) <= SUBo;  op_in(2)(2) <= LSRo;
        op_in(3)(0) <= ADDo; op_in(3)(1) <= RSLo;  op_in(3)(2) <= XNORo;
        op_in(4)(0) <= GTo;  op_in(4)(1) <= LSLo;  op_in(4)(2) <= EQo;

        -- store ops
        op_w_en <= '1'; wait for Tclk;
        op_w_en <= '0'; wait for Tclk;

        -- initialize
        data_w_en <= (others => (others => '0'));
        out_w_en  <= (others => (others => '0'));
        
        for r in 0 to 4 loop
            wait until falling_edge(clk);
            data_w_en <= (others => (others => '0'));
            data_w_en(r) <= (others => '1');
        
            wait until falling_edge(clk);
            data_w_en <= (others => (others => '0'));
        
            wait until falling_edge(clk);
        
            wait until falling_edge(clk);
            out_w_en <= (others => (others => '0'));
            out_w_en(r) <= (others => '1');
        
            wait until falling_edge(clk);
            out_w_en <= (others => (others => '0'));
        
        end loop;

        assert top_Y(0)="1111";
        assert top_Y(1)="1100";
        assert top_Y(2)="1111";
        
        wait for 10*Tclk;

        ---------------------------------------------------------------------
        -- RUN 2
        ---------------------------------------------------------------------
        run_sel <= '1';
        
        ext_A <= (top_Y(0),top_Y(1),top_Y(2));
        ext_B <= ("1000",top_Y(1),"0010");

        -- Row 0
        selA_mux2(0)(0) <= "0"; selA_mux2(0)(1) <= "0"; selA_mux2(0)(2) <= "0";
        selB_mux2(0)(0) <= "0"; selB_mux2(0)(1) <= "0"; selB_mux2(0)(2) <= "0";
        
        -- Row 1
        selA_mux2(1)(0) <= "0"; selA_mux2(1)(1) <= "0"; selA_mux2(1)(2) <= "0";
        selB_mux2(1)(0) <= "0"; selB_mux2(1)(1) <= "0"; selB_mux2(1)(2) <= "0";
        
        -- Row 2
        selA_mux2(2)(0) <= "1"; selA_mux2(2)(1) <= "0"; selA_mux2(2)(2) <= "1";
        selB_mux2(2)(0) <= "0"; selB_mux2(2)(1) <= "1"; selB_mux2(2)(2) <= "0";
        
        -- Row 3
        selA_mux4(3)(0) <= "10"; selA_mux4(3)(1) <= "01"; selA_mux4(3)(2) <= "01";
        selB_mux4(3)(0) <= "00"; selB_mux4(3)(1) <= "10"; selB_mux4(3)(2) <= "00";
        
        -- Row 4
        selA_mux4(4)(0) <= "01"; selA_mux4(4)(1) <= "10"; selA_mux4(4)(2) <= "01";
        selB_mux4(4)(0) <= "00"; selB_mux4(4)(1) <= "00"; selB_mux4(4)(2) <= "00";
     
        op_w_en <= '0'; 
        
        op_in(0)(0) <= XORo; op_in(0)(1) <= NANDo; op_in(0)(2) <= LSRo;
        op_in(1)(0) <= ADDo; op_in(1)(1) <= RSLo;  op_in(1)(2) <= MULTo;
        op_in(2)(0) <= ANDo; op_in(2)(1) <= SUBo;  op_in(2)(2) <= XNORo;
        op_in(3)(0) <= RSRo; op_in(3)(1) <= LSLo;  op_in(3)(2) <= NORo;
        op_in(4)(0) <= XORo; op_in(4)(1) <= SUBo;  op_in(4)(2) <= MULTo;

        -- NEW: store ops
        op_w_en <= '1'; wait for Tclk;
        op_w_en <= '0'; wait for Tclk;
        
        data_w_en <= (others => (others => '0'));
        out_w_en  <= (others => (others => '0'));
        
        for r in 0 to 4 loop

            wait until falling_edge(clk);
            data_w_en <= (others => (others => '0'));
            data_w_en(r) <= (others => '1');
        
            wait until falling_edge(clk);
            data_w_en <= (others => (others => '0'));
        
            wait until falling_edge(clk);
        
            wait until falling_edge(clk);
            out_w_en <= (others => (others => '0'));
            out_w_en(r) <= (others => '1');
        
            wait until falling_edge(clk);
            out_w_en <= (others => (others => '0'));
        
        end loop;

        assert top_Y(0)="1011";
        assert top_Y(1)="0001";
        assert top_Y(2)="1010";

        wait;
    end process;

end beh;
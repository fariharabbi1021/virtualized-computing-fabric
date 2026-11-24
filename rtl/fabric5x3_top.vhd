library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.custom_pack.all;

entity fabric5x3_top is
    port (
        clk       : in  std_logic;
        data_w_en : in  arr_2d_b(0 to 4)(0 to 2);
        op_w_en   : in  std_logic;
        out_w_en  : in  arr_2d_b(0 to 4)(0 to 2);
        run_sel   : in  std_logic;

        ext_A     : in  arr_1d(0 to 2);
        ext_B     : in  arr_1d(0 to 2);
       
        op_in     : in op_arr_2d(0 to 4)(0 to 2);
        
        selA_mux2 : in sel1_arr_2d(0 to 2)(0 to 2);
        selB_mux2 : in sel1_arr_2d(0 to 2)(0 to 2);
        
        selA_mux4 : in sel2_arr_2d(3 to 4)(0 to 2);
        selB_mux4 : in sel2_arr_2d(3 to 4)(0 to 2);

        top_Y     : out arr_1d(0 to 2)
    );
end fabric5x3_top;

architecture beh of fabric5x3_top is

    type data_grid_t is array (0 to 4, 0 to 2) of data_t;
    type op_grid_t   is array (0 to 4, 0 to 2) of op_select;
    type sel1_arr_t  is array (0 to 2) of std_logic_vector(0 downto 0);

    constant ZERO_DATA : data_t := (others => '0');

    signal mux_A  : data_grid_t;
    signal mux_B  : data_grid_t;

    signal reg_A  : data_grid_t;
    signal reg_B  : data_grid_t;
    signal reg_Y  : data_grid_t;
    signal reg_Op : op_grid_t;

    signal cu_Y   : data_grid_t;
    signal fb_Y   : arr_1d(0 to 2);

begin
    -------------------------------------------------------------------------
    -- Feedback
    -------------------------------------------------------------------------
    fb_Y(0) <= cu_Y(4,0);
    fb_Y(1) <= cu_Y(4,1);
    fb_Y(2) <= cu_Y(4,2);

    -------------------------------------------------------------------------
    -- Row 0 MUX2: external vs feedback
    -------------------------------------------------------------------------
    gen_row0_mux : for c in 0 to 2 generate
    begin
        row0_muxA : entity work.MUX2
            generic map (d_w => 4)
            port map (
                I0  => ext_A(c),
                I1  => fb_Y(c),
                Sel => selA_mux2(0)(c), --row0_selA_1b(c),
                Y   => mux_A(0,c)
            );

        row0_muxB : entity work.MUX2
            generic map (d_w => 4)
            port map (
                I0  => ext_B(c),
                I1  => fb_Y(c),
                Sel => selB_mux2(0)(c), --row0_selB_1b(c),
                Y   => mux_B(0,c)
            );
    end generate;

    -------------------------------------------------------------------------
    -- Row 1 direct parent
    -------------------------------------------------------------------------
--    gen_row1_direct : for c in 0 to 2 generate
--    begin
--        mux_A(1,c) <= reg_Y(0,c);
--        mux_B(1,c) <= reg_Y(0,c);
--    end generate;
    -------------------------------------------------------------------------
    -- Row 1 MUX2: parent
    -------------------------------------------------------------------------
    gen_row1_mux : for c in 0 to 2 generate
    begin
        row1_muxA : entity work.MUX2
            generic map (d_w => 4)
            port map (
                I0  => reg_Y(0,c),
                I1  => ZERO_DATA,
                Sel => selA_mux2(1)(c), --row0_selA_1b(c),
                Y   => mux_A(1,c)
            );

        row1_muxB : entity work.MUX2
            generic map (d_w => 4)
            port map (
                I0  => reg_Y(0,c),
                I1  => ZERO_DATA,
                Sel => selB_mux2(1)(c), --row0_selB_1b(c),
                Y   => mux_B(1,c)
            );
    end generate;

    -------------------------------------------------------------------------
    -- Row 2 MUX2: parent vs grandparent
    -------------------------------------------------------------------------
    gen_row2_mux : for c in 0 to 2 generate
    begin
        row2_muxA : entity work.MUX2
            generic map (d_w => 4)
            port map (
                I0  => reg_Y(1,c),
                I1  => reg_Y(0,c),
                Sel => selA_mux2(2)(c), --row2_selA_1b(c),
                Y   => mux_A(2,c)
            );

        row2_muxB : entity work.MUX2
            generic map (d_w => 4)
            port map (
                I0  => reg_Y(1,c),
                I1  => reg_Y(0,c),
                Sel => selB_mux2(2)(c), --row2_selB_1b(c),
                Y   => mux_B(2,c)
            );
    end generate;

    -------------------------------------------------------------------------
    -- Row 3 MUX4
    -------------------------------------------------------------------------
    gen_row3_mux : for c in 0 to 2 generate
    begin
        row3_muxA : entity work.MUX4
            generic map (d_w => 4)
            port map (
                I0  => reg_Y(2,c),
                I1  => reg_Y(1,c),
                I2  => reg_Y(0,c),
                I3  => ZERO_DATA,
                Sel => selA_mux4(3)(c), --selA_r3(2*c+1 downto 2*c),
                Y   => mux_A(3,c)
            );

        row3_muxB : entity work.MUX4
            generic map (d_w => 4)
            port map (
                I0  => reg_Y(2,c),
                I1  => reg_Y(1,c),
                I2  => reg_Y(0,c),
                I3  => ZERO_DATA,
                Sel => selB_mux4(3)(c), --selB_r3(2*c+1 downto 2*c),
                Y   => mux_B(3,c)
            );
    end generate;

    -------------------------------------------------------------------------
    -- Row 4 MUX4
    -------------------------------------------------------------------------
    gen_row4_mux : for c in 0 to 2 generate
    begin
        row4_muxA : entity work.MUX4
            generic map (d_w => 4)
            port map (
                I0  => reg_Y(3,c),
                I1  => reg_Y(2,c),
                I2  => reg_Y(1,c),
                I3  => ZERO_DATA,
                Sel => selA_mux4(4)(c), --selA_r4(2*c+1 downto 2*c),
                Y   => mux_A(4,c)
            );

        row4_muxB : entity work.MUX4
            generic map (d_w => 4)
            port map (
                I0  => reg_Y(3,c),
                I1  => reg_Y(2,c),
                I2  => reg_Y(1,c),
                I3  => ZERO_DATA,
                Sel => selB_mux4(4)(c), --selB_r4(2*c+1 downto 2*c),
                Y   => mux_B(4,c)
            );
    end generate;

    -------------------------------------------------------------------------
    -- Data storage
    -------------------------------------------------------------------------
    gen_data_storage : for r in 0 to 4 generate
        gen_data_storage_c : for c in 0 to 2 generate
        begin
            A_store : entity work.data_storage
                generic map (d_w => 4)
                port map (
                    D    => mux_A(r,c),
                    w_en => data_w_en(r)(c),
                    clk  => clk,
                    Q    => reg_A(r,c)
                );

            B_store : entity work.data_storage
                generic map (d_w => 4)
                port map (
                    D    => mux_B(r,c),
                    w_en => data_w_en(r)(c),
                    clk  => clk,
                    Q    => reg_B(r,c)
                );
            Y_store : entity work.data_storage
                generic map (d_w => 4)
                port map (
                    D    => cu_Y(r,c),
                    w_en => out_w_en(r)(c),
                    clk  => clk,
                    Q    => reg_Y(r,c)
                );
        end generate;
    end generate;

    -------------------------------------------------------------------------
    -- Operation storage
    -------------------------------------------------------------------------
    gen_op_storage : for r in 0 to 4 generate
        gen_op_storage_c : for c in 0 to 2 generate
        begin
            Op_store : entity work.op_storage
                port map (
                    D    => op_in(r)(c),
                    w_en => op_w_en,
                    clk  => clk,
                    Q    => reg_Op(r,c)
                );
        end generate;
    end generate;

    -------------------------------------------------------------------------
    -- CU instantiations
    -------------------------------------------------------------------------
    gen_col0 : for r in 0 to 4 generate
    begin
        CU0_inst : entity work.CU_A
            generic map (d_w => 4)
            port map (
                A  => reg_A(r,0),
                B  => reg_B(r,0),
                Op => reg_Op(r,0),
                Y  => cu_Y(r,0)
            );
    end generate;

    gen_col1 : for r in 0 to 4 generate
    begin
        CU1_inst : entity work.CU_B
            generic map (d_w => 4)
            port map (
                A  => reg_A(r,1),
                B  => reg_B(r,1),
                Op => reg_Op(r,1),
                Y  => cu_Y(r,1)
            );
    end generate;

    gen_col2 : for r in 0 to 4 generate
    begin
        CU2_inst : entity work.CU_C
            generic map (d_w => 4)
            port map (
                A  => reg_A(r,2),
                B  => reg_B(r,2),
                Op => reg_Op(r,2),
                Y  => cu_Y(r,2)
            );
    end generate;

    -------------------------------------------------------------------------
    -- Outputs
    -------------------------------------------------------------------------
    top_Y(0) <= reg_Y(4,0);
    top_Y(1) <= reg_Y(4,1);
    top_Y(2) <= reg_Y(4,2);

end beh;
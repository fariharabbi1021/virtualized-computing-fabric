library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package custom_pack is

    -- Project 1 is 4-bit data
    subtype data_b is std_logic_vector(0 downto 0);
    subtype data_3b is std_logic_vector(2 downto 0);
    subtype data_t is std_logic_vector(3 downto 0);

    -- MUX8 select
    subtype sel1_t is std_logic_vector(0 downto 0);
    subtype sel2_t is std_logic_vector(1 downto 0);

    -- Operations
    type op_select is (
        ANDo, ORo, NANDo, NORo, XORo, XNORo,
        ADDo, SUBo, MULTo,
        ASLo, ASRo, RSLo, RSRo, LSLo, LSRo,
        PASSAo, PASSBo, NOPo, 
        GTo, LTo, EQo, GTEo, LTEo, NEQo
    );

    -- Op arrays
    type op_arr_1d is array(natural range<>) of op_select;
    type op_arr_2d is array(natural range<>) of op_arr_1d;

    -- Data arrays
    type arr_1d is array(natural range<>) of data_t;
    type arr_2d is array(natural range<>) of arr_1d;
    
    -- bit arrays
    type arr_1d_b is array(natural range<>) of std_logic;
    type arr_2d_b is array(natural range<>) of arr_1d_b;
    

    -- Select arrays (1-bit)
    type sel1_arr_1d is array(natural range<>) of sel1_t;
    type sel1_arr_2d is array(natural range<>) of sel1_arr_1d;
    
    -- Select arrays (2-bit)
    type sel2_arr_1d is array(natural range<>) of sel2_t;
    type sel2_arr_2d is array(natural range<>) of sel2_arr_1d;

end package custom_pack;
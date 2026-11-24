library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.custom_pack.all;

entity op_storage is
    Port ( D: in op_select;
          w_en, clk: in std_logic;
          Q: out op_select
    );
end op_storage;

architecture beh of op_storage is

signal stored_data: op_select;

begin

store: process(D, w_en, clk)
begin
    if(rising_edge(clk)) then
        if(w_en = '1') then --write mode
            stored_data <= D;
        elsif(w_en = '0') then -- read mode
            Q <= stored_data;
        end if;
    end if;   
end process store;

end beh;
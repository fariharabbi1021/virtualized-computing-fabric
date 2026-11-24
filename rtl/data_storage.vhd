library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity data_storage is
    generic (d_w: integer:= 4);
    Port ( D: in std_logic_vector(d_w - 1 downto 0);
           w_en, clk: in std_logic;
           Q: out std_logic_vector(d_w - 1 downto 0)
    );
end data_storage;

architecture beh of data_storage is

signal stored_data: std_logic_vector(d_w - 1 downto 0);

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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX2 is
    generic (d_w: integer:= 4);
    Port ( I0,I1: in std_logic_vector(d_w - 1 downto 0);
           Sel: in std_logic_vector (0 downto 0);
           Y: out std_logic_vector(d_w - 1 downto 0)
    );
end MUX2;

architecture beh of MUX2 is

begin
MUX2_proc: process (I0,I1,Sel)
    begin
        case Sel is
            when "0" => Y <= I0;
            when "1" => Y <= I1;
            when others => Y <= (others => '0');  
        end case;
    end process MUX2_proc;   
end beh;

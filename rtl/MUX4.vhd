library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX4 is
    generic (d_w: integer:= 4);
    Port ( I0,I1,I2,I3 : in std_logic_vector(d_w - 1 downto 0);
           Sel : in std_logic_vector (1 downto 0);
           Y : out std_logic_vector(d_w - 1 downto 0)
    );
end MUX4;

architecture beh of MUX4 is

begin
MUX4_proc: process (I0,I1,I2,I3,Sel)
    begin
        case Sel is
            when "00" => Y <= I0;
            when "01" => Y <= I1;
            when "10" => Y <= I2;
            when "11" => Y <= I3;
            when others => Y <= (others => '0');  
        end case;
    end process MUX4_proc;
    
end beh;

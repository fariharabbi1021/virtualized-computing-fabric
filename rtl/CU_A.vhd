library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.custom_pack.all;

entity CU_A is
    Generic(d_w: integer := 4);
    Port ( A, B : in std_logic_vector(d_w - 1 downto 0); 
           Op : in op_select;                            
           Y : out std_logic_vector(d_w - 1 downto 0));   
end CU_A;

architecture beh of CU_A is
 
begin
    op_sel: process(A, B, Op)
    begin
        case Op is
            when ANDo => 
                Y <= (A and B);
            when ADDo => 
                Y <= std_logic_vector(unsigned(A) + unsigned(B));
            when XORo => 
                Y <= (A xor B);
            when RSRo => 
                Y <= to_stdlogicvector(to_bitvector(A) ror to_integer(unsigned(B)));
            when GTo => 
                if unsigned(A) > unsigned(B) then
                    Y <= (others => '1');
                else
                    Y <= (others => '0');
                end if;
            when others => 
                Y <= (others => '0'); 
        end case;         
    end process op_sel;   
end beh;

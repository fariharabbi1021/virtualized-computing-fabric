library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.custom_pack.all;

entity CU_B is
    Generic(d_w: integer := 4);
    Port ( A, B : in std_logic_vector(d_w - 1 downto 0); 
           Op : in op_select;                            
           Y : out std_logic_vector(d_w - 1 downto 0));   
end CU_B;

architecture beh of CU_B is
 
begin
    op_sel: process(A, B, Op)
    begin
        case Op is
            when NANDo => 
                Y <= (A nand B);
            when ORo => 
                Y <= (A or B);
            when SUBo => 
                Y <= std_logic_vector(unsigned(A) - unsigned(B));
            when RSLo => 
                Y <= to_stdlogicvector(to_bitvector(A) rol to_integer(unsigned(B)));
            when LSLo =>  
                Y <= to_stdlogicvector(to_bitvector(A) sll to_integer(unsigned(B)));
            when LTo =>
                if unsigned(A) < unsigned(B) then
                    Y <= (others => '1');
                else
                    Y <= (others => '0');
                end if;
            when others => 
                Y <= (others => '0'); 
        end case;         
    end process op_sel;   
end beh;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.custom_pack.all;

entity CU_C is
    Generic(d_w: integer := 4);
    Port ( A, B : in std_logic_vector(d_w - 1 downto 0); 
           Op : in op_select;                            
           Y : out std_logic_vector(d_w - 1 downto 0));   
end CU_C;

architecture beh of CU_C is
 
begin
    op_sel: process(A, B, Op)
    variable tempMult: std_logic_vector(d_w*2-1 downto 0);
    begin
        case Op is
            when NORo => 
                Y <= (A nor B);
            when XNORo => 
                Y <= (A xnor B);
            when MULTo => 
                tempMult:= std_logic_vector(unsigned(A) * unsigned(B));
                Y <= tempMult(d_w-1 downto 0);
            when LSRo => 
                Y <= to_stdlogicvector(to_bitvector(A) srl to_integer(unsigned(B)));
            when EQo =>
                if A = B then
                    Y <= (others => '1');
                else
                    Y <= (others => '0');
                end if;
            when others => 
                Y <= (others => '0'); 
        end case;        
    end process op_sel;  
end beh;

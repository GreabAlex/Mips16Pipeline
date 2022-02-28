library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SSD is
    Port ( digits : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));

end SSD;

architecture Behavioral of SSD is

signal tmp:STD_LOGIC_VECTOR(15 downto 0):=x"0000";
signal a:STD_LOGIC_VECTOR(3 downto 0);

begin
--------------------------------------------------
process(clk)
begin
if rising_edge(clk) then
tmp<=tmp+1;
end if;
end process;
--------------------------------------------------mux1 4:1
process(digits,tmp(15 downto 14))
begin
case tmp(15 downto 14) is
when "00" =>  a<=digits(3 downto 0);
when "01" =>  a<=digits(7 downto 4);
when "10" =>  a<=digits(11 downto 8);
when  others =>  a<=digits(15 downto 12);
end case;
end process;
--------------------------------------------------mux2 4:1
process(tmp(15 downto 14))
begin
case tmp(15 downto 14) is
when "00" =>  an<="1110";
when "01" =>  an<="1101";
when "10" =>  an<="1011";
when  others => an<="0111";
end case;
end process;
--------------------------------------------------
process(a)
begin
case a is         
--fac verificari in octal ,x"0" e tot una cu 0000 , x"1" cu 0001 , x"F" cu 1111 etc   
			 when x"0" => cat <= "1000000"; --0;
			 when x"1" => cat <= "1111001"; --1
			 when x"2" => cat <= "0100100"; --2
			 when x"3" => cat <= "0110000"; --3
			 when x"4" => cat <= "0011001"; --4
			 when x"5" => cat <= "0010010"; --5
			 when x"6" => cat <= "0000010"; --6
			 when x"7" => cat <= "1111000"; --7
			 when x"8" => cat <= "0000000"; --8
			 when x"9" => cat <= "0010000"; --9
			 when x"A" => cat <= "0001000"; --A
			 when x"B" => cat <= "0000011"; --b
			 when x"C" => cat <= "1000110"; --C
			 when x"D" => cat <= "0100001"; --d
			 when x"E" => cat <= "0000110"; --E
			 when x"F" => cat <= "0001110"; --F
			 when others => cat <= "0111111"; -- null ,va afisa "-" 
		end case;
end process;

-- segment encoinputg
--      0
--     ---
--  5 |   | 1
--     ---   <- 6
--  4 |   | 2
--     ---
--      3
end Behavioral;

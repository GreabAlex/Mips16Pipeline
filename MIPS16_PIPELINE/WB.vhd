library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity WB is
    Port ( MEMdata : in  STD_LOGIC_VECTOR (31 downto 0);
           ALUResult : in  STD_LOGIC_VECTOR (31 downto 0);
           MemtoReg : in  STD_LOGIC;
           write_data : out  STD_LOGIC_VECTOR (31 downto 0));
end WB;

architecture Behavioral of WB is
begin
process(MEMdata,ALUResult,MemtoReg)
begin
if MemtoReg = '1' then 
write_data <= MEMdata; 
else 
write_data<= ALUResult;
end if;
end process;
end Behavioral;
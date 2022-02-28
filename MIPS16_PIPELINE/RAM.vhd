library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RAM is
Port ( RA : in STD_LOGIC_VECTOR (3 downto 0);
       WA : in STD_LOGIC_VECTOR (3 downto 0);
       WD : in STD_LOGIC_VECTOR (15 downto 0);
       WE : in STD_LOGIC;
       clk : in STD_LOGIC;
       RD : out STD_LOGIC_VECTOR (15 downto 0));
end RAM;

architecture Behavioral of RAM is

type memorie is array (0 to 15) of std_logic_vector (15 downto 0);

signal mem: memorie := (
0=>x"0000",
1=>x"0001",
2=> x"0002",
3=>x"0003",
4=> x"0004",
5=> x"0005",
6=> x"0006",
7=> x"0007",
8=> x"0008",
9=> x"0009",
others => x"9999"
);

begin

process(clk) 
begin
if rising_edge(clk) then
       if WE='1'  then
               mem(conv_integer(WA))<=WD;
               RD<=WD;
        else RD<=mem(conv_integer(RA));
     end if;
     end if;
end process;

end Behavioral;

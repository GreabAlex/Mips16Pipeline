library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Reg_File is
    Port ( RA1 : in STD_LOGIC_VECTOR (3 downto 0);
           RA2 : in STD_LOGIC_VECTOR (3 downto 0);
           WA : in STD_LOGIC_VECTOR (3 downto 0);
           WD : in STD_LOGIC_VECTOR (15 downto 0);
           rgwr : in STD_LOGIC;
           clk : in STD_LOGIC;
           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
           RD2 : out STD_LOGIC_VECTOR (15 downto 0));
end Reg_File;

architecture Behavioral of Reg_File is

type memorie is array (0 to 15) of std_logic_vector (15 downto 0);

signal reg: memorie := (
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

RD1<=reg(conv_integer(RA1));
RD2<=reg(conv_integer(RA2));

process(clk,rgwr) 
begin
if rising_edge(clk) and rgwr='1'
then  reg(conv_integer(WA))<=WD;
end if;
end process;
 
end Behavioral;

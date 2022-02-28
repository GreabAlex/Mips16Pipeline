library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity ID is
    Port ( clk : in STD_LOGIC;
           enable1 : in STD_LOGIC;
           instruction : in STD_LOGIC_VECTOR (15 downto 0);
           writeData : in STD_LOGIC_VECTOR (15 downto 0);
           regWrite : in STD_LOGIC;
           regDst : in STD_LOGIC;
           extOp : in STD_LOGIC;
           muxiesire : out std_logic_vector (2 downto 0);
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : out STD_LOGIC_VECTOR (15 downto 0);
           funct : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end ID;

architecture Behavioral of ID is
signal mux : std_logic_vector (2 downto 0);
type arr_type is array (0 to 127 )of STD_LOGIC_VECTOR(15 DOWNTO 0);
signal reg:arr_type;
begin

process(regDst, instruction)
  begin
    if (regDst='0') then
      mux<=instruction(9 downto 7);
    else
      mux<=instruction(6 downto 4);
    end if;
end process;

process (extOp,instruction)
  begin
    if(extOp='1') then
      ext_imm<= "111111111" & instruction(6 downto 0);
    else 
      ext_imm<= "000000000" & instruction(6 downto 0);
    end if;
end process;

process(clk,regWrite)
begin
if regWrite='1' then
	if clk='1' and clk'event then
	if enable1='1' then
	        
			reg(conv_integer(mux))<=writeData;
	end if;
	end if;
end if;
end process;
muxiesire<=mux;
rd1<=reg(conv_integer(instruction(12 downto 10)));
rd2<=reg(conv_integer(instruction(9 downto 7)));
funct<=instruction(2 downto 0);
sa<=instruction(3);

end Behavioral;

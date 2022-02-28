library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity InstrF is
Port (     
			clk: in std_logic;
			BranchAddress : in std_logic_vector(15 downto 0);
			JumpAddress : in std_logic_vector(15 downto 0);
			JumpControl : in std_logic;
			PCSrc : in std_logic;
		    enable : in std_logic;
			Reset : in std_logic;
			Instruction : out std_logic_vector(15 downto 0);
			PC : out std_logic_vector(15 downto 0):=X"0000");
end InstrF;

architecture Behavioral of InstrF is

type memorie is array(0 to 255) of std_logic_vector(15 downto 0);
signal mem: memorie := ( --afisarea celui de al n-lea numar dim sirul lui fibonacci
       -- B"001_111_000_0000010",       -- addi $7,$0,2 // i=2 ,vom avea deja 2 numere din fibonacci in $2 si $3
       -- B"001_001_000_0000111",       -- addi $1,$0,7 // al n=7 -lea numar din fibonacci (0 1 1 2 3 5 8 13 .....) , in n pot salva si alta valoare de ex 9 ,12 sau orice numar doresc sa aflu
       -- B"001_010_000_0000000",       --addi $2,$0,0
		--B"001_011_000_0000001",	 	  --addi $3,$0,1	
		--B"001_100_000_0000000",	      --addi $4,$0,0	
		--B"001_101_000_0000001",	 	  --addi $5,$0,1
		--B"011_100_010_0000000",       --sw $2,0($4)
	--	B"011_101_011_0000000",       --sw $3,0($5)
		--B"010_100_010_0000000",       --lw $2,0($4)
		--B"010_101_011_0000000",       --lw $3,0($5)
		--B"000_010_011_110_0_000",     --add $6,$2,$3
		--B"001_111_001_0000010",       -- addi $7,$0,1 //i++ , am generat deja un numar
      --  B"100_111_001_0010000",       -- beq $7,$1,16 //daca am ajuns la nr cautat il voi retine si termin executia
		--B"000_000_011_010_0_000",     --add $2,$0,$3
	--	B"000_000_110_011_0_000",     --add $3,$0,$6      
		--B"111_0000000001010",         --j 10
		--B"011_001_110_0000000",       -- sw $6,0($1) //in $1 retin valoarea numarului aflat
	    B"001_111_000_0000010",       -- addi $7,$0,2 
        B"001_001_000_0000111",       -- addi $1,$0,7 
        B"001_010_000_0000000",       --addi $2,$0,0
        B"001_011_000_0000001",    --addi $3,$0,1
        B"001_100_000_0000000",     --addi $4,$0,0
        B"001_101_000_0000001",         --addi $5,$0,1- 
        B"011_100_010_0000000",        --sw $2,0($4)
        B"011_101_011_0000000",        --sw $3,0($5) 
        B"000_000_000_000_0_000",      --NOOP
        B"000_000_000_000_0_000",      --NOOP
        B"010_100_010_0000000",        --lw $2,0($4)
        B"010_101_011_0000000",        --lw $3,0($5)  
        B"000_000_000_000_0_000",      --NOOP
        B"000_000_000_000_0_000",      --NOOP
        B"000_000_000_000_0_000",      --NOOP
        B"000_010_011_110_0_000",     --add $6,$2,$3
        B"001_111_001_0000010",       -- addi $7,$0,1 
        B"000_000_000_000_0_000",      --NOOP
        B"000_000_000_000_0_000",      --NOOP
        B"000_000_000_000_0_000",      --NOOP
        B"100_111_001_0011100",       -- beq $7,$1,28
        B"000_000_000_000_0_000",      --NOOP
        B"000_000_000_000_0_000",      --NOOP
        B"000_000_000_000_0_000",      --NOOP
        B"000_000_011_010_0_000",     --add $2,$0,$3
        B"000_000_110_011_0_000",     --add $3,$0,$6
        B"111_0000000001111",               --j 15
        B"000_000_000_000_0_000",      --NOOP
        B"011_001_110_0000000",         -- sw $6,0($1)

		others => X"0000");
		
signal PCounter, PCAux, NextAdr, AuxAdr: std_logic_vector(15 downto 0) :=X"0000";

begin
-----------MUX_1----------
process(PCSrc,PCAux,BranchAddress)
begin
	case (PCSrc) is 
		when '0' => AuxAdr <= PCAux;
		when '1' => AuxAdr<=BranchAddress;
		when others => AuxAdr<=X"0000";
	end case;
end process;	

----------MUX_2-----------
process(JumpControl,AuxAdr,JumpAddress)
begin
	case(JumpControl) is
		when '0' => NextAdr <= AuxAdr;
		when '1' => NextAdr <= JumpAddress;
		when others => NextAdr <= X"0000";
	end case;
end process;	

-----------Program Counter-------------
process(clk,reset)
begin
	if Reset='1' then
		PCounter<=X"0000";
	else if rising_edge(clk) and enable='1' then
		PCounter<=NextAdr;
		end if;
		end if;
end process;

Instruction<=mem(conv_integer(PCounter(7 downto 0)));

PCAux<=PCounter + '1';

PC <= PCAux;

end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity EX is    
Port (  next_addr: in std_logic_vector(15 downto 0); 
        RD1: in std_logic_vector(15 downto 0);
        RD2: in std_logic_vector(15 downto 0);
        Imm_ext: in std_logic_vector(15 downto 0);
        func: in std_logic_vector(2 downto 0);
        sa: in std_logic;
        ALUSrc: in std_logic;
        ALUOp: in std_logic_vector(2 downto 0);
        BranchAdress: out std_logic_vector(15 downto 0);
        ALURes: out std_logic_vector(15 downto 0);
        Zero: out std_logic

);
end EX;

architecture Behavioral of EX is

signal imux: std_logic_vector(15 downto 0);
signal AluCtrl: std_logic_vector(2 downto 0);
signal Zeroaux: std_logic;
signal ALUResaux: std_logic_vector(15 downto 0);

begin
BranchAdress<=next_addr+Imm_ext;

process(ALUSrc,RD2,Imm_ext)
begin

case ALUSrc is
when '0'=>imux<=RD2;
when '1'=>imux<=Imm_ext;

end case; 
end process;


process(ALUOp,func)
begin

case ALUop is
when "000"=>    --R
      case func is
      when "000"=> AluCtrl<="000"; --add
      when "001"=> AluCtrl<="001"; --sub
      when "010"=> AluCtrl<="010"; --sll
      when "011"=> AluCtrl<="011"; --srl
      when "100"=> AluCtrl<="100"; --and
      when "101"=> AluCtrl<="101"; --or
      when "110"=> AluCtrl<="110"; --xor
      when "111"=> AluCtrl<="111"; --slt
      when others=>AluCtrl<="000";    
      end case;
        --I
when "001"=>AluCtrl<="000";  --addi,lw,sw
when "010"=>AluCtrl<="001";  --beq
when "101"=>AluCtrl<="100";  --andi
when "110"=>AluCtrl<="101";  --ori
when "111"=>AluCtrl<="111";  --jump
when others=>AluCtrl<="000";     

end case;
end process;


process(RD1,imux,sa,AluCtrl)
begin
case AluCtrl is
  when "000"=> ALUResaux<=RD1+imux;--add
  when "001"=> ALUResaux<=RD1-imux;--sub
  when "010"=> --sll
      if sa='1' then 
       ALUResaux<=RD1(14 downto 0) & '0';
      else
       ALUResaux<=RD1;             
      end if;  
 when "011"=> --srl   
      if sa='1' then       
       ALUResaux<='0' & RD1(15 downto 1);     
      else     
       ALUResaux<=RD1;              
      end if;
when "100"=> ALUResaux<=RD1 and imux;
when "101"=> ALUResaux<=RD1 or imux;
when "110"=> ALUResaux<=RD1 xor imux;
when "111" => --slt
        if RD1<imux then
            ALUResaux<=X"0001";
        else ALUResaux<=X"0000";
        end if;
when others=> ALUResaux<=x"0000";   

end case;

case (ALUResaux) is	
		when X"0000" => Zeroaux<='1';
		when others => Zeroaux<='0';
	end case;
end process;

ALURes<=ALUResaux;
Zero<=Zeroaux;

end Behavioral;

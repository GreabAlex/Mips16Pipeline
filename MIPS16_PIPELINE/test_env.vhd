library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity test_env is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end test_env;

architecture Behavioral of test_env is
--signal cnt:STD_LOGIC_VECTOR(1 downto 0):="00";
signal reset:STD_LOGIC;
signal en:STD_LOGIC;
signal we:STD_LOGIC;
----------COntrolUNIT ---------
signal RegDst: std_logic;
signal ExtOp: std_logic;
signal ALUSrc: std_logic;
signal Branch: std_logic;
signal Jump: std_logic;
signal ALUOp: std_logic_vector(2 downto 0);
signal MemWrite: std_logic;
signal MemtoReg: std_logic;
signal RegWrite: std_logic;
------ID---------------
signal SA : std_logic;	
signal Func :std_logic_vector(2 downto 0);	
signal RD1: std_logic_vector(15 downto 0);					
signal RD2: std_logic_vector(15 downto 0);					
signal Ext_Imm : std_logic_vector(15 downto 0);
signal WriteDataReg: std_logic_vector(15 downto 0);					
-----------------------------
--signal a: STD_LOGIC_VECTOR(15 downto 0):=x"0000";
--signal b: STD_LOGIC_VECTOR(15 downto 0):=x"0000";
--signal c: STD_LOGIC_VECTOR(15 downto 0):=x"0000";
--signal digit:STD_LOGIC_VECTOR(15 downto 0):=x"0000";
signal tmp:STD_LOGIC_VECTOR(3 downto 0):="0000";
--type memorie is array (0 to 15) of std_logic_vector (15 downto 0);
--signal do:STD_LOGIC_VECTOR(15 downto 0):=x"0000";
--signal mem: memorie := (
--0=> x"0000",
--1=> x"0001",
--2=> x"0002",
--3=> x"0003",
--4=>x"0004",
--5=> x"0005",
--6=> x"0006",
--7=>x"0007",
--8=> x"0008",
--9=> x"0009",
--others => x"9999"
--);
signal digits1:STD_LOGIC_VECTOR(15 downto 0):=x"0000";
--signal digits2:STD_LOGIC_VECTOR(15 downto 0):=x"0000";
signal digits:STD_LOGIC_VECTOR(15 downto 0):=x"0000";
----------------------------------------------------------------mpg
component MPG is
    Port ( btn : in STD_LOGIC;
           clk : in STD_LOGIC;
           en : out STD_LOGIC);
end component;
----------------------------------------------------------------ssd
component SSD is
    Port ( digits : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end component;
----------------------------------------------------------------reg_file
--component Reg_File is
--    Port ( RA1 : in STD_LOGIC_VECTOR (3 downto 0);
--           RA2 : in STD_LOGIC_VECTOR (3 downto 0);
--           WA : in STD_LOGIC_VECTOR (3 downto 0);
--           WD : in STD_LOGIC_VECTOR (15 downto 0);
--           Rgwr : in STD_LOGIC;
--           clk : in STD_LOGIC;
--           RD1 : out STD_LOGIC_VECTOR (15 downto 0);
--           RD2 : out STD_LOGIC_VECTOR (15 downto 0));
--end component;
--------------------------------------------------------------------ram
component RAM is
Port ( RA : in STD_LOGIC_VECTOR (3 downto 0);
       WA : in STD_LOGIC_VECTOR (3 downto 0);
       WD : in STD_LOGIC_VECTOR (15 downto 0);
       WE : in STD_LOGIC;
       clk : in STD_LOGIC;
       RD : out STD_LOGIC_VECTOR (15 downto 0));
end component;
---------------------------------------------------------------ControlUnit
component ControlUnit is
Port	(    Opcode:in std_logic_vector(2 downto 0);
			 RegDst: out std_logic;
			 ExtOp: out std_logic;
			 ALUSrc: out std_logic;
			 Branch: out std_logic;
			 Jump: out std_logic;
			 ALUOp: out std_logic_vector(2 downto 0);
			 MemWrite: out std_logic;
			 MemtoReg: out std_logic;
			 RegWrite: out std_logic);
end component;

--------------------------------------------------------------------IF
component InstrF is
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
end component;
---------------------------------------------------------------------
component ID is
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
end component;
---------------------------------------------------------------------
component EX is    
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
end component;
-----------------------------------------------------------------------
component MEM is
	port(
			clk: in std_logic;
			ALURes : in std_logic_vector(15 downto 0);
			WriteData: in std_logic_vector(15 downto 0);
			MemWrite: in std_logic;			
			MemWriteCtrl: in std_logic;
			MemData:out std_logic_vector(15 downto 0);
			ALURes2 :out std_logic_vector(15 downto 0)
	);
end component;
------------------------------------------------------------------------
signal enable1: STD_LOGIC;   
signal enable2: STD_LOGIC;	 
signal muxiesire : std_logic_vector (2 downto 0);
signal BranchAddress:std_logic_vector(15 downto 0);  	   
signal JumpAddress:std_logic_vector(15 downto 0); 		  
signal SSDOut : std_logic_vector(15 downto 0):=X"0000";  
signal InstructionOut: std_logic_vector(15 downto 0);	
signal PCounter: std_logic_vector(15 downto 0);
signal PCSrc:std_logic;	
signal JumpControl:std_logic;	
signal ALURes: std_logic_vector(15 downto 0);	
signal MemData: std_logic_vector(15 downto 0);	
signal ALUResFinal: std_logic_vector(15 downto 0);		
signal ZeroSignal: std_logic;	
signal PCout: std_logic_vector(15 downto 0);	
signal WriteDataReg1: std_logic;	
signal BranchA: std_logic;	
--semnale iesire RAM
signal MuxData: std_logic_vector(15 downto 0);
--registrii intermediari -pipeline 
signal IF_ID: std_logic_vector(31 downto 0);
signal ID_EX: std_logic_vector(77 downto 0);
signal EX_MEM: std_logic_vector(56 downto 0);
signal MEM_WB: std_logic_vector(36 downto 0);

signal iesireMuxRegDst: std_logic_vector(2 downto 0);

begin

--M1: MPG port map(btn=>btn(0),clk=>clk,en=>en);
--M2: MPG port map(btn=>btn(1),clk=>clk,en=>reset);
--M3: MPG port map(btn=>btn(2),clk=>clk,en=>we);


--setam cei 4 biti pt a si b si cei 8 pt c, restul sunt deja 0
--a(3 downto 0)<=sw(3 downto 0);
--b(3 downto 0)<=sw(7 downto 4);
--c(7 downto 0)<=sw(7 downto 0);

--M1: MPG port map(btn=>btn(0),clk=>clk,en=>en);

--process (clk)
--begin
--   if rising_edge(clk) then
--      if en='1' then
--       --  if sw(0)='0' then
--             cnt <= cnt + 1;
--        --    else
--          --      cnt<= cnt - 1;
--      --   end if;
--      end if;
-- end if;
--end process;

--process(cnt,a,b,c)
--begin
--case cnt is
--when "00" =>  digit<=a+b;
--when "01" =>  digit<=a-b;
--when "10" =>  digit(15 downto 0)<=c(13 downto 0) & "00";--la stanga
--when  others =>  digit(15 downto 0)<="00" & c(15 downto 2);--la dreapta
--end case;
--end process;

--S1: SSD port map(digit,clk,cat,an);

--led<=digit;
--pt zero det
--process(digit)
--begin
--if digit=x"0000" then
--    led(7)<='1';
--     else 
--       led(7)<='0';
--end if;
--end process;
--M1: MPG port map(btn=>btn(0),clk=>clk,en=>en);
--process(clk)
--begin
--if rising_edge(clk) then
--    if en='1' then
--         tmp<=tmp+1;
--       end if;
--     end if;
--end process;

--do<=mem(conv_integer(tmp));
--S1: SSD port map(do,clk,cat,an);
-----------------------------------------
--process(clk)
--begin
--if reset='1' then
--         tmp<="0000";
--        end if;
--if rising_edge(clk) then
--    if en='1' then
--         tmp<=tmp+1;
--       end if;
--     end if;
--end process;

--S1 :SSD port map(SSDOUT,clk,cat,an);
---------MUX pentru afisare----------------------
--process(InstructionOut,PCounter)
--begin
--case(sw(7)) is
	--	when '0' =>
	--			SSDOut<=InstructionOut;
	--	when '1'=>
	--			SSDOut<=PCounter;		
   --     when others=>
   --             SSDOut<=X"FFFF";
--end case;
--end process;
M1: MPG port map(btn=>btn(0),clk=>clk,en=>enable1);
M2: MPG port map(btn=>btn(1),clk=>clk,en=>enable2);


-------------------------------------------------
--R1: Reg_File port map(tmp,tmp,tmp,digits,we,clk,digits1,digits2);
--RAM1: RAM port map(tmp,tmp,digits,WE,clk,digits1);
process(MEM_WB(36), MEM_WB(15 downto 0), MEM_WB(15 downto 0))
begin
	case (MEM_WB(36)) is
		when '1' => WriteDataReg<= MEM_WB(15 downto 0);
		when '0' => WriteDataReg<= MEM_WB(15 downto 0);
		when others => WriteDataReg<=WriteDataReg;
	end case;
end process;	


--digits(15 downto 0)<=digits1(13 downto 0) & "00";

S1: SSD port map(SSDOUT,clk,cat,an);

--process(InstructionOut,PCout,RD1,RD2,Ext_Imm,ALURes,MemData,WriteDataReg,sw)
--begin
	--case(sw(7 downto 5)) is
	--	when "000"=>
		--		SSDOut<=InstructionOut;			
		--when "001"=>
		--		SSDOut<=PCout;				
		--when "010"=>
		--		SSDOut<=RD1;			
		--when "011"=>
		--		SSDOut<=RD2;				
		--when "100"=>
		--		SSDOut<=Ext_Imm;			
		--when "101" =>
	--			SSDOut<=ALURes;			
	--	when "110"=>
		--		SSDOut<=MemData;			
	--	when "111"=>
	--			SSDOut<=WriteDataReg;	
		--when others=>
	--			SSDOut<=X"FFFF";
	--end case;
--end process;

process(RegDst,ExtOp,ALUSrc,Branch,Jump,MemWrite,MemtoReg,RegWrite,sw,ALUOp)
begin
	if sw(0)='0' then		
		led(7)<=RegDst;
		led(6)<=ExtOp;
		led(5)<=ALUSrc;
		led(4)<=Branch;
		led(3)<=Jump;
		led(2)<=MemWrite;
		led(1)<=MemtoReg;
		led(0)<=RegWrite; 
		
	else
		led(2 downto 0)<=ALUOp(2 downto 0);
		led(7 downto 3)<="00000";
	end if;
end process;	

-------------------AND Zero+Branch---------------
--PCSrc<=ZeroSignal and Branch;
PCSrc<= EX_MEM(52) and ID_EX(70) ;
-------------------------------------------------

-----------------JumpAddress---------------------
--JumpAddress<=PCOut(15 downto 14) & InstructionOut(13 downto 0);
JumpAddress<= IF_ID(31 downto 30) &  IF_ID(13 downto 0);
-------------------------------------------------

------Instantiere componenta InstrF------------
--InstrF1: InstrF port map(clk,BranchAddress,JumpAddress,JumpControl,PCSrc,enable1,enable2,InstructionOut,PCounter);
InstrF1: InstrF port map(clk,EX_MEM(35 downto 20),JumpAddress,JumpControl,PCSrc,enable1,enable2,InstructionOut,PCounter);
---------------------------------------------------------
------Instantiere componenta ControlUnit------------
C_UNIT1: ControlUNIT port map (InstructionOut(15 downto 13),RegDst,ExtOp,ALUSrc,Branch,Jump,ALUOp,MemWrite,MemtoReg,RegWrite);
-------------------------------------------------
------Instantiere componenta ID------------
--ID1: ID port map (clk,enable1,InstructionOut,WriteDataReg,RegWrite,RegDst,ExtOp,RD1,RD2,Ext_Imm,Func,SA);
ID1: ID port map (clk,enable1,IF_ID(15 downto 0),WriteDataReg, MEM_WB(32),RegDst,ExtOp,MEM_WB(35 downto 33),RD1,RD2,Ext_Imm,Func,SA);
-------------------------------------------------------------------
------Instantiere componenta ExUnit--------------
EXUnit: EX port map(ID_EX(63 downto 48), ID_EX(47 downto 32), ID_EX(31 downto 16), ID_EX(15 downto 0), ID_EX(66 downto 64), ID_EX(75), ID_EX(69), ID_EX(69 downto 67),BranchAddress,ALURes,ZeroSignal);
-------------------------------------------------
------Instantiere componenta Memory--------------
--MEM1: MEM port map(clk,ALURes,RD2,MemWrite,enable1,MemData,ALUResFinal);
MEM1: MEM port map(clk, EX_MEM(51 downto 36), EX_MEM(19 downto 4), EX_MEM(53),enable1,MemData,ALUResFinal);

process(clk, IF_ID, ID_EX, EX_MEM, MEM_WB)
   begin
      if clk='1' and clk'event then
       if enable1='1' then
            -- IF_ID
            IF_ID(31 downto 16) <= PCounter;
            IF_ID(15 downto 0) <= InstructionOut;
            -- ID_EX 
            ID_EX(76) <= MemtoReg;
            ID_EX(75) <= sa;
            ID_EX(74) <= WriteDataReg1;
            ID_EX(73) <= RegWrite;
            ID_EX(72) <= MemWrite;
            ID_EX(71) <= RegDst;
            ID_EX(70) <= BranchA;         
            ID_EX(77) <= ALUSrc;
            ID_EX(69 downto 67) <= ALUOp;
            ID_EX(66 downto 64) <= func;
            ID_EX(63 downto 48) <= IF_ID(31 downto 16);
            ID_EX(47 downto 32) <= RD1;
            ID_EX(31 downto 16) <= RD2;
            ID_EX(15 downto 0) <= Ext_imm;
            -- EX_MEM
            EX_MEM(56) <= ID_EX(76);--MemtoReg
            EX_MEM(55) <= ID_EX(73); --RegWrite
            EX_MEM(54) <= ID_EX(70); --BranchA
            EX_MEM(53) <= ID_EX(72); --MemWrite
            EX_MEM(52) <= ZeroSignal;    
            EX_MEM(51 downto 36) <= ALURes;
            EX_MEM(35 downto 20) <= BranchAddress;
            EX_MEM(19 downto 4) <= ID_EX(31 downto 16); --RD2
            EX_MEM(3 downto 1) <= iesireMuxRegDst;--muxregst
            EX_MEM(0)<=ID_EX(71);--RegDst
            -- MEM_WB
            MEM_WB(36)<= EX_MEM(55);--MemtoReg
            MEM_WB(35 downto 33) <= EX_MEM(3 downto 1); --mux-ul 
            MEM_WB(32) <= EX_MEM(55); --RegWrite
            MEM_WB(31 downto 16) <= MemData;
            MEM_WB(15 downto 0) <= EX_MEM(51 downto 36); --ALURes
        end if;
        end if;
   end process;

end Behavioral;

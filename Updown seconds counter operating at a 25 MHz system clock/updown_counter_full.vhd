----------------------------------------------------------------------------------
-- Engineer: Elena Peñaranda
-- 
-- Create Date: 11.10.2025 13:15:53
-- Design Name: 
-- Module Name: updown_counter_full
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- The system supports both ascending and descending counting modes, selectable via a mode switch. 
-- In up-counting mode, the counter increments from 0 to 59 seconds, while in down-counting mode it decrements from 59 to 0 seconds. 
-- When the counter reaches its limit, the counting process stops and a FULL output signal is asserted.
--
-- A start/stop control allows the counter to be paused and resumed via a switch input, while a reset input initializes the system. 
-- The current seconds count is displayed using a 7-segment display for the units digit, and a set of six LEDs is used to represent the tens digit, interfacing directly with external FPGA hardware.
--
--The design is fully synthesizable and integrates sequential logic, control signals, and output decoding for both display types.
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity updown_counter_full is
    Port ( clk : in STD_LOGIC; --25MHz
           reset : in STD_LOGIC;
           modo : in STD_LOGIC;
           start_stop : in STD_LOGIC;
           full : out STD_LOGIC;
           disp : out STD_LOGIC_VECTOR (6 downto 0);
           leds : out STD_LOGIC_VECTOR (5 downto 0));
end updown_counter_full;

architecture Behavioral of updown_counter_full is
    signal clk_div : std_logic;
    signal clk_count : integer range 0 to 24999999 :=0;
    signal count : integer range 0 to 59 :=0;
    signal uni : integer range 0 to 9 :=0;
    signal dec : integer range 0 to 5 :=0;
begin

    process(clk,reset)
    begin
        if reset = '1' then
            clk_div <= '0';
            clk_count <= 0;
        elsif rising_edge(clk) then
            if clk_count = 24999999 then
                clk_div <= not clk_div;
                clk_count <= 0;
            else
                clk_count <= clk_count + 1;
            end if;
        end if;
    end process;
    
    process(clk_div,reset,start_stop)
    begin
        if reset = '1' then
            if modo = '1' then
                count <= 0;
                uni <= 0;
                dec <= 0;    
            elsif modo = '0' then
                count <= 59;
                uni <= 9;
                dec <= 5;   
            end if;
            full <= '0';
        elsif rising_edge(clk_div) then
            if start_stop = '1' then
                if modo = '1' then
                    full <= '0';
                    if count > 58 then
                        full <= '1';
                    else
                        count <= count + 1;
                        if uni=9 then
                            uni <= 0;
                            dec <= dec + 1;
                        else
                            uni <= uni + 1;
                        end if;
                    end if;
                elsif modo = '0' then
                    full <= '0';
                    if count < 1 then
                        full <= '1';
                    else
                        count <= count - 1;
                        if uni=0 then
                            uni <= 9;
                            dec <= dec - 1;
                        else
                            uni <= uni - 1;
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    disp <= "1110111" when uni = 0 else
            "0010010" when uni = 1 else
            "1011101" when uni = 2 else
            "1011011" when uni = 3 else
            "0111010" when uni = 4 else
            "1101011" when uni = 5 else
            "1101111" when uni = 6 else
            "1010010" when uni = 7 else
            "1111111" when uni = 8 else
            "1111011" when uni = 9 else
            "0000000";
     
     leds <= "000001" when dec = 0 else
             "000010" when dec = 1 else
             "000100" when dec = 2 else
             "001000" when dec = 3 else
             "010000" when dec = 4 else
             "100000" when dec = 5 else
             "000000";   

end Behavioral;

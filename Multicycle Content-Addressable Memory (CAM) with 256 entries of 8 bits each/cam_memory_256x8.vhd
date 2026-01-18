----------------------------------------------------------------------------------
-- Engineer: Elena Peñaranda
-- 
-- Create Date: 11.10.2025 19:38:35
-- Design Name: 
-- Module Name: cam_memory_256x8
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- The memory supports two operating modes: write and search (read). 
-- During a write operation (WENB = '0'), the input tag data is stored in the memory location specified by ADDR_IN. 
-- During a search operation (RENB = '0'), the memory sequentially scans all entries to find a match with the input tag data.
--
-- If the tag is found during the search, the MATCH signal is asserted. 
-- The output address (MEM_SAL) remains in high impedance during the search process and is only driven at the end of the search cycle. 
-- When a match is detected at the end of the scan, MATCH_VALID is asserted and MEM_SAL outputs the address of the matching entry.
--
-- If no match is found, MATCH remains deasserted, MATCH_VALID stays low, and the output remains in high impedance. 
-- The design is fully synthesizable and follows a multicycle architecture, ensuring that the output is always produced at the end of the search operation.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cam_memory_256x8 is
    Generic ( N: integer := 8);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           wenb : in STD_LOGIC;
           renb : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (N downto 0);
           data : in STD_LOGIC_VECTOR (7 downto 0);
           match_valid : out STD_LOGIC;
           mem_sal : out STD_LOGIC_VECTOR (7 downto 0);
           match : out STD_LOGIC);
end cam_memory_256x8;

architecture Behavioral of cam_memory_256x8 is
    type mem is array (0 to 2**N-1) of std_logic_vector(7 downto 0);
    signal CAM: mem;
    signal ptro: integer range 0 to 2**N-1;
    signal count: integer range 0 to 2**N-1;
begin
    
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                match <= '0';
                match_valid <= '0';
                mem_sal <= (others => 'Z');
                count <= 0;
                ptro <= 0;
            else
                if wenb = '0' and renb = '1' then
                    CAM(to_integer(unsigned(addr))) <= data;
                elsif wenb = '1' and renb = '0' then
                    if count = 2**N-1 then 
                        if data = cam(ptro) then
                            match <= '1';
                            match_valid <= '1';
                            mem_sal <= std_logic_vector(to_unsigned(ptro,8));
                        else
                            match <= '0';
                            match_valid <= '0';
                            mem_sal <= (others => 'Z');
                        end if;
                    else
                        if data = cam(count) then
                            ptro <= count;
                            match <= '1';
                            match_valid <= '0';
                            mem_sal <= (others => 'Z');
                        end if;
                        count <= count + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;

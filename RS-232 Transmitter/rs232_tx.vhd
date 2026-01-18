----------------------------------------------------------------------------------
-- Engineer: Elena Peñaranda
-- 
-- Create Date: 12.10.2025 15:19:01
-- Design Name: 
-- Module Name: rs232_tx.vhd
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: The transmitter follows the standard RS-232 frame format, where the serial line remains at logic high when idle, 
-- transmission starts with a start bit (0), followed by 8 data bits, an odd parity bit, and a stop bit (1).
-- The system operates with a 1 Hz clock signal, resulting in a transmission rate of 1 bit per second (1 bps). All inputs are synchronous, 
-- and once transmission has started, it cannot be interrupted.
-- Control signals include Load to load and transmit data, TxBusy to indicate an ongoing transmission, and Parity selection. 
-- The design is fully synthesizable and implemented as a finite state machine.
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

entity rs232_tx is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           load : in STD_LOGIC;
           paridad : in STD_LOGIC;
           in_load : in STD_LOGIC;
           din : in STD_LOGIC_VECTOR (7 downto 0);
           txbusy : out STD_LOGIC;
           tx : out STD_LOGIC);
end rs232_tx;

architecture Behavioral of rs232_tx is
    type states is (IDLE, started, datos, parity, stop);
    signal state : states;
    signal start: std_logic;
    signal par: std_logic;
    signal count: integer range 0 to 7 :=0;
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' and start = '0' then
                tx <= '1';
                state <= IDLE;
                txbusy <= '0';
                if paridad = '0' then
                    par <= '0';
                elsif paridad = '1' then
                    par <= '1';
                end if;
            else
                if load = '1' then
                    if state = IDLE then
                        tx <= '0';
                        state <= started;
                        start <= '1';
                    elsif state = started then
                        tx <= din(7-count);
                        txbusy <= '1';
                        if din(7-count) = '1' then
                            par <= not par;
                        end if;
                        if count = 7 then
                            state <= datos;
                            count <= 0;
                        end if;
                        count <= count + 1;
                    elsif state = datos then
                        tx <= par;
                        state <= parity;
                    elsif state = parity then
                        if count = 3 then
                            txbusy <= '0';
                            count <= 0;
                            start <= '0';
                        else
                            count <= count + 1;
                            tx <= '1';
                        end if;
                    end if;
                else
                    tx <= '1';
                end if;
            end if;
        end if;
    end process;

end Behavioral;

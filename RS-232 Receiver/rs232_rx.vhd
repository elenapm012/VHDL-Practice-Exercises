----------------------------------------------------------------------------------
-- Engineer: Elena Peñaranda
-- 
-- Create Date: 11.10.2025 18:23:44
-- Design Name: 
-- Module Name: rs232_rx
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- The receiver follows the standard RS-232 frame format, where the serial line remains at logic high when idle and reception starts upon detection of a falling edge ('1' to '0') corresponding to the start bit. A synchronization flag (FLAG) is asserted to initiate data reception.
--
-- The design supports configurable frame parameters, allowing the number of data bits (8 or 9) and the number of stop bits (one or two) to be selected. 
-- Odd parity is implemented for error detection.
--
-- The system operates with a 1 Hz clock and a reception rate of 1 bit per second (1 bps). 
-- The entire design is fully synthesizable and implemented using an FSM-based control architecture.
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

entity rs232_rx is
    Generic ( N : integer := 8;
              stop_bit: integer := 2);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           flag : out STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (N-1 downto 0);
           d_valido : out STD_LOGIC;
           parity : in STD_LOGIC;
           rx_busy : out STD_LOGIC;
           rx : in STD_LOGIC);
end rs232_rx;

architecture Behavioral of rs232_rx is
    type states is (IDLE, SEQ, PAR, STOP);
    signal STATE: states;
    signal rx_prev: std_logic;
    signal count: integer range 0 to N-1;
    signal impar: std_logic;
    signal datos: std_logic_vector(N-1 downto 0);
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                STATE <= IDLE;
                rx_prev <= '1';
                count <= 0;
                if parity = '0' then
                    impar <= '0';
                elsif parity = '1' then
                    impar <= '1';
                end if;
                datos <= (others => '0');
                flag <= '0';
                rx_busy <= '0';
                d_valido <= '0';
            else
                case STATE is
                    when IDLE =>
                        count <= 0;
                        if parity = '0' then
                            impar <= '0';
                        elsif parity = '1' then
                            impar <= '1';
                        end if;
                        datos <= (others => '0');
                        flag <= '0';
                        rx_busy <= '0';
                        d_valido <= '0';
                        if rx_prev ='1' and rx='0' then
                            flag <= '1';
                            rx_busy <= '1';
                            STATE <= SEQ;
                        end if; 
                    when SEQ =>
                        if count = N-1 then
                            STATE <= PAR;
                            count <= 0;
                        else
                            datos(N-1-count) <= rx;
                            count <= count + 1;
                            if rx = '1' then
                                impar <= not impar;
                            end if;
                        end if;
                    when PAR =>
                        if rx = impar then
                            STATE <= STOP;
                        else
                            STATE <= IDLE;
                        end if;
                    when STOP =>
                        if count = stop_bit then
                            d_valido <= '1';
                            dout <= datos;
                            STATE <= IDLE;
                        else
                            count <= count + 1;
                            if rx = '0' then
                                STATE <= IDLE;
                            end if;
                        end if;
                end case;
                rx_prev <= rx;
            end if;
        end if;
    end process;

end Behavioral;

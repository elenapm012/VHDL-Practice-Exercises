----------------------------------------------------------------------------------
-- Engineer: Elena Peñaranda
-- 
-- Create Date: 12.10.2025 11:41:32
-- Design Name: 
-- Module Name: parking_controller - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- The system monitors vehicle movement using two photo-sensors placed at the parking entrance/exit. 
-- Each sensor outputs a logic high ('1') when its beam is blocked. By analyzing the sequence of sensor activations, 
-- the controller distinguishes between vehicle entry, vehicle exit, and pedestrian crossings.
-- The design tracks the number of vehicles currently parked in the garage, assuming a single shared entrance and exit. 
--
-- A Mealy FSM with an asynchronous reset is used to detect valid entry and exit sequences and update the vehicle count accordingly.
-- The exercise also includes the definition and representation of the FSM state transition diagram, highlighting correct detection of parking occupancy events.
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

entity parking_controller is
    Generic ( N : integer := 7);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           a : in STD_LOGIC;
           b : in STD_LOGIC;
           coches : out STD_LOGIC_VECTOR (N-1 downto 0));
end parking_controller;

architecture Behavioral of parking_controller is
    type states is (BLOQ, SA, SB, SAB);
    signal STATE: states;
    signal CAR_IN, CAR_OUT: std_logic;
    signal cuenta : integer range 0 to 2**N := 0;
begin

    process(clk,reset)
    begin
        if reset = '1' then
            cuenta <= 0;
            STATE <= BLOQ;
            CAR_IN <= '0';
            CAR_OUT <= '0';
        elsif rising_edge(clk) then
            if a = '0' and b = '0' then
                STATE <= BLOQ;
                CAR_IN <= '0';
                CAR_OUT <= '0';
            elsif a = '1' and b = '0' then
                if STATE = SAB and CAR_OUT = '1' then
                    cuenta <= cuenta - 1;
                end if;
                STATE <= SA;
            elsif a = '1' and b = '1' then
                if STATE = SA then
                    CAR_IN <= '1';
                elsif STATE = SB then
                    CAR_OUT <= '1';
                end if;
                STATE <= SAB;
            elsif a = '0' and b = '1' then
                if STATE = SAB and CAR_IN = '1' then
                    cuenta <= cuenta + 1;
                end if;
                STATE <= SB;
            end if;
            coches <= std_logic_vector(to_unsigned(cuenta,N));
        end if;
    end process;
    
end Behavioral;

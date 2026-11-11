-- Ethan and Brayden Shampton
-- Lab 9 Garage door opener
-- 11/11/2026


--Library declarations
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--entity declarations
entity garage is
Port ( RST_L : in STD_LOGIC;
    TOP_L : in STD_LOGIC;
    BOTTOM_L : in STD_LOGIC;
    SENSOR_L : in STD_LOGIC;
    BUTTON_L : in STD_LOGIC;
    UP : out STD_LOGIC;
    DOWN : out STD_LOGIC;
    CLK : in STD_LOGIC);
end garage;


--architecture declarations
architecture behavioral garage is
    type state_type (ReadyDown, ReadyUp, GoingDown, GoingUp);
    signal current_state, next_state : state_type;
begin

--state register
    process (CLK, RST_L)
    begin
        if RST_L is '0' then
            -- stop the door
            current_state <= ReadyDown;
        elsif rising_edge(CLK) then
            current_state<= next_state;
    End process;


--state logic
    process(current_state, TOP_L, BOTTOM_L, SENSOR_L, BUTTON_L)
            if current_state is ReadyDown then
                if BUTTON_L = "1" then
                    next_state is ReadyDown;
                elsif not BUTTON_L and BOTTOM_L and SENSOR_L = "1" then
                    next_state is GoingDown;
                elsif not BOTTON_L and (not BOTTOM_L or not SENSOR_L) then
                    next_state is GoingUp;
                
            elsif current_state is GoingDown then

            elsif current_state is ReadyUp then

            elsif current_state is GoingUp then

            end if;
    end process;
end behavioral;

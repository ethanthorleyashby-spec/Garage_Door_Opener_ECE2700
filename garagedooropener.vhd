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
    
    -- Ready Down
            if current_state is ReadyDown then
                if BUTTON_L = '1' then
                    next_state is ReadyDown;
                elsif not BUTTON_L and BOTTOM_L and SENSOR_L = '1' then
                    next_state is GoingDown;
                elsif not BOTTON_L and (not BOTTOM_L or not SENSOR_L) then
                    next_state is GoingUp;
                end if;
    -- Going Down
            elsif current_state is GoingDown then
                if BUTTON_L and SENSOR_L and Bottom_L = '1' then
                    next_state is GoingDown;
                elsif Button_L and not SENSOR_L = '1' then
                    next_state is Goingup;
                elsif not BUTTON_L or Bottom_L = '1'  then
                    next_state is ReadyUp;
                End if;

    -- Ready Up
            elsif current_state is ReadyUp then
                if BUTTON_L = '1' then 
                    next_state is ReadyUp;
                elsif not BUTTON_L and not TOP_L ='1' then
                    next_state is GoingDown;
                elsif not BUTTON_L and TOP_L ='1' then
                    next_state is GoingUp;
                end if;

    -- Going Up
            elsif current_state is GoingUp then
                if BUTTON_L and TOP_L = '1' then
                    next_state is GoingUp;
                elsif not BUTTON_L or not TOP_L = '1' then
                    next_state is ReadyDown;
                end if;
            end if;
    end process;
end behavioral;

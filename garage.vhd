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
architecture behavioral of garage is
    type state_type is (ReadyDown, ReadyUp, GoingDown, GoingUp);
    signal current_state, next_state : state_type;
    signal btn_sync   : std_logic := '1';
    signal btn_prev   : std_logic := '1';
    signal btn_pulse  : std_logic := '1';
begin

-- Make the Button a Pulse
    process(CLK, RST_L)
    begin
        if RST_L = '0' then
            btn_sync <= '1';
            btn_prev <= '1';
            btn_pulse <= '1';
        elsif rising_edge(CLK) then
            btn_sync <= BUTTON_L;      -- synchronize external input
            btn_prev <= btn_sync;      -- previous sampled value

            -- active-low button: press occurs when it goes 1 -> 0
            if btn_sync = '0' and btn_prev = '1' then
                btn_pulse <= '0';
            else
                btn_pulse <= '1';
            end if;
        end if;
    end process;

-- Driving the Outputs
    UP <= '1' when current_state = GoingUp else '0';
    DOWN <= '1' when current_state = GoingDown else '0';

--state register
    process (CLK, RST_L)
    begin
        if RST_L = '0' then
            -- stop the door
            current_state <= ReadyDown;
        elsif rising_edge(CLK) then
            current_state<= next_state;
        end if;
    end process;


--state logic
    process(current_state, TOP_L, BOTTOM_L, SENSOR_L, btn_pulse)
    begin
        next_state <= current_state;
        -- Ready Down
        if current_state = ReadyDown then
            if btn_pulse = '1' then
                next_state <= ReadyDown;
            elsif (btn_pulse = '0') and (BOTTOM_L = '1') and (SENSOR_L = '1') then
                next_state <= GoingDown;
            elsif (btn_pulse = '0') and ((BOTTOM_L = '0') or (SENSOR_L = '0')) then
                next_state <= GoingUp;
            end if;
        -- Going Down
        elsif current_state = GoingDown then
            if (btn_pulse = '1') and (SENSOR_L = '1') and (BOTTOM_L = '1') then
                next_state <= GoingDown;
            elsif (btn_pulse = '1') and (SENSOR_L = '0') then
                next_state <= Goingup;
            elsif (btn_pulse = '0') or (BOTTOM_L = '1') then
                next_state <= ReadyUp;
            end if;

        -- Ready Up
        elsif current_state = ReadyUp then
            if btn_pulse = '1' then 
                next_state <= ReadyUp;
            elsif (btn_pulse = '0') and (TOP_L = '0') then
                next_state <= GoingDown;
            elsif (btn_pulse = '0') and (TOP_L = '1') then
                next_state <= GoingUp;
            end if;
        -- Going Up
        elsif current_state = GoingUp then
            if (btn_pulse = '1') and (TOP_L = '1') then
                next_state <= GoingUp;
            elsif (btn_pulse = '0') or (TOP_L = '0') then
                next_state <= ReadyDown;
            end if;
        end if;
    end process;
end behavioral;

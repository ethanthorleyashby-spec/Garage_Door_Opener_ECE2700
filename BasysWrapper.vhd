----------------------------------------------------------------------------------
-- Company: Weber State University
-- Engineer: Dr. Brown
-- 
-- Create Date: 07/25/2023 11:07:44 AM
-- Module Name: BasysWrapper - Behavioral
-- Description: This wrapper interfaces Basys switches and LEDs to the garage door
-- opener (garage.vhd) in addition to the actual hardware. The wrapper provides a
-- clock to the garage module if actual hardware is not connected so Basys switches
-- can be used to test the functionality of the system. The mapping of switches and
-- LEDs is determined by the constraints file. The wrapper may be left in place when
-- interfacing to the actual hardware.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BasysWrapper is
    Port ( RST_L : in  STD_LOGIC;
           TOP_L : in  STD_LOGIC;
           BOTTOM_L : in  STD_LOGIC;
           SENSOR_L : in  STD_LOGIC;
           BUTTON_L : in  STD_LOGIC;
           UP : out  STD_LOGIC;
           DOWN : out  STD_LOGIC;
           CLK : in STD_LOGIC;
           -- debug signals
           TOP_SW : in STD_LOGIC;
           BOTTOM_SW : in STD_LOGIC;
           SENSOR_SW : in STD_LOGIC;
           BUTTON_SW : in STD_LOGIC;
           CLK_LED : out STD_LOGIC;
           TOP_LED : out STD_LOGIC;
           BOTTOM_LED : out STD_LOGIC;
           SENSOR_LED : out STD_LOGIC;
           BUTTON_LED : out STD_LOGIC;
           UP_LED : out STD_LOGIC;
           DOWN_LED : out STD_LOGIC;
           CLK_100: in STD_LOGIC
           );
end BasysWrapper;

architecture Behavioral of BasysWrapper is

    component garage is
        Port ( RST_L : in  STD_LOGIC;
               TOP_L : in  STD_LOGIC;
               BOTTOM_L : in  STD_LOGIC;
               SENSOR_L : in  STD_LOGIC;
               BUTTON_L : in  STD_LOGIC;
               UP : out  STD_LOGIC;
               DOWN : out  STD_LOGIC;
               CLK : in  STD_LOGIC);
    end component;
    signal i_top, i_bottom, i_sensor, i_button, i_up, i_down, i_clk, s_clk: std_logic;
    signal prescale: integer range 0 to 4000000;
    signal clock_count: integer range 0 to 11;
begin

  -- synchronize the clockj signal
  s_clk <= clk when rising_edge(clk_100);
  
  -- all inputs are "or"ed from actual hardware and Basys switches. Inputs from hardware
  -- (TOP_L, BOTTOM_L, etc.) should have pullup resistors enabled in the constraints file
  i_top <= not(TOP_SW or not TOP_L);
  i_bottom <= not(BOTTOM_SW or not BOTTOM_L);
  i_sensor <= not(SENSOR_SW or not SENSOR_L);
  i_button <= not(BUTTON_SW or not BUTTON_L);
  
  -- create a clock if none is connected. The CLK pin should have its pullup resistor
  -- enabled in the constraints file. This code also assers CLK_LED every 12th cycle as
  -- an indication that the clock is running. (If the input is held low, which can happen
  -- if the Basys is connected to the hardware but the hardware is not powwered), there
  -- will be no clock pulse and the clock LED will not flash.
  process (RST_L, clk_100)
  begin
    if RST_L = '0' then
      prescale <= 0;
      clock_count <= 0;
      CLK_LED <= '0';
    elsif rising_edge(clk_100) then
      if s_clk = '0' then
        prescale <= 0;
        i_clk <= '0'; -- i_clk usually follows s_clk by one cycle
      elsif prescale >= 4000000 then
        prescale <= 0;
        i_clk <= '0'; -- but here i_clk is set low if s_clk has been high too long
      else
        prescale <= prescale + 1;
        if i_clk = '0' then -- rising edge of internal clock
          if clock_count = 11 then
            clock_count <= 0;
            CLK_LED <= '1';
          else
            clock_count <= clock_count + 1;
            CLK_LED <= '0';
          end if;
        end if;
        i_clk <= '1';
      end if;
    end if;
  end process;
  
  logic: garage port map(
           RST_L => RST_L,
           TOP_L => i_top,
           BOTTOM_L => i_bottom,
           SENSOR_L => i_sensor,
           BUTTON_L => i_button,
           UP => i_up,
           DOWN => i_down,
           CLK => i_clk);
  
  -- output UP and DOWN to both hardware and Basys LEDs
  UP <= i_up;
  DOWN <= i_down;
  UP_LED <= i_up;
  DOWN_LED <= i_down;
  
  -- reflect inputs on Basys LEDs
  TOP_LED <= not i_top;
  BOTTOM_LED <= not i_bottom;
  SENSOR_LED <= not i_sensor;
  BUTTON_LED <= not i_button;

end Behavioral;

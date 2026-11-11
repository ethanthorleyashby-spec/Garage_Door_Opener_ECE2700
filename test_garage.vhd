----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/21/2023 11:21:15 AM
-- Design Name: 
-- Module Name: test_garage - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
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

entity test_garage is
--  Port ( );
end test_garage;

architecture Behavioral of test_garage is
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
  signal rst_l, top_l, bottom_l, sensor_l, button_l, up, down, clk: std_logic;
begin
    uut: garage port map(rst_l, top_l, bottom_l, sensor_l, button_l, up, down, clk);
    
    process
    begin
      clk <= '0';
      wait for 5ns;
      clk <= '1';
      wait for 5ns;
    end process;
    
    process
    begin
      rst_l <= '0';
      top_l <= '1';
      bottom_l <= '1';
      sensor_l <= '1';
      button_l <= '1';
      wait for 10ns;
      assert up = '0' and down = '0';
      rst_l <= '1';
      wait for 30ns;
      assert up = '0' and down = '0';
      -- push button to close door
      button_l <= '0';
      wait for 20ns;
      assert up = '0' and down = '1';
      button_l <= '1';
      wait for 40ns;
      assert up = '0' and down = '1';
      -- door reaches bottom limit
      bottom_l <= '0';
      wait for 20ns;
      assert up = '0' and down = '0';
      -- push button to open door
      button_l <= '0';
      wait for 20ns;
      assert up = '1' and down = '0';
      button_l <= '1';
      wait for 40ns;
      assert up = '1' and down = '0';
      -- bottom limit switch disengages, should make no difference
      bottom_l <= '1';
      wait for 20ns;
      assert up = '1' and down = '0';
      -- bottom limit bounces, should make no difference
      bottom_l <= '0';
      wait for 20ns;
      assert up = '1' and down = '0';
      bottom_l <= '1';
      -- sensor tripped, should make no difference
      sensor_l <= '0';
      wait for 20ns;
      assert up = '1' and down = '0';
      sensor_l <= '1';
      -- top limit engages
      top_l <= '0';
      wait for 20ns;
      assert up = '0' and down = '0';
      -- then bounces, door should remain stopped
      top_l <= '1';
      wait for 20ns;
      assert up = '0' and down = '0';
      top_l <= '0';
      wait for 40ns;
      assert up = '0' and down = '0';
      -- push button to close door
      button_l <= '0';
      wait for 20ns;
      assert up = '0' and down = '1';
      button_l <= '1';
      top_l <= '1';
      wait for 40ns;
      assert up = '0' and down = '1';
      -- sensor trips, should reverse door
      sensor_l <= '0';
      wait for 20ns;
      assert up = '1' and down = '0';
      sensor_l <= '1';
      wait for 40ns;
      assert up = '1' and down = '0';
      -- push button to stop door
      button_l <= '0';
      wait for 20ns;
      assert up = '0' and down = '0';
      button_l <= '1';
      wait for 40ns;
      assert up = '0' and down = '0';
      -- push button again to close door
      button_l <= '0';
      wait for 20ns;
      assert up = '0' and down = '1';
      button_l <= '1';
      wait for 40ns;
      assert up = '0' and down = '1';
      -- push button again to stop door
      button_l <= '0';
      wait for 20ns;
      assert up = '0' and down = '0';
      button_l <= '1';
      wait for 40ns;
      assert up = '0' and down = '0';
      wait;

    end process;

end Behavioral;

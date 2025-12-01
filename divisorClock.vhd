--Alunos:
-- Aurora Cristina Bombassaro
--Gustavo de Oliveira Cardoso Rezende, 
--Gustavo Loureiro Muller Netto.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DivisorClock is
port ( 
    clk50MHz : in  std_logic;
    reset    : in  std_logic;
    clk1Hz   : out std_logic
);
end entity DivisorClock;

architecture Behavioral of DivisorClock is

    constant MAX_COUNT : integer := 24_999_999;

begin

    process(clk50MHz, reset)
        variable cnt : integer range 0 to MAX_COUNT := 0;
        variable clk_internal_state : std_logic := '0'; 
    begin
        
        if (reset = '1') then
            cnt := 0;
            clk_internal_state := '0';
            clk1Hz <= '0';
            
        elsif (rising_edge(clk50MHz)) then
            
            if (cnt = MAX_COUNT) then
                cnt := 0;
                clk_internal_state := not clk_internal_state;
            else
                cnt := cnt + 1;
            end if;
            
            clk1Hz <= clk_internal_state; 
            
        end if;
    end process;

end architecture Behavioral;
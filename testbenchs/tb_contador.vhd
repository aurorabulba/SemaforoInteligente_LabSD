library IEEE;
use IEEE.std_logic_1164.all;

entity tb_contador_n is
end entity;

architecture sim of tb_contador_n is

    constant N : integer := 100;
    signal clear_contador : std_logic := '0';
    signal count : std_logic;

    signal contagem_atual : integer; 
    
    signal clk : std_logic := '1';
    signal clk_enable : std_logic := '1';
    constant tempo : time := 500 us;
begin
    
    uut: entity work.contador_n
    generic map (
        N => N
    )
    
    port map (
        clear_contador => clear_contador,
        clk => clk,
        count => count,

        contagem_atual => contagem_atual
    );
    
    clk <= clk_enable and not clk after tempo / 2;
    
    stim: process
    begin
        -- teste inicial
        wait for tempo * 200;
        
        -- teste clear
        clear_contador <= '1';
        wait for tempo * 200;
      
        -- retirar clear
        clear_contador <= '0';
        wait for tempo * 200;
        
        --terminar o clock
        clk_enable <= '0';
        
        -- fim da simulação
        wait; 
    end process;    
end architecture;

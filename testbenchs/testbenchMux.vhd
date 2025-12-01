--Alunos:
-- Aurora Cristina Bombassaro,
--Gustavo de Oliveira Cardoso Rezende, 
--Gustavo Loureiro Muller Netto.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Mux_5bit is
end tb_Mux_5bit;

architecture behavior of tb_Mux_5bit is

    -- Sinais para conectar ao MUX
    signal t1, t0 : STD_LOGIC;
    signal output : STD_LOGIC_VECTOR(4 downto 0);

    -- Declarando o componente
    component Mux_5bit
        Port (
            t1, t0 : in STD_LOGIC;
            output : out STD_LOGIC_VECTOR(4 downto 0)
        );
    end component;

begin

    -- Instanciando o DUT (Device Under Test)
    uut : Mux_5bit
        port map(
            t1 => t1,
            t0 => t0,
            output => output
        );

    -- Processo de estimulos
    stim_proc : process
    begin
        -------------------------------------------------------------
        -- Teste 00 - saida deve ser "00010"
        -------------------------------------------------------------
        t1 <= '0'; 
        t0 <= '0';
        wait for 20 ns;

        -------------------------------------------------------------
        -- Teste 01 - saida deve ser "01010"
        -------------------------------------------------------------
        t1 <= '0'; 
        t0 <= '1';
        wait for 20 ns;

        -------------------------------------------------------------
        -- Teste 10 - saida deve ser "11100"
        -------------------------------------------------------------
        t1 <= '1'; 
        t0 <= '0';
        wait for 20 ns;

        -------------------------------------------------------------
        -- Teste 11 - saida deve ser "00000"
        -------------------------------------------------------------
        t1 <= '1'; 
        t0 <= '1';
        wait for 20 ns;

        wait;
    end process;

end behavior;

--Alunos:
-- Aurora Cristina Bombassaro,
--Gustavo de Oliveira Cardoso Rezende, 
--Gustavo Loureiro Muller Netto.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_Comparador_5bit is
end entity;

architecture TB of tb_Comparador_5bit is

    signal A   : std_logic_vector(4 downto 0) := (others => '0');
    signal B   : std_logic_vector(4 downto 0) := (others => '0');
    signal EQ  : std_logic;

begin

    DUT: entity work.Comparador_5bit
        port map(
            A  => A,
            B  => B,
            EQ => EQ
        );

    stim_proc: process
    begin
        -- Teste 1: iguais
        A <= "00000";
        B <= "00000";
        wait for 20 ns;

        -- Teste 2: diferentes
        A <= "00001";
        B <= "00000";
        wait for 20 ns;

        -- Teste 3: iguais novamente
        A <= "10101";
        B <= "10101";
        wait for 20 ns;

        -- Teste 4: diferentes
        A <= "11111";
        B <= "00001";
        wait for 20 ns;

        -- Teste 5: diferentes
        A <= "01010";
        B <= "11000";
        wait for 20 ns;

        wait;
    end process;

end architecture;

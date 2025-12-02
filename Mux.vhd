--Multiplexador (MUX) para selecionar qual dos 3 limites de tempo sera enviado ao comparador

--Alunos:
-- Aurora Cristina Bombassaro,
--Gustavo de Oliveira Cardoso Rezende, 
--Gustavo Loureiro Muller Netto.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_5bit is
    Port (
        t1, t0 : in STD_LOGIC;                     -- Seletores
        output : out STD_LOGIC_VECTOR(4 downto 0) -- Saída
    );
end Mux_5bit;

architecture Behavioral of Mux_5bit is
signal sel : STD_LOGIC_VECTOR(1 downto 0);
begin
    --Entrada para escolher qual será o tempo de saida
    sel <= t1 & t0;

    process(sel)
    begin
        --Selecionando o tempo de saida
        case sel is
            when "00" =>
                output <= "00010";   -- tempo verde
            when "01" =>
                output <= "01010";   -- tempo amarelo
            when "10" =>
                output <= "11100";   -- tempo vermelho
            when others =>
                output <= (others => '0');  
        end case;
    end process;

end Behavioral;

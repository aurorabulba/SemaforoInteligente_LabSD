--Comparador

--Alunos:
-- Aurora Cristina Bombassaro,
--Gustavo de Oliveira Cardoso Rezende, 
--Gustavo Loureiro Muller Netto.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Comparador_5bit is
    port(
        A   : in  std_logic_vector(4 downto 0);
        B   : in  std_logic_vector(4 downto 0);
        EQ  : out std_logic
    );
end entity;

architecture Behavioral of Comparador_5bit is
begin
    -- EQ = '1' quando A == B
    EQ <= '1' when (unsigned(A) = unsigned(B)) else '0';
end architecture;

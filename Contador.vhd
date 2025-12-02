--Alunos:
-- Aurora Cristina Bombassaro,
--Gustavo de Oliveira Cardoso Rezende, 
--Gustavo Loureiro Muller Netto.

library IEEE;
use IEEE.std_logic_1164.all;

entity contador_n is
  generic (

    N : integer := 4
  );
  port (

    clear_contador : in std_logic;
    clk : in std_logic;
    
    count : out std_logic := '0';

    contagem_atual : out integer range 0 to N 
  );
end entity;

architecture cnt of contador_n is

    signal contador : integer range 0 to N := 0;
begin

    contagem_atual <= contador;

    process(clk, clear_contador)
    begin
        if (clear_contador = '1') then

            count <= '0';
            

            contador <= 0;
        elsif (rising_edge(clk)) then            
            if (contador = N) then

                count <= '1';
                
                contador <= 0;
            else

                contador <= contador + 1;
                
                count <= '0';
            end if;
      end if;
  end process;
end architecture;

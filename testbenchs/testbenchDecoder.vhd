--Alunos:
-- Aurora Cristina Bombassaro,
--Gustavo de Oliveira Cardoso Rezende, 
--Gustavo Loureiro Muller Netto.

library IEEE;
use IEEE.std_logic_1164.all;

-- Testbench para o Decoder
-- Alunos:
-- Aurora Cristina Bombassaro,
-- Gustavo de Oliveira Cardoso Rezende, 
-- Gustavo Loureiro Muller Netto.

entity tb_Decoder is
end entity tb_Decoder;

architecture sim of tb_Decoder is

    component Decoder is
        port (
            estado_in  : in  std_logic_vector(2 downto 0);
            p_red     : out STD_LOGIC;
            p_yellow  : out STD_LOGIC;
            p_green   : out STD_LOGIC;
            s_red     : out STD_LOGIC;
            s_yellow  : out STD_LOGIC;
            s_green   : out STD_LOGIC
        );
    end component Decoder;

    signal s_estado_in  : std_logic_vector(2 downto 0) := "000"; -- Valor inicial
    

    signal s_p_red     : STD_LOGIC;
    signal s_p_yellow  : STD_LOGIC;
    signal s_p_green   : STD_LOGIC;
    signal s_s_red     : STD_LOGIC;
    signal s_s_yellow  : STD_LOGIC;
    signal s_s_green   : STD_LOGIC;

    -- Constante para o periodo de espera
    constant T_WAIT : time := 100 ns;

begin


    uut_Decoder : Decoder
        port map (
            -- Entradas
            estado_in  => s_estado_in,
            
            -- Saidas
            p_red      => s_p_red,
            p_yellow   => s_p_yellow,
            p_green    => s_p_green,
            s_red      => s_s_red,
            s_yellow   => s_s_yellow,
            s_green    => s_s_green
        );

    -- Aplicando todos os 8 valores de entrada possiveis.
    stimulus_proc : process
    begin
        report "Iniciando Testbench para Decoder";

        -- Teste 1: Estado "000" (Principal Verde, Secundaria Vermelha)
        s_estado_in <= "000";
        wait for T_WAIT;

        -- Teste 2: Estado "001" (Principal Amarelo, Secundaria Vermelha)
        s_estado_in <= "001";
        wait for T_WAIT;

        -- Teste 3: Estado "010" (Ambas Vermelhas)
        s_estado_in <= "010";
        wait for T_WAIT;

        -- Teste 4: Estado "011" (Principal Vermelha, Secundaria Verde)
        s_estado_in <= "011";
        wait for T_WAIT;

        -- Teste 5: Estado "100" (Principal Vermelha, Secundaria Amarela)
        s_estado_in <= "100";
        wait for T_WAIT;

        -- Teste 6: Estado "101" (Ambas Vermelhas)
        s_estado_in <= "101";
        wait for T_WAIT;

        -- Teste 7: Estado "110" (Nao utilizado - 'others')
        s_estado_in <= "110";
        wait for T_WAIT;

        -- Teste 8: Estado "111" (Nao utilizado - 'others')
        s_estado_in <= "111";
        wait for T_WAIT;

        report "Testbench Concluido.";
      
        wait; 
    end process stimulus_proc;

end architecture sim;
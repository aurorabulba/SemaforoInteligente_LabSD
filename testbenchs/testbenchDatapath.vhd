library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Datapath is
end tb_Datapath;

architecture Sim of tb_Datapath is

    component Datapath is
        Port (
            clk            : in  STD_LOGIC;
            reset_contador : in  STD_LOGIC;
            t1, t0         : in  STD_LOGIC;
            estado_in      : in  STD_LOGIC_VECTOR(2 downto 0);
            tempo_acabou   : out STD_LOGIC;
            p_red, p_yellow, p_green : out STD_LOGIC;
            s_red, s_yellow, s_green : out STD_LOGIC
        );
    end component;

    signal s_clk            : STD_LOGIC := '0';
    signal s_reset_contador : STD_LOGIC := '0';
    signal s_t1, s_t0       : STD_LOGIC := '0';
    signal s_estado_in      : STD_LOGIC_VECTOR(2 downto 0) := "000";
    
    signal s_tempo_acabou   : STD_LOGIC;
    signal s_p_red, s_p_yellow, s_p_green : STD_LOGIC;
    signal s_s_red, s_s_yellow, s_s_green : STD_LOGIC;
    
    signal sim_active : boolean := true;

    constant CLK_PERIOD : time := 10 ns;

begin

    uut: Datapath
        port map (
            clk            => s_clk,
            reset_contador => s_reset_contador,
            t1             => s_t1,
            t0             => s_t0,
            estado_in      => s_estado_in,
            tempo_acabou   => s_tempo_acabou,
            p_red          => s_p_red,
            p_yellow       => s_p_yellow,
            p_green        => s_p_green,
            s_red          => s_s_red,
            s_yellow       => s_s_yellow,
            s_green        => s_s_green
        );

    -- Processo de Clock com "Botão de Desligar"
    -- Ele só gera clock enquanto 'sim_active' for verdadeiro (para evitar de dar timeout)
    clock_process: process
    begin
        while sim_active loop
            s_clk <= '0';
            wait for CLK_PERIOD/2;
            s_clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait; 
    end process;

    -- Processo de Estímulos
    stim_proc: process
    begin
        report "INICIO DO TESTE";

        -- Setup Inicial
        s_reset_contador <= '1';
        s_t1 <= '0'; s_t0 <= '0';
        s_estado_in <= "000";
        wait for CLK_PERIOD;
        s_reset_contador <= '0';

        -- Teste 1: Esperar o contador chegar a 2
        -- 2 pulsos * 10ns = 20ns. Vamos esperar 50ns para garantir.
        wait for 50 ns;

        -- Checkpoint visual
        if s_tempo_acabou = '1' then
            report "SUCESSO!";
        else
            report "FALHA: Tempo nao acabou.";
        end if;

        -- Teste 2: Testar LEDs
        s_estado_in <= "011"; -- Muda os LEDs
        wait for 20 ns;

        -- FIM DO TESTE
        report "FIM DO TESTE - Desligando Clock";
        sim_active <= false; -- Evitando timeout
        wait;
    end process;

end Sim;

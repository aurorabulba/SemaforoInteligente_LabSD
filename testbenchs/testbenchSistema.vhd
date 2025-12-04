--Semaforo Inteligente

--Alunos:
-- Aurora Cristina Bombassaro,
--Gustavo de Oliveira Cardoso Rezende, 
--Gustavo Loureiro Muller Netto.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Semaforo_inteligente is
end tb_Semaforo_inteligente;

architecture Behavioral of tb_Semaforo_inteligente is

    -- 1. Declaração do componente Top-Level
    component Semaforo_inteligente is
        Port (
            CLOCK_50   : in  STD_LOGIC;
            KEY_RESET  : in  STD_LOGIC;
            SW_SENSOR1 : in  STD_LOGIC;
            SW_SENSOR2 : in  STD_LOGIC;
            KEY_BOTAO  : in  STD_LOGIC;
            LEDR_PRINC : out STD_LOGIC_VECTOR(2 downto 0);
            LEDR_SEC   : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    -- 2. Sinais para conectar ao DUT (Device Under Test)
    signal s_clk        : std_logic := '0';
    signal s_rst        : std_logic := '0';
    signal s_sensor1    : std_logic := '0';
    signal s_sensor2    : std_logic := '0';
    signal s_botao      : std_logic := '0';
    
    signal s_leds_princ : std_logic_vector(2 downto 0);
    signal s_leds_sec   : std_logic_vector(2 downto 0);
    
        signal sim_active : boolean := true;

    -- Clock de 50MHz (Período de 20ns)
    constant CLK_PERIOD : time := 20 ns;

begin

    -- 3. Instanciação do Semaforo
    DUT: Semaforo_inteligente
        port map (
            CLOCK_50   => s_clk,
            KEY_RESET  => s_rst,
            SW_SENSOR1 => s_sensor1,
            SW_SENSOR2 => s_sensor2,
            KEY_BOTAO  => s_botao,
            LEDR_PRINC => s_leds_princ,
            LEDR_SEC   => s_leds_sec
        );

    -- 4. Processo Gerador de Clock (50MHz)
    clk_process : process
    begin
    while sim_active loop
        s_clk <= '0';
        wait for CLK_PERIOD/2;
        s_clk <= '1';
        wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    -- 5. Processo de Estímulos
    stim_proc: process
    begin
       
        report "Iniciando Simulação do Semáforo Inteligente...";
        
        -- Reset inicial
        s_rst <= '1';
        s_sensor1 <= '0';
        s_sensor2 <= '0';
        s_botao <= '0';
        wait for 200 ns;
        
        s_rst <= '0';
        report "Reset liberado. Estado deve ser Vermelho-Vermelho.";
        wait for 500 ns; -- Espera um tempo no estado ocioso

        -- === TESTE 1: Carro na Via Principal ===
        report "TESTE 1: Sensor 1 Ativado (Via Principal)";
        s_sensor1 <= '1';
        wait for 100 ns;
        s_sensor1 <= '0'; -- Pulso do sensor

        -- Como alteramos o DivisorClock, não sabemos o tempo exato em 'ns',
        -- então vamos esperar o suficiente para cobrir Verde(15) -> Amarelo(3) -> Vermelho
        -- Assumindo MAX_COUNT baixo, isso será rápido.
        wait for 5000 ns; 
        
        report "Ciclo Principal deve ter terminado. Voltando ao repouso.";
        wait for 500 ns;

        -- === TESTE 2: Carro na Via Secundária ===
        report "TESTE 2: Sensor 2 Ativado (Via Secundária)";
        s_sensor2 <= '1';
        wait for 100 ns;
        s_sensor2 <= '0';

        -- Esperar o ciclo da secundária (Verde 10s -> Amarelo 3s)
        wait for 5000 ns;

        -- === TESTE 3: Pedestre ===
        report "TESTE 3: Botão Pedestre Ativado";
        s_botao <= '1';
        wait for 100 ns;
        s_botao <= '0';

        -- Esperar ciclo do pedestre (igual ao secundário)
        wait for 5000 ns;

        -- === TESTE 4: Prioridade (Ambos juntos) ===
        report "TESTE 4: Conflito (Sensor 1 + Sensor 2)";
        s_sensor1 <= '1';
        s_sensor2 <= '1';
        wait for 100 ns;
        s_sensor1 <= '0';
        s_sensor2 <= '0';
        
        report "Verifique se o semáforo abriu para a PRINCIPAL (Prioridade).";
        wait for 5000 ns;

        report "Fim da Simulação.";

            sim_active <= false; -- ISSO EVITA O TIMEOUT
                    wait;
    end process;

end Behavioral;

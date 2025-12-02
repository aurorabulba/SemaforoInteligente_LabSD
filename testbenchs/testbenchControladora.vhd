--Alunos:
-- Aurora Cristina Bombassaro
--Gustavo de Oliveira Cardoso Rezende, 
--Gustavo Loureiro Muller Netto.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.ALL; -- Necessário para usar 'report'


-- Entidade do Testbench (vazia)
entity tb_Controller is
end tb_Controller;

architecture Behavioral of tb_Controller is

    -- 1. Declaração do Componente (Seu design "Controller")
    component Controller is
        Generic (
            CLK_FREQ        : integer := 50_000_000;
            TIME_YELLOW     : integer := 3;
            TIME_GREEN_MAIN : integer := 15;
            TIME_GREEN_SIDE : integer := 10
        );
        Port (
            clk             : in  STD_LOGIC;
            rst             : in  STD_LOGIC;
            sensor1         : in  STD_LOGIC;
            sensor2         : in  STD_LOGIC;
            botao           : in  STD_LOGIC;
            luzes_principais  : out STD_LOGIC_VECTOR(2 downto 0);
            luzes_secundarias : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    -- 2. Constantes para o Testbench (Simulação Rápida)
    
    -- Usaremos 10 Hz para simulação
    constant TB_CLK_FREQ        : integer := 10; 
    constant TB_TIME_YELLOW     : integer := 3;
    constant TB_TIME_GREEN_MAIN : integer := 15;
    constant TB_TIME_GREEN_SIDE : integer := 10;
    
    -- Período do clock (1 / 10 Hz = 100 ms)
    constant CLK_PERIOD         : time := 100 ms;

    -- 3. Sinais de Conexão (fios)
    signal s_clk             : STD_LOGIC := '0';
    signal s_rst             : STD_LOGIC;
    signal s_sensor1         : STD_LOGIC;
    signal s_sensor2         : STD_LOGIC;
    signal s_botao           : STD_LOGIC;
    signal s_luzes_principais  : STD_LOGIC_VECTOR(2 downto 0);
    signal s_luzes_secundarias : STD_LOGIC_VECTOR(2 downto 0);

    -- Constantes para checagem (facilitam a leitura)
    constant RED    : std_logic_vector(2 downto 0) := "100";
    constant YELLOW : std_logic_vector(2 downto 0) := "010";
    constant GREEN  : std_logic_vector(2 downto 0) := "001";

begin

    -- 4. Instanciação do "Design Under Test" (DUT)
    UUT : component Controller
        Generic map (
            -- Mapeando os genéricos do DUT para os valores do Testbench
            CLK_FREQ        => TB_CLK_FREQ,
            TIME_YELLOW     => TB_TIME_YELLOW,
            TIME_GREEN_MAIN => TB_TIME_GREEN_MAIN,
            TIME_GREEN_SIDE => TB_TIME_GREEN_SIDE
        )
        Port map (
            clk             => s_clk,
            rst             => s_rst,
            sensor1         => s_sensor1,
            sensor2         => s_sensor2,
            botao           => s_botao,
            luzes_principais  => s_luzes_principais,
            luzes_secundarias => s_luzes_secundarias
        );

    -- 5. Processo Gerador de Clock
    clk_process : process
    begin
        s_clk <= '0';
        wait for CLK_PERIOD / 2; -- 50 ms
        s_clk <= '1';
        wait for CLK_PERIOD / 2; -- 50 ms
    end process;

    -- 6. Processo de Estímulo (A simulação)
    stimulus_process : process
        -- Função helper para esperar N segundos de simulação
        procedure wait_sec(seconds : integer) is
        begin
            wait for (seconds * TB_CLK_FREQ) * CLK_PERIOD;
        end procedure;
    begin
        
        -- Início: Aplicar Reset
        report "Simulação Iniciada. Aplicando Reset...";
        s_rst <= '1';
        s_sensor1 <= '0'; s_sensor2 <= '0'; s_botao <= '0';
        wait for CLK_PERIOD * 5; -- Mantém o reset por 5 ciclos
        
        s_rst <= '0';
        report "Reset liberado. Esperando 2s em RedRed.";
        
        -- Teste 1: Ocioso
        -- O sistema deve ficar em RedRed. Espera 2 segundos.
        wait_sec(2);
        
        -- Teste 2: Ciclo Via Principal
        report "TESTE 2: Ativando sensor1 (Via Principal)...";
        s_sensor1 <= '1';
        wait for CLK_PERIOD; -- Pulso de 1 ciclo
        s_sensor1 <= '0';
        
        -- Deve ir para ST_GreenRed (dura 15s)
        wait_sec(TB_TIME_GREEN_MAIN);
        
        -- Deve ir para ST_YellowRed (dura 3s)
        wait_sec(TB_TIME_YELLOW);
        
        -- Deve voltar para ST_RedRed. Espera 2s para confirmar.
        report "Ciclo Principal completo. Voltando para RedRed por 2s.";
        wait_sec(2);

        -- Teste 3: Ciclo Via Secundária
        report "TESTE 3: Ativando sensor2 (Via Secundária)...";
        s_sensor2 <= '1';
        wait for CLK_PERIOD;
        s_sensor2 <= '0';
        
        -- Deve ir para ST_RedGreen (dura 10s)
        wait_sec(TB_TIME_GREEN_SIDE);
        
        -- Deve ir para ST_RedYellow (dura 3s)
        wait_sec(TB_TIME_YELLOW);
        
        report "Ciclo Secundário completo. Voltando para RedRed por 2s.";
        wait_sec(2);
        
        -- Teste 4: Ciclo Pedestre
        report "TESTE 4: Ativando botao (Pedestre)...";
        s_botao <= '1';
        wait for CLK_PERIOD;
        s_botao <= '0';
        
        -- Deve ir para ST_RedGreen (dura 10s)
        wait_sec(TB_TIME_GREEN_SIDE);
        
        -- Deve ir para ST_RedYellow (dura 3s)
        wait_sec(TB_TIME_YELLOW);
        
        report "Ciclo Pedestre completo. Voltando para RedRed por 2s.";
        wait_sec(2);

        -- Teste 5: Prioridade (Ambos ao mesmo tempo)
        report "TESTE 5: Conflito (sensor1 e sensor2 ao mesmo tempo).";
        s_sensor1 <= '1';
        s_sensor2 <= '1';
        wait for CLK_PERIOD;
        s_sensor1 <= '0';
        s_sensor2 <= '0';
        
        -- A lógica if/elsif prioriza sensor1. Deve executar o ciclo PRINCIPAL.
        report "-> Deve executar o ciclo PRINCIPAL (15s + 3s).";
        wait_sec(TB_TIME_GREEN_MAIN);
        wait_sec(TB_TIME_YELLOW);
        
        report "Simulação Concluída.";
      
        wait;
    end process;
    

end Behavioral;

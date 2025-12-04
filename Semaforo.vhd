--Semaforo Inteligente

--Alunos:
-- Aurora Cristina Bombassaro,
--Gustavo de Oliveira Cardoso Rezende, 
--Gustavo Loureiro Muller Netto.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Semaforo_inteligente is
    Port (
        CLOCK_50   : in  STD_LOGIC; -- Clock da placa DE10/DE2 etc.
        KEY_RESET  : in  STD_LOGIC; -- Botão de reset
        
        -- Sensores e Botões (Switches e Keys)
        SW_SENSOR1 : in  STD_LOGIC;
        SW_SENSOR2 : in  STD_LOGIC;
        KEY_BOTAO  : in  STD_LOGIC;
        
        -- Saídas físicas para os LEDs
        LEDR_PRINC : out STD_LOGIC_VECTOR(2 downto 0); -- R, Y, G
        LEDR_SEC   : out STD_LOGIC_VECTOR(2 downto 0)
    );
end Semaforo_inteligente;

architecture Structural of Semaforo_inteligente is

    -- Sinais de interconexão
    signal w_clk_1hz      : std_logic;
    signal w_reset_cnt    : std_logic;
    signal w_tempo_acabou : std_logic;
    signal w_t1, w_t0     : std_logic;
    signal w_estado       : std_logic_vector(2 downto 0);

    -- Componentes
    component DivisorClock
        port ( clk50MHz : in std_logic; reset : in std_logic; clk1Hz : out std_logic );
    end component;

    component Controller
        port (
            clk, rst, sensor1, sensor2, botao, tempo_acabou : in std_logic;
            reset_contador, t1, t0 : out std_logic;
            estado_out : out std_logic_vector(2 downto 0)
        );
    end component;

    component Datapath
        port (
            clk, reset_contador, t1, t0 : in std_logic;
            estado_in : in std_logic_vector(2 downto 0);
            tempo_acabou : out std_logic;
            p_red, p_yellow, p_green, s_red, s_yellow, s_green : out std_logic
        );
    end component;

begin

    -- 1. Gerador de Clock (50MHz -> 1Hz)
    U_Divisor: DivisorClock
        port map ( clk50MHz => CLOCK_50, reset => KEY_RESET, clk1Hz => w_clk_1hz );

    -- 2. Cérebro (Controladora)
    U_Controller: Controller
        port map (
            clk            => w_clk_1hz,    -- Usa o clock lento
            rst            => KEY_RESET,
            sensor1        => SW_SENSOR1,
            sensor2        => SW_SENSOR2,
            botao          => KEY_BOTAO,
            tempo_acabou   => w_tempo_acabou, -- Recebe do Datapath
            
            reset_contador => w_reset_cnt,    -- Envia pro Datapath
            t1             => w_t1,
            t0             => w_t0,
            estado_out     => w_estado
        );

    -- 3. Corpo (Datapath)
    U_Datapath: Datapath
        port map (
            clk            => w_clk_1hz,    -- Usa o clock lento para contar segundos
            reset_contador => w_reset_cnt,
            t1             => w_t1,
            t0             => w_t0,
            estado_in      => w_estado,     -- Recebe o estado para decodificar
            tempo_acabou   => w_tempo_acabou, -- Avisa quando terminar
            
            -- Liga direto nos pinos de saída
            p_red => LEDR_PRINC(2), p_yellow => LEDR_PRINC(1), p_green => LEDR_PRINC(0),
            s_red => LEDR_SEC(2),   s_yellow => LEDR_SEC(1),   s_green => LEDR_SEC(0)
        );

end Structural;

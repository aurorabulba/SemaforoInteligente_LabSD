
--Alunos:
-- Aurora Cristina Bombassaro,
--Gustavo de Oliveira Cardoso Rezende, 
--Gustavo Loureiro Muller Netto.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Necessário para converter Integer para STD_LOGIC_VECTOR

entity Datapath is
    Port (
        -- Entradas de Controle (vindas da FSM ou Top-Level)
        clk            : in  STD_LOGIC;                    -- Clock (deve ser o de 1Hz)
        reset_contador : in  STD_LOGIC;                    -- Reseta a contagem
        t1, t0         : in  STD_LOGIC;                    -- Selecionam o tempo no Mux
        estado_in      : in  STD_LOGIC_VECTOR(2 downto 0); -- Estado atual para o Decodificador

        -- Saída de Status (para a FSM)
        tempo_acabou   : out STD_LOGIC;                    -- Indica se o tempo chegou ao fim

        -- Saídas Físicas (LEDs)
        p_red, p_yellow, p_green : out STD_LOGIC;
        s_red, s_yellow, s_green : out STD_LOGIC
    );
end Datapath;

architecture Structural of Datapath is

    -- 1. Declaração dos Componentes (baseados nos seus arquivos)
    
    component Mux_5bit is
        Port (
            t1, t0 : in STD_LOGIC;
            output : out STD_LOGIC_VECTOR(4 downto 0)
        );
    end component;

    component contador_n is
        generic ( N : integer := 4 ); -- Vamos configurar N para 31
        port (
            clear_contador : in std_logic;
            clk            : in std_logic;
            count          : out std_logic; -- Overflow (não usaremos aqui)
            contagem_atual : out integer range 0 to N
        );
    end component;

    component Comparador_5bit is
        port(
            A   : in  std_logic_vector(4 downto 0);
            B   : in  std_logic_vector(4 downto 0);
            EQ  : out std_logic
        );
    end component;

    component Decoder is
        port (
            estado_in : in  std_logic_vector(2 downto 0);
            p_red     : out STD_LOGIC;
            p_yellow  : out STD_LOGIC;
            p_green   : out STD_LOGIC;
            s_red     : out STD_LOGIC;
            s_yellow  : out STD_LOGIC;
            s_green   : out STD_LOGIC
        );
    end component;

    -- 2. Sinais Internos para conectar os blocos
    
    signal s_limite_tempo  : STD_LOGIC_VECTOR(4 downto 0); -- Sai do Mux, entra no Comparador
    signal s_conta_int     : integer range 0 to 31;        -- Sai do Contador (formato inteiro)
    signal s_conta_vetor   : STD_LOGIC_VECTOR(4 downto 0); -- Sai do Contador (convertido para vetor)

begin

    -- Instância 1: Multiplexador
    -- Seleciona o tempo limite (A, B ou C) baseado em t1 e t0
    u_mux: Mux_5bit
        port map (
            t1     => t1,
            t0     => t0,
            output => s_limite_tempo -- Vai para a entrada B do comparador
        );

    -- Instância 2: Contador
    -- Conta os pulsos de clock (segundos). 
    -- N=31 permite contar até o máximo que cabe em 5 bits (0 a 31).
    u_contador: contador_n
        generic map ( N => 31 ) 
        port map (
            clk            => clk,
            clear_contador => reset_contador,
            count          => open, -- Não precisamos do sinal de overflow interno
            contagem_atual => s_conta_int
        );

    -- CONVERSAO DE TIPO: Integer -> Std_Logic_Vector
    -- O contador entrega um Inteiro, mas o comparador quer Vetor.
    s_conta_vetor <= std_logic_vector(to_unsigned(s_conta_int, 5));

    -- Instância 3: Comparador
    -- Verifica se a contagem atual (A) atingiu o limite do Mux (B)
    u_comparador: Comparador_5bit
        port map (
            A  => s_conta_vetor,  -- Contagem atual
            B  => s_limite_tempo, -- Limite selecionado
            EQ => tempo_acabou    -- Saída para a FSM (1 se igual)
        );

    -- Instância 4: Decodificador
    -- Traduz o código do estado (3 bits) para acender os LEDs
    u_decoder: Decoder
        port map (
            estado_in => estado_in,
            p_red     => p_red,
            p_yellow  => p_yellow,
            p_green   => p_green,
            s_red     => s_red,
            s_yellow  => s_yellow,
            s_green   => s_green
        );

end Structural;

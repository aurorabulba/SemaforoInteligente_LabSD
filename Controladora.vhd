library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Controller is
    Port (
        clk            : in  STD_LOGIC;
        rst            : in  STD_LOGIC;
        sensor1        : in  STD_LOGIC;
        sensor2        : in  STD_LOGIC;
        botao          : in  STD_LOGIC;
        tempo_acabou   : in  STD_LOGIC;
        
        reset_contador : out STD_LOGIC;
        t1, t0         : out STD_LOGIC;
        estado_out     : out STD_LOGIC_VECTOR(2 downto 0)
    );
end Controller;

architecture Behavioral of Controller is
    type state_type is (ST_RedRed, ST_GreenRed, ST_YellowRed, ST_RedGreen, ST_RedYellow);
    signal current_state, next_state : state_type;
    signal last_state : state_type; -- Memória do estado anterior
    signal ultimo_foi_principal : std_logic := '0'; -- '1' se a Main foi a última, '0' se foi a Side
begin


    -- Processo Sequencial (Memória)
    process(clk, rst)
    begin
        if rst = '1' then
    		current_state <= ST_GreenRed;
            last_state    <= ST_RedRed;
        elsif rising_edge(clk) then
            current_state <= next_state;
            last_state    <= current_state; -- Guarda quem era o estado no ciclo passado
            if (current_state /= next_state) then
                -- Se estamos INDO para o verde da principal, marcamos ela como a última
                if (next_state = ST_GreenRed) then
                    ultimo_foi_principal <= '1'; 
                -- Se estamos INDO para o verde da secundária, marcamos ela como a última
                elsif (next_state = ST_RedGreen) then
                    ultimo_foi_principal <= '0';
                end if;
            end if;
            
        end if;
    end process;

    -- Lógica de Reset Inteligente (Evita o Crash)
    -- Se acabamos de mudar de estado (current diferente de last), resetamos o contador.
    process(current_state, last_state)
    begin
        if current_state = ST_RedRed then
            reset_contador <= '1'; -- No vermelho-vermelho, mantém resetado
        elsif current_state /= last_state then
            reset_contador <= '1'; -- Pulso de reset na troca de estado
        else
            reset_contador <= '0'; -- Deixa contar
        end if;
    end process;

    -- Lógica de Próximo Estado e Saídas
    process(current_state, sensor1, sensor2, botao, tempo_acabou)
    begin
        next_state <= current_state;
        t1 <= '0'; t0 <= '0';
        estado_out <= "010";

        case current_state is
            when ST_RedRed =>
                estado_out <= "010";
        -- Cenário: Conflito (Ambos querem passar)
                if (sensor1 = '1' AND (sensor2 = '1' OR botao = '1')) then
                    -- Aqui usamos a memória para desempatar:
                    if ultimo_foi_principal = '1' then
                        next_state <= ST_RedGreen; -- Foi a principal? Agora é a vez da secundária.
                    else
                        next_state <= ST_GreenRed; -- Foi a secundária? Agora é a vez da principal.
                    end if;

                -- Cenário: Só a Principal quer passar
                elsif (sensor1 = '1') then
                    next_state <= ST_RedRed;

                -- Cenário: Só a Secundária quer passar
                elsif (sensor2 = '1' OR botao = '1') then
                    next_state <= ST_RedGreen;

                -- Cenário: Ninguém quer passar
                else
                    next_state <= ST_GreenRed;
                end if;

            when ST_GreenRed =>
                t1 <= '0'; t0 <= '0'; -- 15s
                estado_out <= "000";
                if tempo_acabou = '1' then next_state <= ST_YellowRed; end if;

            when ST_YellowRed =>
                t1 <= '0'; t0 <= '1'; -- 3s
                estado_out <= "001";
                if tempo_acabou = '1' then next_state <= ST_RedRed; end if;

            when ST_RedGreen =>
                t1 <= '1'; t0 <= '0'; -- 10s
                estado_out <= "011";
                if tempo_acabou = '1' then next_state <= ST_RedYellow; end if;

            when ST_RedYellow =>
                t1 <= '0'; t0 <= '1'; -- 3s
                estado_out <= "100";
                if tempo_acabou = '1' then next_state <= ST_RedRed; end if;
                
            when others =>
                next_state <= ST_RedRed;
        end case;
    end process;

end Behavioral;

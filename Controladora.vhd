--Alunos:
-- Aurora Cristina Bombassaro,
--Gustavo de Oliveira Cardoso Rezende, 
--Gustavo Loureiro Muller Netto.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--Alunos:
-- Aurora Cristina Bombassaro,
--Gustavo de Oliveira Cardoso Rezende, 
--Gustavo Loureiro Muller Netto.

entity Controller is
    Generic (
        CLK_FREQ        : integer := 50_000_000; -- Clock da FPGA 
        TIME_YELLOW     : integer := 3;          -- Tempo do Amarelo (segundos)
        TIME_GREEN_MAIN : integer := 15;        
        TIME_GREEN_SIDE : integer := 10         -- Tempo do Verde Secundário (segundos)
        
        
    );
    Port (
        clk             : in  STD_LOGIC;
        rst             : in  STD_LOGIC;
        sensor1         : in  STD_LOGIC; -- Sensor da rua principal
        sensor2         : in  STD_LOGIC; -- Sensor da rua secundária
        botao           : in  STD_LOGIC; -- Botão do pedestre
        
        luzes_principais  : out STD_LOGIC_VECTOR(2 downto 0); -- (2:R, 1:Y, 0:G)
        luzes_secundarias : out STD_LOGIC_VECTOR(2 downto 0)  -- (2:R, 1:Y, 0:G)
    );
end Controller;

architecture Behavioral of Controller is

    -- Definição dos Estados da FSM
    type state_type is (ST_GreenRed, ST_YellowRed, ST_RedRed, ST_RedGreen, ST_RedYellow);
    signal current_state, next_state : state_type;

    -- Sinais para contagem de tempo
    
    signal counter : integer range 0 to (CLK_FREQ * TIME_GREEN_MAIN);
    
    
    
    -- Constantes para os valores dos LEDs (3 bits)
    constant RED    : std_logic_vector(2 downto 0) := "100";
    constant YELLOW : std_logic_vector(2 downto 0) := "010";
    constant GREEN  : std_logic_vector(2 downto 0) := "001";

begin

    -- PROCESSO 1: Lógica Sequencial (Clock e Reset)
    process(clk, rst)
    begin
        if rst = '1' then
           
            current_state <= ST_RedRed; 
            counter       <= 0;
         
            
        elsif rising_edge(clk) then
            
            if current_state /= next_state then
                current_state <= next_state;
                counter       <= 0; 
            else
                
                if counter < (CLK_FREQ * TIME_GREEN_MAIN) then
                    counter <= counter + 1;
                end if;
            end if;

            
            
        end if;
    end process;

    -- PROCESSO 2: Lógica Combinacional (Próximo Estado)
  
    process(current_state, sensor1, sensor2, botao, counter)
    begin
        -- Valor padrão para evitar latch
        next_state <= current_state;

        case current_state is
            
            
            when ST_RedRed =>
                if sensor1 = '1' then
                    next_state <= ST_GreenRed; -- Ativa via principal
                elsif (sensor2 = '1' or botao = '1') then
                    next_state <= ST_RedGreen; -- Ativa via secundária/pedestre
                else
                    next_state <= ST_RedRed;   -- Permanece em espera
                end if;

            -- Estado 1: Principal Verde
            when ST_GreenRed =>
               
                if counter >= (TIME_GREEN_MAIN * CLK_FREQ) then 
                    next_state <= ST_YellowRed;
                end if;

            -- Estado 2: Principal Amarelo
            when ST_YellowRed =>
                if counter >= (TIME_YELLOW * CLK_FREQ) then
                  
                    next_state <= ST_RedRed; 
                end if;

            -- Estado 4: Secundária Verde
            when ST_RedGreen =>
                if counter >= (TIME_GREEN_SIDE * CLK_FREQ) then
                    next_state <= ST_RedYellow;
                end if;
                 
            -- Estado 5: Secundária Amarelo
            when ST_RedYellow =>
                if counter >= (TIME_YELLOW * CLK_FREQ) then
                    
                    next_state <= ST_RedRed;
                end if;
                
            when others =>
              
                next_state <= ST_RedRed;
        end case;
    end process;

    -- PROCESSO 3: Lógica de Saída (Outputs)
    -- As saídas (luzes) dependem apenas do estado atual,
    -- e o significado dos estados não mudou.
    process(current_state)
    begin
        case current_state is
            when ST_GreenRed =>
                luzes_principais  <= GREEN;
                luzes_secundarias <= RED;
                
            when ST_YellowRed =>
                luzes_principais  <= YELLOW;
                luzes_secundarias <= RED;
                
            when ST_RedRed =>
                luzes_principais  <= RED;
                luzes_secundarias <= RED;
                
            when ST_RedGreen =>
                luzes_principais  <= RED;
                luzes_secundarias <= GREEN;
                
            when ST_RedYellow =>
                luzes_principais  <= RED;
                luzes_secundarias <= YELLOW;
                
            when others =>
                luzes_principais  <= RED;
                luzes_secundarias <= RED;
        end case;
    end process;

end Behavioral;

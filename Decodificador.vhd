--Decodificador com instrucao case para converter o estado_atual (vindo da controladora) nos 6 sinais de LED referentes aos semaforos.

--Alunos:
-- Aurora Cristina Bombassaro,
--Gustavo de Oliveira Cardoso Rezende, 
--Gustavo Loureiro Muller Netto.

library IEEE;
use IEEE.std_logic_1164.all;

entity Decoder is
    port (
    	-- Entrada: O estado atual vindo da Controladora (FSM)
        -- (Usamos 3 bits para representar os 6 estados do PDF)
        estado_in  : in  std_logic_vector(2 downto 0);
        
        -- Saidas para os LEDs da Via Principal
        p_red     : out STD_LOGIC;
        p_yellow  : out STD_LOGIC;
        p_green   : out STD_LOGIC;
        
        -- Saidas para os LEDs da Via Secundária
        s_red     : out STD_LOGIC;
        s_yellow  : out STD_LOGIC;
        s_green   : out STD_LOGIC
    );
end entity decoder;

architecture Behavioral of Decoder is
begin
    decoder_proc: process(estado_in)
    begin
    	--Definir valores padrão para evitar latches
        p_red <= '0';
        p_yellow <= '0';
        p_green <= '0';
        s_red <= '0';
        s_yellow <= '0';
        s_green <= '0';
       
        case estado_in is
        	--Principal Verde, Secundária Vermelha
            when "000" => 
            	p_green <= '1'; 
                s_red <= '1';
            --Principal Amarelo, Secundário Vermelho
            when "001" => 
            	p_yellow <= '1'; 
                s_red <= '1';
            --Principal Vermelho, Secundário Vermelho
            when "010" => 
            	p_red <= '1'; 
                s_red <= '1';
            --Principal Vermelho, Secundário Verde
            when "011" => 
            	p_red <= '1'; 
                s_green <= '1';
            --Principal Vermelho, Secundário Amarelo 
            when "100" => 
            	p_red <= '1'; 
                s_yellow <= '1';
            --Principal Vermelho, Secundário Vermelho
            when "101" => 
            	p_red <= '1'; 
                s_red <= '1';       
                         
            -- Estados não utilizados ("110", "111")
            -- Por segurança, se a FSM entrar em um estado inválido,
            when others =>
                p_red <= '1';
                s_red <= '1';
        end case;
    end process decoder_proc;
end architecture Behavioral;

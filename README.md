<h1>Controlador de Semáforo Inteligente em VHDL</h1>

<p>
    Este repositório contém o código fonte VHDL e os arquivos de simulação para um 
    Controlador de Semáforo Inteligente, desenvolvido como projeto final da disciplina de 
    Laboratório de Sistemas Digitais por alunos do Curso Engenharia de Sistemas da UFMG.   
</p>

<p>  O sistema controla o fluxo de trânsito em um cruzamento entre uma via principal e uma via secundária, com suporte para pedestres.
</p>

<hr>

<h2> Sobre o Projeto</h2>

<p>
    O objetivo foi criar um sistema digital robusto capaz de gerenciar o tráfego de forma eficiente e segura. 
    O sistema opera com base em sensores de presença nas vias e um botão de solicitação de travessia para pedestres.
    O design foi implementado visando síntese em FPGA (Field Programmable Gate Array).
</p>

<h2>Funcionalidades</h2>

<ul>
    <li>
        <b>Metodologia RTL (Register Transfer Level):</b> O projeto foi estruturado separando claramente 
        a lógica de controle ("Cérebro") do caminho de dados ("Músculos").
        <ul>
            <li><b>Controladora (FSM):</b> Gerencia os estados e decisões de prioridade.</li>
            <li><b>Datapath:</b> Gerencia temporizadores (contadores), comparadores e decodificação de saída (LEDs).</li>
        </ul>
    </li>
    <li>
        <b>Prevenção de Inanição (Starvation):</b> Implementação de uma lógica de alternância justa (<i>Round-Robin</i>). 
        Um bit de memória registra qual via teve o sinal verde por último. Em cenários de tráfego intenso 
        (ambos os sensores ativos), o sistema alterna obrigatoriamente entre a via principal e a secundária, 
        garantindo que ninguém fique preso no sinal vermelho indefinidamente.
    </li>
    <li>
        <b>Parametrização (Generics):</b> O código utiliza <code>GENERIC</code> para definir a frequência do clock 
        e os tempos de abertura do semáforo, facilitando a adaptação para diferentes placas FPGA.
    </li>
</ul>

<h2> Arquitetura do Sistema</h2>

<h3>Máquina de Estados (FSM)</h3>
<p>O controlador opera com 5 estados principais:</p>
<ol>
    <li><b>ST_RedRed:</b> Estado de repouso (Vermelho para todos). Espera por sensores ou botão.</li>
    <li><b>ST_GreenRed:</b> Via Principal Verde (15s).</li>
    <li><b>ST_YellowRed:</b> Via Principal Amarela (3s).</li>
    <li><b>ST_RedGreen:</b> Via Secundária/Pedestre Verde (10s).</li>
    <li><b>ST_RedYellow:</b> Via Secundária Amarela (3s).</li>
</ol>

<h2> Tecnologias Utilizadas</h2>

<ul>
    <li><b>Linguagem:</b> VHDL (IEEE 1076)</li>
    <li><b>Simulação:</b> GHDL / EDA Playground</li>
    <li><b>Visualização de Ondas:</b> GTKWave / EPWave</li>
</ul>

<h2> Autores</h2>

<p>
    Projeto desenvolvido por:
</p>
<ul>
    <li>Aurora Cristina Bombassaro</li>
    <li>Gustavo de Oliveira Cardoso Rezende</li>
    <li>Gustavo Loureiro Muller Netto</li>
</ul>

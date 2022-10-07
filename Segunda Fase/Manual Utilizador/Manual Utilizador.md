# Manual de Utilizador

## **Projeto de Inteligência Artificial**

### **Blokus Uno - Segunda Fase**



**Autores:** 

Tiago Farinha (201802235)

 Francisco Moura (201802033)



**Docente:**

Eng. Filipe Mariano




## Índice do Manual

- [Introdução](#Introdução)
- [Características do Jogo](#Características)
    - [Peças](#Peças)
    - [Tabuleiro](#Tabuleiro) 
    - [Regras do Jogo](#Regras do Jogo)
- [Execução](#Execução)
- [Estatísticas](#Estatísticas)

## Introdução

Este Manual de Utilizador tem como objetivo mostrar ao *end user* como utilizar o nosso programa para resolver o problema do Blokus Uno.



## Características

### Peças
O jogo tem 4 peças disponíveis:

A - Quadrado 1x1  ![](C:\IA - Projeto 2\Manual Utilizador\A.png)



B - Quadrado 2x2  ![](C:\IA - Projeto 2\Manual Utilizador\B.png)



C-1 - S variação 1  ![](C:\IA - Projeto 2\Manual Utilizador\S 1.png)



C-2 - S variação 2   ![](C:\IA - Projeto 2\Manual Utilizador\S 2.png)



### Tabuleiro

Existe apenas 1 tabuleiro disponível (vazio):
```
(0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
(0 0 0 0 0 0 0 0 0 0 0 0 0 0) 
```



### Regras do Jogo

- O jogo é disputado entre 2 jogadores.
- Existem 35 peças de três tipos para cada jogador.
- O tabuleiro tem apenas 14 linhas por 14 colunas, sem existência de tabuleiros pré-preenchidos.
- Os jogadores escolhem uma das suas peças e colocam-nas de modo a que um dos quadrados da peça cubra um dos quadrados de canto do tabuleiro de jogo (posição inicial), sendo que o Jogador 1 deverá iniciar no canto superior esquerdo e o Jogador 2 no canto inferior direito.
- Uma vez colocada, a posição da peça não poderá ser alterada até ao final do jogo.
- As jogadas são feitas à vez e, em cada turno, o jogador coloca uma peça de modo a que toque pelo menos numa das suas peças já existente, mas apenas nos cantos. Peças do mesmo jogador nunca se podem tocar nas laterais, mas podem tocar lateralmente com peças do outro jogador.
- Quando um dos jogadores não consegue colocar uma peça no tabuleiro de jogo, deverá passar a vez.
- O jogo termina quando nenhum dos jogadores consegue colocar mais peças.
- Quando o jogo termina, os jogadores contam o número de quadrados existentes nas peças que restaram, e o jogador que tiver o menor número de quadrados é o vencedor.



## Execução 

O programa inicia-se com o comando **(iniciar)**:

![](C:\IA - Projeto 2\Manual Utilizador\Menu 1.png)



Quando introduzida a opção 1 ou 2 (**1 - Humano vs IA** ou **2 - IA vs IA**), o utilizador será levado para a página do limite de tempo:

![](C:\IA - Projeto 2\Manual Utilizador\Menu 2.png)



Caso escolha a opção 1, depois de escolher um limite de tempo (entre 1000 e 20000 milésimos de segundo), será levado para a escolha do primeiro a jogar:

![](C:\IA - Projeto 2\Manual Utilizador\Menu 3.png)



Caso esteja no modo de jogo *Humano vs IA* terá de introduzir uma jogada no formato **peça linha coluna**. Tem um exemplo em baixo:

![](C:\IA - Projeto 2\Manual Utilizador\Jogada.png)



Caso tenha dúvidas sobre o ID de uma peça (nome que deverá colocar na primeira posição), queira referir-se à seguinte imagem:

![](C:\IA - Projeto 2\Manual Utilizador\peças.png)



A linha e coluna têm de ser números entre 0 e 13 (inclusive), representando as coordenadas onde a peça irá ser colocada.



## Estatísticas

Depois de executados os algoritmos, são guardadas as estatísticas desses no caminho *C:\IA - Projeto 2\log.dat*

<img src="C:\IA - Projeto 2\Manual Utilizador\Estatisticas.png" style="zoom:90%;" />

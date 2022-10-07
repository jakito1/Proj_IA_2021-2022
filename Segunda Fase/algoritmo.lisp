;;;; procura.lisp
;;;; IA - Projeto #2
;;;; Autor: Tiago Farinha (201802235), Francisco Moura (201802033)

;;;; NOTA (IMPORTANTE!!!): P�R A PASTA NA RAIZ DO C: PARA CONSEGUIR L�R O FICHEIRO

; _________________________________________
;|                                         |
;|  ALGORITMO NEGAMAX COM CORTES ALFABETA  |
;|_________________________________________|


(defun negamaxAlfaBeta(no prof alfa beta jogador endTime &aux (bestValue most-negative-fixnum))
"Implementa��o do Algoritmo Negamax com cortes."
  (let ((filhosOrdenados (sortNodes (nos-possiveis-todas-pecas no jogador))))
    (setf *nrSucessoresECortes* (list (+ (list-length filhosOrdenados) (first *nrSucessoresECortes*)) (second *nrSucessoresECortes*)))
    (if  (or (equal prof 0) (= (list-length filhosOrdenados) 0) (> (get-internal-real-time) endTime)) 
      (progn (setf *jogada* (list (first (second (solucaoProblema no))) (fourth (second (solucaoProblema no))) (fifth (second (solucaoProblema no)))))
             (return-from negamaxAlfaBeta (no-heuristica no))
      )
        
       (progn 
          (mapcar #'(lambda (atual)
                      (if (equal jogador 1)
                         (setf bestValue (max bestValue (- (negamaxAlfaBeta atual (1- prof) (- beta) (- alfa) 2 endTime))))
                         (setf bestValue (max bestValue (- (negamaxAlfaBeta atual (1- prof) (- beta) (- alfa) 1 endTime))))
                      )
                      (setf alfa (max alfa bestValue))
                      (if (>= alfa beta) 
                        (progn (setf *nrSucessoresECortes* (list (first *nrSucessoresECortes*) (+ (list-length filhosOrdenados) (second *nrSucessoresECortes*))))
                        (return-from negamaxAlfaBeta alfa))
                      )
                    ) 
           filhosOrdenados)            
          
         bestValue
        )
       )
   )
)

(defun sortNodes (nodesList)
"Ordena uma lista de n�s"
      (sort nodesList #'> :key #'sixth)
)

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; ___________
;|           |
;|  SOLU��O  |
;|___________|


(defun solucaoProblema (noSolucao)
"Fun��o que retorna a lista do caminho da solu��o."
  (cond 
   ((equal (no-pai noSolucao) nil) (list noSolucao))
   (t (append (solucaoProblema (no-pai noSolucao)) (list noSolucao)))
  )
)


(defun calcular-pontos-jogador (pecasJogador)
"Calcula a pontua��o final de um jogador (numero de pe�as vezes o seu valor)"
    (+ (first pecasJogador) (* (+ (second pecasJogador) (third pecasJogador)) 4))
)


;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; ______________________________________
;|                                      |
;|  N�S E INTERA��ES COM OS ALGORITMOS  |
;|______________________________________|


(defun cria-no (tray nrPecasJ1 nrPecasJ2 &optional (prof 0) (pai nil) (heuristica nil))
"Cria a estrutura do n�"
  (list tray prof pai nrPecasJ1 nrPecasJ2 heuristica) 
)

(defun no-estado (no)
"Devolve o tabuleiro atual"
  (first no)
)

(defun no-profundidade (no)
"Devolve o n�vel de profundidade no grafo"
  (second no)
)

(defun no-pai (no)
"Devolve o pai do n� atual"
  (third no)
)

(defun nr-pecasJ1 (no)
"Devolve a lista com a quantidade de pe�as"
  (fourth no)
)

(defun nr-pecasJ2 (no)
"Devolve a lista com a quantidade de pe�as"
  (fifth no)
)

(defun no-heuristica (no)
"Devolve a lista com a quantidade de pe�as"
  (sixth no)
)

(defun no-solucaop (no jogador)
"Fun��o que retorna t se o n� recebido por par�metro � n� solu��o. Nil caso contr�rio."
  (if (equal (length (nos-possiveis-todas-pecas no jogador)) 0) t nil)
)

(defun nos-possiveis-todas-pecas (no jogador)
"Devolve todos os n�s sucessores de n�"
  (append (nos-posicoes-possiveis no 'peca-a jogador) (nos-posicoes-possiveis no 'peca-b jogador) (nos-posicoes-possiveis no 'peca-c-1 jogador) (nos-posicoes-possiveis no 'peca-c-2 jogador))
)

(defun nos-posicoes-possiveis(no peca jogador)
"Fun��o que verifica e coloca as jogadas poss�veis (em n�s - (cria-no no)) numa lista a ser usada, mais tarde, nos algoritmos."
        (if (equal jogador 1) 
          (if (> (cond  
                ((equal peca 'peca-a) (first (nr-pecasJ1 no))) 
                ((equal peca 'peca-b) (second (nr-pecasJ1 no))) 
                ((or (equal peca 'peca-c-1) (equal peca 'peca-c-2)) (third (nr-pecasJ1 no)))) 0) 
            
		(mapcar #'(lambda(sucessorAtual) 
                                (cria-no sucessorAtual (decrementar-nr-pecas peca (nr-pecasJ1 no)) (nr-pecasJ2 no) (1+ (no-profundidade no)) no (avaliar-no (list (decrementar-nr-pecas peca (nr-pecasJ1 no)) (nr-PecasJ2 no)) jogador))
                          )                                                          
                 (mapcar #'(lambda(coordAtual) 
                             (verificar-peca-encaixa-e-colocar  (first coordAtual) (second coordAtual) peca (no-estado no) jogador))              
                      (sucessores (no-estado no) 0 0 peca jogador) 
		 )) 
          nil) 
         (if (> (cond  
                ((equal peca 'peca-a) (first (nr-pecasJ2 no))) 
                ((equal peca 'peca-b) (second (nr-pecasJ2 no))) 
                ((or (equal peca 'peca-c-1) (equal peca 'peca-c-2)) (third (nr-pecasJ2 no)))) 0) 
            
		(mapcar #'(lambda(sucessorAtual) 
                                (cria-no sucessorAtual (nr-pecasJ1 no) (decrementar-nr-pecas peca (nr-pecasJ2 no)) (1+ (no-profundidade no)) no (avaliar-no (list (nr-PecasJ1 no) (decrementar-nr-pecas peca (nr-pecasJ2 no))) jogador))
                           )
                 (mapcar #'(lambda(coordAtual) 
                             (verificar-peca-encaixa-e-colocar  (first coordAtual) (second coordAtual) peca (no-estado no) jogador))  
                     (sucessores (no-estado no) 0 0 peca jogador)           
		)) 
          nil) 
       ) 
) 

(defun sucessores (tray line row peca jogador &optional (listaSucessores '())) 
"Devolve a lista de sucessores de um n�" 
  (if (equal (verificar-dentro-dos-limites line row) nil)  
      (reverse listaSucessores) 
      (if (equal (verificar-peca-encaixa line row peca tray jogador) t)  
          (if (> row 12) (sucessores tray (1+ line) 0 peca jogador (append (list (list line row)) listaSucessores )) (sucessores tray line (1+ row) peca jogador (append (list (list line row)) listaSucessores))) 
          (if (> row 12) (sucessores tray (1+ line) 0 peca jogador listaSucessores) (sucessores tray line (1+ row) peca jogador listaSucessores)) 
      )
  ) 
) 

(defun decrementar-nr-pecas (peca nrPecas) 
"Decrementa o numero de uma pe�a"
      (cond 
       ((equal peca 'peca-a) (list (1- (first nrPecas)) (second nrPecas) (third nrPecas)))
       ((equal peca 'peca-b) (list (first nrPecas) (1- (second nrPecas)) (third nrPecas)))
       ((or (equal peca 'peca-c-1) (equal peca 'peca-c-2)) (list (first nrPecas) (second nrPecas) (1- (third nrPecas))))
      )
)

(defun avaliar-no (l jogador)
"Fun��o Heur�stica"
  (if (equal jogador 1)
    (- (+ (first (first l)) (* (+ (second (first l)) (third (first l))) 4)) (+ (first (second l)) (* (+ (second (second l)) (third (second l))) 4)))
    (- (+ (first (second l)) (* (+ (second (second l)) (third (second l))) 4)) (+ (first (first l)) (* (+ (second (first l)) (third (first l))) 4)))
  )
)

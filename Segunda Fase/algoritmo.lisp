;;;; procura.lisp
;;;; IA - Projeto #2
;;;; Autor: Tiago Farinha (201802235), Francisco Moura (201802033)

;;;; NOTA (IMPORTANTE!!!): PÔR A PASTA NA RAIZ DO C: PARA CONSEGUIR LÊR O FICHEIRO

; _________________________________________
;|                                         |
;|  ALGORITMO NEGAMAX COM CORTES ALFABETA  |
;|_________________________________________|


(defun negamaxAlfaBeta(no prof alfa beta jogador endTime &aux (bestValue most-negative-fixnum))
"Implementação do Algoritmo Negamax com cortes."
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
"Ordena uma lista de nós"
      (sort nodesList #'> :key #'sixth)
)

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; ___________
;|           |
;|  SOLUÇÃO  |
;|___________|


(defun solucaoProblema (noSolucao)
"Função que retorna a lista do caminho da solução."
  (cond 
   ((equal (no-pai noSolucao) nil) (list noSolucao))
   (t (append (solucaoProblema (no-pai noSolucao)) (list noSolucao)))
  )
)


(defun calcular-pontos-jogador (pecasJogador)
"Calcula a pontuação final de um jogador (numero de peças vezes o seu valor)"
    (+ (first pecasJogador) (* (+ (second pecasJogador) (third pecasJogador)) 4))
)


;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; ______________________________________
;|                                      |
;|  NÓS E INTERAÇÕES COM OS ALGORITMOS  |
;|______________________________________|


(defun cria-no (tray nrPecasJ1 nrPecasJ2 &optional (prof 0) (pai nil) (heuristica nil))
"Cria a estrutura do nó"
  (list tray prof pai nrPecasJ1 nrPecasJ2 heuristica) 
)

(defun no-estado (no)
"Devolve o tabuleiro atual"
  (first no)
)

(defun no-profundidade (no)
"Devolve o nível de profundidade no grafo"
  (second no)
)

(defun no-pai (no)
"Devolve o pai do nó atual"
  (third no)
)

(defun nr-pecasJ1 (no)
"Devolve a lista com a quantidade de peças"
  (fourth no)
)

(defun nr-pecasJ2 (no)
"Devolve a lista com a quantidade de peças"
  (fifth no)
)

(defun no-heuristica (no)
"Devolve a lista com a quantidade de peças"
  (sixth no)
)

(defun no-solucaop (no jogador)
"Função que retorna t se o nó recebido por parâmetro é nó solução. Nil caso contrário."
  (if (equal (length (nos-possiveis-todas-pecas no jogador)) 0) t nil)
)

(defun nos-possiveis-todas-pecas (no jogador)
"Devolve todos os nós sucessores de nó"
  (append (nos-posicoes-possiveis no 'peca-a jogador) (nos-posicoes-possiveis no 'peca-b jogador) (nos-posicoes-possiveis no 'peca-c-1 jogador) (nos-posicoes-possiveis no 'peca-c-2 jogador))
)

(defun nos-posicoes-possiveis(no peca jogador)
"Função que verifica e coloca as jogadas possíveis (em nós - (cria-no no)) numa lista a ser usada, mais tarde, nos algoritmos."
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
"Devolve a lista de sucessores de um nó" 
  (if (equal (verificar-dentro-dos-limites line row) nil)  
      (reverse listaSucessores) 
      (if (equal (verificar-peca-encaixa line row peca tray jogador) t)  
          (if (> row 12) (sucessores tray (1+ line) 0 peca jogador (append (list (list line row)) listaSucessores )) (sucessores tray line (1+ row) peca jogador (append (list (list line row)) listaSucessores))) 
          (if (> row 12) (sucessores tray (1+ line) 0 peca jogador listaSucessores) (sucessores tray line (1+ row) peca jogador listaSucessores)) 
      )
  ) 
) 

(defun decrementar-nr-pecas (peca nrPecas) 
"Decrementa o numero de uma peça"
      (cond 
       ((equal peca 'peca-a) (list (1- (first nrPecas)) (second nrPecas) (third nrPecas)))
       ((equal peca 'peca-b) (list (first nrPecas) (1- (second nrPecas)) (third nrPecas)))
       ((or (equal peca 'peca-c-1) (equal peca 'peca-c-2)) (list (first nrPecas) (second nrPecas) (1- (third nrPecas))))
      )
)

(defun avaliar-no (l jogador)
"Função Heurística"
  (if (equal jogador 1)
    (- (+ (first (first l)) (* (+ (second (first l)) (third (first l))) 4)) (+ (first (second l)) (* (+ (second (second l)) (third (second l))) 4)))
    (- (+ (first (second l)) (* (+ (second (second l)) (third (second l))) 4)) (+ (first (first l)) (* (+ (second (first l)) (third (first l))) 4)))
  )
)

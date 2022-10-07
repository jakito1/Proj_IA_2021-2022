;;;; puzzle.lisp
;;;; IA - Projeto #2
;;;; Autor: Tiago Farinha (201802235), Francisco Moura (201802033)

;;;; NOTA (IMPORTANTE!!!): P�R A PASTA NA RAIZ DO C: PARA CONSEGUIR L�R O FICHEIRO

(defun tabuleiro-vazio (&optional (dimensao 14))
  "Retorna um tabuleiro 14x14 (default) com as casas vazias"
	(make-list dimensao :initial-element (make-list dimensao :initial-element '0))
)

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------

; | SELETORES |


(defun linha (index tray)
  "Fun��o que recebe um �ndice e o tabuleiro e retorna uma lista que representa essa linha do tabuleiro"
  (nth index tray)
)


(defun coluna (index tray)
  "Fun��o que recebe um �ndice e o tabuleiro e retorna uma lista que representa essa coluna do tabuleiro."
  (mapcar #'(lambda (curr) (nth index curr)) tray)
)


(defun celula (line row tray)
  "Fun��o que recebe dois �ndices (linha e coluna) e o tabuleiro e retorna o valor presente nessa calcula do tabuleiro."
  (if (equal (verificar-dentro-dos-limites line row) t)
      (nth row (nth line tray))
  )
)


(defun casa-vaziap (line row tray)
  "Fun��o que recebe dois �ndices e o tabuleiro e verifica se a casa correspondente a essa posi��o se encontra vazia, ou seja, igual a 0."
  (if (equal (celula line row tray) 0)
      T NIL
  ) 
)

(defun verifica-casas-vazias (tray positions)
  "Fun��o que recebe o tabuleiro e uma lista de pares de �ndices linha e coluna e devolve uma lista com T ou NIL caso se encontrem vazias."
  (mapcar #'(lambda (curr) 
              (if (equal (casa-vaziap (first curr) (second curr) tray) T) T NIL)
            ) positions)
)

(defun substituir-posicao (row lineList jogador)
  "Fun��o que recebe um �ndice, uma lista e um valor (por default o valor � 1) e substitui pelo valor pretendido nessa posi��o"
  (let ((currPos 0))
    (mapcar #'(lambda (curr)          
                (if (and (= row currPos) (= curr 0)) (progn (setf currPos (1+ currPos)) jogador) 
                                    (progn (setf currPos (1+ currPos)) curr)
                )
              )
   lineList)
  )
)

(defun substituir (line row tray jogador)
  "Fun��o que recebe 2 �ndices, o tabuleiro e um valor (por default = 1) e retorna o tabuleiro com a substitui��o pelo valor pretendido."
  (let ((currLine 0))
        (mapcar #'(lambda (curr)          
                (if (= line currLine) (progn (setf currLine (1+ currLine)) (substituir-posicao row (linha line tray) jogador)) 
                                      (progn (setf currLine (1+ currLine)) curr)
                )
              )
         tray)       
  )
)


;----------------------------------------------------------------------------------------------------------------------------------------------------------------------



; | OPERDADORES |



(defun peca-casas-ocupadas (line row piece)
"Fun��o que recebe dois �ndices e um tipo de pe�a (peca-a, peca-b, peca-c-1 ou peca-c-2) e retorna uma lista com os pares de �ndices correspondentes �s posi��es em que ir� ser colocada a pe�a."
  (cond
     ((equal piece 'peca-a) (list (list line row)))
     ((equal piece 'peca-b) (list (list line row) (list line (1+ row)) (list (1+ line) row) (list (1+ line) (1+ row))))
     ((equal piece 'peca-c-1) (list (list line row) (list line (1+ row)) (list (1- line) (1+ row)) (list (1- line) (+ row 2))))
     ((equal piece 'peca-c-2) (list (list line row) (list (1+ line) row) (list (1+ line) (1+ row)) (list (+ line 2) (1+ row))))
  )
)


(defun peca-a (line row tray jogador)
  "Fun��o que recebe dois �ndices e o tabuleiro e coloca um quadrado de 1x1 no tabuleiro"
  (substituir line row tray jogador)
)


(defun peca-b (line row tray jogador)
  "Fun��o que recebe dois �ndices e o tabuleiro e coloca o quadrado 2x2 no tabuleiro tendo como ponto de refer�ncia o �ndice passado como argumento."
  (progn (substituir (1+ line) (1+ row) (substituir (1+ line) row (substituir line (1+ row) (substituir line row tray jogador) jogador) jogador) jogador)
  )  
)

(defun peca-c-1 (line row tray jogador)
  "Fun��o que recebe dois �ndices e o tabuleiro e coloca a pe�a 'esse' na posi��o de lado no tabuleiro tendo como ponto de refer�ncia o �ndice passado como argumento."
  (progn (substituir (1- line) (+ row 2) (substituir (1- line) (1+ row) (substituir line (1+ row) (substituir line row tray jogador) jogador) jogador) jogador)
  )
)  


(defun peca-c-2 (line row tray jogador)
  "Fun��o que recebe dois �ndices e o tabuleiro e coloca a pe�a 'esse' na posi��o para cima no tabuleiro tendo como ponto de refer�ncia o �ndice passado como argumento."
  (progn (substituir (+ line 2) (1+ row) (substituir (1+ line) (1+ row) (substituir (1+ line) row (substituir line row tray jogador) jogador) jogador) jogador)   
    )   
)

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; | VERIFICA��O E COLOCA��O DAS PE�AS NO TABULEIRO |

(defun colocar-peca(peca line row tray jogador)
"Fun��o que chama uma das fun��es de coloca��o de uma pe�a"
  (cond
   ((equal peca 'peca-a) (peca-a line row tray jogador))
   ((equal peca 'peca-b) (peca-b line row tray jogador))
   ((equal peca 'peca-c-1) (peca-c-1 line row tray jogador))
   ((equal peca 'peca-c-2) (peca-c-2 line row tray jogador))
  )
)

(defun verificar-peca-encaixa-e-colocar (line row peca tray jogador)
"Fun��o que coloca a pe�a no tabuleiro, verificando se estas podem ser inseridas. Se todas as valida��es forem positivas, adicionar pe�a ao tabuleiro. NIL caso contr�rio."
    (if (equal (verificar-peca-encaixa line row peca tray jogador) nil)
        nil
        (colocar-peca peca line row tray jogador)
    )
)

(defun verificar-peca-encaixa (line row peca tray jogador)
"Fun��o que coloca a pe�a no tabuleiro, verificando se estas podem ser inseridas. Se todas as valida��es forem positivas, adicionar pe�a ao tabuleiro. NIL caso contr�rio."
  (let ((piece (peca-casas-ocupadas line row peca)))
    (if (not (member nil (mapcar #'(lambda (atual)
                (if 
                  (and  
                        (not (equal (celula (first atual) (1- (second atual)) tray) jogador))  
                        (not (equal (celula (first atual) (1+ (second atual)) tray) jogador))
                        (not (equal (celula (1- (first atual)) (second atual) tray) jogador))
                        (not (equal (celula (1+ (first atual)) (second atual) tray) jogador))
                        (verificar-dentro-dos-limites (first atual)(second atual))
                        (casa-vaziap (first atual) (second atual) tray))
                  t nil
                )
              )piece)))
        (if (or (member t (mapcar #'(lambda (atual)
                (if 
                  (and  
                        (or (equal (celula (1- (first atual)) (1- (second atual)) tray) jogador)
                            (equal (celula (1+ (first atual)) (1- (second atual)) tray) jogador)
                            (equal (celula (1- (first atual)) (1+ (second atual)) tray) jogador)
                            (equal (celula (1+ (first atual)) (1+ (second atual)) tray) jogador)        
                        )
                   )
                   t nil
                )
                ) piece))
      (member t (mapcar #'(lambda (atual)
                            (if (or (and (equal (first atual) 0) (equal (second atual) 0) (equal jogador 1)) (and (equal (first atual) 13) (equal (second atual) 13) (equal jogador 2))) 
                              t
                            )
              ) piece)))
            t
)
     )
  )
)

(defun verificar-dentro-dos-limites (line row)
"Verifica se alguma das coordenada de uma calccula est� fora do tabuleiro. T se todas estiverem dentro do tabuleir, NIL caso contr�rio."
  (if (and (numberp line) (numberp row))
      (if
          (and (>= line 0) 
               (<= line 13) 
               (>= row 0) 
               (<= row 13)) t nil
       )
  )
)

(defun validar-peca-jogador-humano (peca)
"Verifica se o jogador tem pe�as suficientes para jogar"
  (cond 
   ((equal peca 'peca-a) (if (<= (first (second *jogada*)) 0) nil t))
   ((equal peca 'peca-b) (if (<= (second (second *jogada*)) 0) nil t))
   ((or (equal peca 'peca-c-1) (equal peca 'peca-c-2)) (if (<= (third (second *jogada*)) 0) nil t))
  )
)
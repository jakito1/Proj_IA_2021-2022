;;;; puzzle.lisp
;;;; IA - Projeto #2
;;;; Autor: Tiago Farinha (201802235), Francisco Moura (201802033)

;;;; NOTA (IMPORTANTE!!!): PÔR A PASTA NA RAIZ DO C: PARA CONSEGUIR LÊR O FICHEIRO

(defun tabuleiro-vazio (&optional (dimensao 14))
  "Retorna um tabuleiro 14x14 (default) com as casas vazias"
	(make-list dimensao :initial-element (make-list dimensao :initial-element '0))
)

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------

; | SELETORES |


(defun linha (index tray)
  "Função que recebe um Índice e o tabuleiro e retorna uma lista que representa essa linha do tabuleiro"
  (nth index tray)
)


(defun coluna (index tray)
  "Função que recebe um índice e o tabuleiro e retorna uma lista que representa essa coluna do tabuleiro."
  (mapcar #'(lambda (curr) (nth index curr)) tray)
)


(defun celula (line row tray)
  "Função que recebe dois índices (linha e coluna) e o tabuleiro e retorna o valor presente nessa calcula do tabuleiro."
  (if (equal (verificar-dentro-dos-limites line row) t)
      (nth row (nth line tray))
  )
)


(defun casa-vaziap (line row tray)
  "Função que recebe dois índices e o tabuleiro e verifica se a casa correspondente a essa posição se encontra vazia, ou seja, igual a 0."
  (if (equal (celula line row tray) 0)
      T NIL
  ) 
)

(defun verifica-casas-vazias (tray positions)
  "Função que recebe o tabuleiro e uma lista de pares de índices linha e coluna e devolve uma lista com T ou NIL caso se encontrem vazias."
  (mapcar #'(lambda (curr) 
              (if (equal (casa-vaziap (first curr) (second curr) tray) T) T NIL)
            ) positions)
)

(defun substituir-posicao (row lineList jogador)
  "Função que recebe um índice, uma lista e um valor (por default o valor é 1) e substitui pelo valor pretendido nessa posição"
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
  "Função que recebe 2 índices, o tabuleiro e um valor (por default = 1) e retorna o tabuleiro com a substituição pelo valor pretendido."
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
"Função que recebe dois índices e um tipo de peça (peca-a, peca-b, peca-c-1 ou peca-c-2) e retorna uma lista com os pares de índices correspondentes às posições em que irá ser colocada a peça."
  (cond
     ((equal piece 'peca-a) (list (list line row)))
     ((equal piece 'peca-b) (list (list line row) (list line (1+ row)) (list (1+ line) row) (list (1+ line) (1+ row))))
     ((equal piece 'peca-c-1) (list (list line row) (list line (1+ row)) (list (1- line) (1+ row)) (list (1- line) (+ row 2))))
     ((equal piece 'peca-c-2) (list (list line row) (list (1+ line) row) (list (1+ line) (1+ row)) (list (+ line 2) (1+ row))))
  )
)


(defun peca-a (line row tray jogador)
  "Função que recebe dois índices e o tabuleiro e coloca um quadrado de 1x1 no tabuleiro"
  (substituir line row tray jogador)
)


(defun peca-b (line row tray jogador)
  "Função que recebe dois índices e o tabuleiro e coloca o quadrado 2x2 no tabuleiro tendo como ponto de referência o índice passado como argumento."
  (progn (substituir (1+ line) (1+ row) (substituir (1+ line) row (substituir line (1+ row) (substituir line row tray jogador) jogador) jogador) jogador)
  )  
)

(defun peca-c-1 (line row tray jogador)
  "Função que recebe dois índices e o tabuleiro e coloca a peça 'esse' na posição de lado no tabuleiro tendo como ponto de referência o índice passado como argumento."
  (progn (substituir (1- line) (+ row 2) (substituir (1- line) (1+ row) (substituir line (1+ row) (substituir line row tray jogador) jogador) jogador) jogador)
  )
)  


(defun peca-c-2 (line row tray jogador)
  "Função que recebe dois índices e o tabuleiro e coloca a peça 'esse' na posição para cima no tabuleiro tendo como ponto de referência o índice passado como argumento."
  (progn (substituir (+ line 2) (1+ row) (substituir (1+ line) (1+ row) (substituir (1+ line) row (substituir line row tray jogador) jogador) jogador) jogador)   
    )   
)

;----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; | VERIFICAÇÃO E COLOCAÇÃO DAS PEÇAS NO TABULEIRO |

(defun colocar-peca(peca line row tray jogador)
"Função que chama uma das funções de colocação de uma peça"
  (cond
   ((equal peca 'peca-a) (peca-a line row tray jogador))
   ((equal peca 'peca-b) (peca-b line row tray jogador))
   ((equal peca 'peca-c-1) (peca-c-1 line row tray jogador))
   ((equal peca 'peca-c-2) (peca-c-2 line row tray jogador))
  )
)

(defun verificar-peca-encaixa-e-colocar (line row peca tray jogador)
"Função que coloca a peça no tabuleiro, verificando se estas podem ser inseridas. Se todas as validações forem positivas, adicionar peça ao tabuleiro. NIL caso contrário."
    (if (equal (verificar-peca-encaixa line row peca tray jogador) nil)
        nil
        (colocar-peca peca line row tray jogador)
    )
)

(defun verificar-peca-encaixa (line row peca tray jogador)
"Função que coloca a peça no tabuleiro, verificando se estas podem ser inseridas. Se todas as validações forem positivas, adicionar peça ao tabuleiro. NIL caso contrário."
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
"Verifica se alguma das coordenada de uma calccula está fora do tabuleiro. T se todas estiverem dentro do tabuleir, NIL caso contrário."
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
"Verifica se o jogador tem peças suficientes para jogar"
  (cond 
   ((equal peca 'peca-a) (if (<= (first (second *jogada*)) 0) nil t))
   ((equal peca 'peca-b) (if (<= (second (second *jogada*)) 0) nil t))
   ((or (equal peca 'peca-c-1) (equal peca 'peca-c-2)) (if (<= (third (second *jogada*)) 0) nil t))
  )
)
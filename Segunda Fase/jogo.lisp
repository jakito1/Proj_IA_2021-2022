;;;; jogo.lisp
;;;; IA - Projeto #2
;;;; Autor: Tiago Farinha (201802235), Francisco Moura (201802033)

;;;; NOTA (IMPORTANTE!!!): PÔR A PASTA NA RAIZ DO C: PARA CONSEGUIR LÊR O FICHEIRO

(defvar *exit* nil)
(defvar *nrSucessoresECortes* '(0 0))
(defvar *jogada* (list (tabuleiro-vazio) '(10 10 15) '(10 10 15)))

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(defun menu-inicial() ;;Escolha do tipo de jogo (H vs PC ou PC vs PC)
"Layout do sub-menu de escolha do algoritmo de procura"
  (format t "~%")
  (format t " ______________________________________~%")
  (format t "|            Blokus Uno                |~%")
  (format t "|                                      |~%")
  (format t "|      Escolha um modo de jogo:        |~%")
  (format t "|           1 - Humano vs IA           |~%")
  (format t "|           2 - IA vs IA               |~%")
  (format t "|           0 - Sair                   |~%")
  (format t "|______________________________________|~%")
  (format t "~%> ")
  (values) 
)


;---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(defun iniciar()
"Função que imprime o menu e espera pelo input do utilizador, redirecionando-o depois à 'página' seguinte"
    (menu-inicial)
    (setf *jogada* (list (tabuleiro-vazio) '(10 10 15) '(10 10 15)))
    (let ((comando (read)))
      (cond 
       ((not (numberp comando)) (format t "Insira um número!~%") (iniciar))
       ((= comando 0) t)
       ((or (= comando 1) (= comando 2)) (executar-escolha-tempo-limite-IA comando))
       (t (format t "Comando Inválido! Insira 1 para resolver um problema ou 0 para sair da aplicação...~%") (iniciar))
      )
    )
  (values)
)

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------

(defun executar-escolha-tempo-limite-IA (jogo)
"Escolher limite de tempo de execução do algoritmo"
     (format t "Qual o tempo limite para o algoritmo em milésimos de segundo (Insira 0 para voltar atrás)? ~%")
     (format t "> ")
     (setf *exit* nil)
     (let ((comando (read)))
       (cond 
        ((not (numberp comando)) (progn (format t "~%O limite de tempo tem de ser um NÚMERO ([1000,20000]ms)...~%") (executar-escolha-tempo-limite-IA jogo)))
        ((equal comando 0) (iniciar))
        ((or (< comando 1000) (> comando 20000)) (progn (format t "~%O limite de tempo tem de estar no intervalo [1000, 20000]ms...~%") (executar-escolha-tempo-limite-IA jogo)))  
        (t 
         (if (equal jogo 1)
             (escolha-primeiro-jogador comando)
             (progn (format t "Executando jogo. Por favor aguarde...~%") (AI-vs-AI comando))

         )
        )
       )
     )
     (values)
)

(defun escolha-primeiro-jogador (tempoLimite)
"Escolher quem joga primeiro"
  
     (format t "Quem deve começar o jogo (Humano - 1 | PC - 2)? (Insira 0 para voltar ao menu inicial) ~%")
     (format t "> ")
     (let ((comando (read)) (outputType (make-array 0 :element-type 'character
                                                      :adjustable T
                                                      :fill-pointer 0)))
   (declare (type string outputType))
       (cond 
        ((equal comando 0) (iniciar))
        ((or (equal comando 1) (equal comando 2)) (progn (formatar-solucao *jogada* outputType) (Humano-vs-AI tempoLimite comando)))
        (t (progn (format t "~%O primeiro a jogar tem de ser um NÚMERO (1 ou 2)...~%") (escolha-primeiro-jogador tempoLimite)))
        )
       )
     (values)
)


(defun AI-vs-AI (tempoLimite &optional (jogador 1))
"Correr o jogo no modo computador vs computador"
 (let ((noJogada (cria-no (first *jogada*) (second *jogada*) (third *jogada*))) (outputType (make-array 0
                                                                                              :element-type 'character
                                                                                              :adjustable T
                                                                                              :fill-pointer 0)))
  (declare (type string outputType))
  (if (not (and (no-solucaop noJogada 1) (no-solucaop noJogada 2)))
       (progn 
                     (let ((tempoInicio (GET-INTERNAL-RUN-TIME)))
                            (negamaxAlfaBeta noJogada 10 most-negative-fixnum most-positive-fixnum jogador (+ (get-internal-real-time) tempoLimite))
                    (let ((tempoFim (GET-INTERNAL-RUN-TIME)))
                        (estatisticas-AI (- tempoFim tempoInicio))
                            )
                       )
              (formatar-solucao *jogada* outputType)
              (if (equal jogador 1)
                (AI-vs-AI tempoLimite 2)
                (AI-vs-AI tempoLimite 1)
              )
       )
    (progn (calcular-vencedor (rest *jogada*) outputType) (iniciar))
  )
 )
)

(defun Humano-vs-AI (tempoLimite &optional jogador)
"Correr o jogo no modo humano vs computador"
  (let ((noJogada (cria-no (first *jogada*) (second *jogada*) (third *jogada*))) (outputType (make-array 0
                                                                                              :element-type 'character
                                                                                              :adjustable T
                                                                                              :fill-pointer 0)))
   (declare (type string outputType))
   (let ((fimJ1 (no-solucaop noJogada 1)) (fimJ2 (no-solucaop noJogada 2)))
     (if (not *exit*)
     (if (not (and fimJ1 fimJ2))
              (if (equal jogador 1)
                  (if (not fimJ1) 
                             (progn (jogada-humano)
                                    (formatar-solucao *jogada* outputType)
                                    (Humano-vs-AI tempoLimite 2))
                    (Humano-vs-AI tempoLimite 2)
                  )
                  (if (not fimJ2)
                     (progn (format t "O Computador está pensar! Por favor aguarde...~%") 
                       (let ((tempoInicio (GET-INTERNAL-RUN-TIME)))
                            (negamaxAlfaBeta noJogada 10 most-negative-fixnum most-positive-fixnum 2  (+ (get-internal-real-time) tempoLimite))
                            (let ((tempoFim (GET-INTERNAL-RUN-TIME)))
                               (estatisticas-AI (- tempoFim tempoInicio))
                            )
                       )
                            
                            (formatar-solucao *jogada* outputType)
                            (Humano-vs-AI tempoLimite 1)
                     )
                     (Humano-vs-AI tempoLimite 1)
                  )
              )
      (progn (calcular-vencedor (rest *jogada*) outputType) (iniciar))
    ))
  )
 )
)

(defun jogada-humano ()
"Escolher a jogada do jogador humano por input no formato <peca, linha, coluna>"
(if (not *exit*)
(progn (format t "Insira a jogada no formato: Peça linha coluna (ou 0 se desejar voltar ao menu inicial)~%")
       (format t "> ")
                        (let ((input (read-line)) (outputType (make-array 0
                                                              :element-type 'character
                                                              :adjustable T
                                                              :fill-pointer 0)))
   (declare (type string outputType))
   (if (equal input "0")
     (progn (setf *exit* t)
   (iniciar)))
  (let ((entrada-tratada (tratar-entrada (split-sequence " " input))))
     (if (validar-jogada-utilizador entrada-tratada)
         (if (not (null (validar-peca-jogador-humano (first entrada-tratada))))
           (if (null (verificar-peca-encaixa (second entrada-tratada) (third entrada-tratada) (first entrada-tratada) (first *jogada*) 1)) 
               (progn (format t "~%Posição inválida! Tente novamente...~%~%") (jogada-humano)) 
             (progn (setf *exit* nil)
               (setf *jogada* (list (colocar-peca (first entrada-tratada) (second entrada-tratada) (third entrada-tratada) (first *jogada*) 1) (decrementar-nr-pecas (first entrada-tratada) (second *jogada*)) (third *jogada*))) (valor-da-posicao outputType entrada-tratada))
           )
           (progn (format t "~%Não tem mais ~a!~%" (first entrada-tratada)) (jogada-humano))
         )
       (if (not *exit*)
           (progn (format t "~%Comando Inválido! Insira o formato válido...~%~%") (jogada-humano)) )
     )
  ))))
)
 
(defun validar-jogada-utilizador (entrada-tratada)
"Função que verifica se a jogada está num formato válido"
  (if (and (equal (length entrada-tratada) 3) 
           (verificar-dentro-dos-limites (second entrada-tratada) (third entrada-tratada)))
            t
  )
)

(defun tratar-entrada (entrada)
"Função que 'limpa' e converte o input para o formato correto"
  (let ((entradaPreTratada (remove nil entrada)))
    (alisa (list (find-symbol (string-upcase (first entradaPreTratada)))
                 (if (and (not (null (second entradaPreTratada))) (not (null (third entradaPreTratada))))
                     (list (parse-integer (second entradaPreTratada) :junk-allowed t)
                           (parse-integer (third entradaPreTratada) :junk-allowed t)
                     )
                 )
           )
    )
  )
)

(defun alisa (l)
"Função que converte uma lista com sublista em apenas uma lista"
  (cond ((equal 0 (list-length l)) nil)
        ((if (atom (first l))
             (append (list (first l)) (alisa (rest l)))       
             (append  (first l) (alisa (rest l))) 
   )))
)

;---------------------------------------------------------------------------------------------------------------------------------------------------------------------

; | ESTATÍSTICAS |

(defun escrever-ecra-ficheiro (outputType)
"Função que imprime algo para o ecrã e para um ficheiro"
  (if (not *exit*)
      (progn 
  (with-open-file (ficheiro (make-pathname :host "c" :directory '(:absolute "IA - Projeto 2") :name "log" :type "dat") :direction :output :if-exists :append :if-does-not-exist :create)
  (format ficheiro outputType))
  (write-line outputType)))
)

(defun formatar-solucao (solucao outputType)
"Chama a função que formata o tabuleiro e as peças adequadamente"
    (if (not (equal solucao nil))
        (progn (formatar-tabuleiro solucao outputType) 
           (formatar-pecas (rest solucao) outputType)
           (escrever-ecra-ficheiro outputType)
           (values))
    )
)

(defun formatar-tabuleiro (solucao outputType)
"Formata o tabuleiro para ser apresentado no ecrã"
  (format outputType " _____________________________________~%") 
  (format outputType "|                                     |~%")
  (format outputType "|      A B C D E F G H I J K L M N    |")
  (format outputType "~%")
  (let ((linha 0))
  (mapcar #'(lambda (atual) (progn (setf linha (1+ linha)) 
                              (if (< linha 11) (format outputType "|   ~a ~a   |~%" (1- linha) atual) 
                                            (format outputType "|  ~a ~a   |~%" (1- linha) atual)))) (first solucao))) 
  (format outputType "|_____________________________________|~%")
  (format outputType "~%") 
  (values)
)


(defun formatar-pecas (pecas outputType)
"Formata as peças para serem apresentadas no ecrã"
  (format outputType "             Peças de Jogo:              ~%~%")
  (format outputType " Peça a    Peça b    Peça c1     Peça c2  ~%")
  (format outputType "(peca-a)  (peca-b)  (peca-c-1)  (peca-c-2) ~%")
  (format outputType "   _         ___         ___        _      ~%")
  (format outputType "  |_|       |_|_|      _|_|_|      |_|_    ~%")
  (format outputType "            |_|_|     |_|_|        |_|_|   ~%")
  (format outputType "                                     |_|   ~%~%")
  
  (format outputType " Peças do Jogador 1: ~%")
  (format outputType " Peca a - ~a~%" (first (first pecas)))
  (format outputType " Peca b - ~a~%" (second (first pecas)))
  (format outputType " Peca c1 e c2 - ~a~%~%" (third (first pecas)))
  (format outputType " Peças do Jogador 2: ~%")
  (format outputType " Peca a - ~a~%" (first (second pecas)))
  (format outputType " Peca b - ~a~%" (second (second pecas)))
  (format outputType " Peca c1 e c2 - ~a~%~%" (third (second pecas)))
  (values)
)


(defun calcular-vencedor (pecas outputType)
"Calcula o vencedor de um jogo e apresenta-o (ecrã e ficheiro)"
  (let ((pj1 (calcular-pontos-jogador (first pecas))) (pj2 (calcular-pontos-jogador (second pecas))))
    (format outputType " ____________________________~%")
    (format outputType "|                            |~%")
    (format outputType "| Pontuação do Jogador 1: ~a |~%" pj1)
    (format outputType "| Pontuação do Jogador 2: ~a |~%" pj2)
    (format outputType "|                            |~%")
    (cond 
     ((< pj1 pj2) (format outputType "| O vencedor é o Jogador 1!  |~%"))
     ((< pj2 pj1) (format outputType "| O vencedor é o Jogador 2!  |~%~%"))
     (t (format outputType           "|          Empate!           |~%"))
    )
    (format outputType "|____________________________|~%~%~%")
    (format outputType "--------------------------------------------------------------------~%")
    (escrever-ecra-ficheiro outputType)
  )
  (values)
)

(defun valor-da-posicao (outputType jogada)
"Imprime a posição da jogada no formato <peca, linha, coluna> (ecrã e ficheiro)"
  (format outputType "Posição para onde jogou: ~a ~a ~a~%" (first jogada) (second jogada) (third jogada))
  (escrever-ecra-ficheiro outputType)
)

(defun estatisticas-AI (tempoExec)
"Imprime as estatísticas: nós explorados, número de cortes e o tempo de execução (ecrã e ficheiro)"
  (let ((outputType (make-array 0
                                :element-type 'character
                                :adjustable T
                                :fill-pointer 0)))
   (declare (type string outputType))
   (format outputType "~%Número de nós analisados: ~a~%" (first *nrSucessoresECortes*))
   (format outputType "Número de cortes: ~a~%" (second *nrSucessoresECortes*))
   (format outputType "Tempo de Execução: ~a ms~%" tempoExec)
   (setf *nrSucessoresECortes* '(0 0))
   (escrever-ecra-ficheiro outputType)
  )
)

mov ax, 0x13
int 0x10

;O objetivo do programa é preencher 16 linhas e 16 colunas com as primeiras 256 cores da paleta HEX

push 0xA000 ; Empurra o endereço para a pilha
pop es ; retira da pilha e armazena em es

xor ax, ax
xor bx, bx
xor cx, cx
xor dx, dx
xor di, di
;Contador = cl
;Numero de linhas = ch
;Quadrados_y = dh
;Quadrados_x = dl
;Memoria video = es:di
;Cor = ax

;São 16 quadrados por linha e 16 por colunas
;Serão feitos 2 bytes por vez

push ax; Empurra a cor para a pilha
principal:
mov [es:di], ax
inc di
inc di ; o incremento ocorre duas vezes pois estamos movimentado 2 bytes por vez
inc cl
inc cl
cmp cl, 0x14 ;confere se o contador chegou a 20 (quantidade de pixels da linha)
je mudacor ;caso sim, vai para a função que vai alterar a cor
jmp principal

mudacor:
add ax, 0x0101
inc dl; incrementamos a quantidade de quadrados na horizontal
cmp dl, 0x10; confere se já temos 16 quadrados na horizontal
je fechalinha ;Caso sim, vai para a funçaõ que altera a linha
xor cl, cl ; caso nao, zera o contador
jmp principal

fechalinha:
inc ch ;incrementa o numero de linhas
cmp ch, 0xC ; Confere se já são 12 linhas
je incQY ;Caso sim, incrementa um quadrado na vertical
pop ax ;Puxa a cor base da pilha
push ax; empurra ela de novo pra pilha
xor cl, cl ; zera o contador de pixels
xor dl, dl ; zera o contador de quadrados na horizontal para o inicio da proxima linha
jmp principal

incQY:
pop ax
add ax, 0x1010 ; acrescenta 16 nos bytes e altera a cor base para s proxima linha
push ax ; empurra a nova cor base para a pilha
xor cx, cx ; zera o contador e numero de linhas 
xor dl, dl
inc dh
cmp dh, 0x10 ; verifica se há 16 quadrados na vertical
je fim
jmp principal

fim:
jmp $

times 510 - ($ - $$) db 0
dw 0xAA55
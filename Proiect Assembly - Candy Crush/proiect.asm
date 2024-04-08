.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc
extern fopen: proc
extern fclose: proc
extern fscanf: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "Candy Crush",0
area_width EQU 600
area_height EQU 600
area DD 0

counter DD 0 ; numara evenimentele de tip timer

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

symbol_width EQU 10
symbol_height EQU 20
patrat_width EQU 20
patrat_height EQU 20
include digits.inc
include letters.inc

file_name DB "fisier.txt", 0
mode_read DB "r", 0
format DB "%d", 0
n DD 0
adresa DD 0
vector DD 100 DUP(0)
fin DD 0
var DD 0
index DD 0
y DD 0

click1 DD 0
click2 DD 0
ok DD 0
culoare1 DD 0
culoare2 DD 0
vector_click DD 100 DUP(0)
adresa_click_1 DD 0
culori DD 100 DUP(0)
index_patrat DD 0
coloana_pixel DD 0
linie_pixel DD 0
indice_patrat_1 DD 0
indice_patrat_2 DD 0
zece DD 10

.code
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0FFFFFFh
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp

; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm

;MACRO LINIE ORIZONTALA
line_horizontal macro x, y, len, color
local bucla_linie
     mov eax, y ; EAX=y
	 mov ebx, area_width
	 mul ebx ; EAX=y*area_width
	 add eax, x ; EAX=y*area_width+x
	 shl eax,2 ; EAX=(y*area_width+x)*4
	 add eax, area
	 mov ecx, len
bucla_linie:
	    mov dword ptr[eax], color
		add eax, 4
	    loop bucla_linie
	 
endm

;MACRO LINIE VERTICALA
line_vertical macro x, y, len, color
local bucla_verticala
    mov eax, y ; EAX=y
	mov ebx, area_width
	mul ebx ; EAX=y*area_width
	add eax, x ; EAX=y*area_width+x
	shl eax,2 ; EAX=(y*area_width+x)*4
	add eax, area
	mov ecx, len
bucla_verticala:
    mov dword ptr[eax],color
	add eax, 4*area_width
	loop bucla_verticala

endm

;MACRO COLORARE PATRATEL
color_square macro len, x, y, culoare
local colorare
    mov edi, y
	mov esi, 0
    colorare:
	line_horizontal x, edi, len, culoare
	inc edi
	inc esi
	cmp esi, len
	jne colorare
endm

;CITIRE DIN FISIER SI PUNERE IN MATRICE(VECTOR)
citire macro vector, mode_read, file_name, n, fin
local citire1
    push offset mode_read
    push offset file_name
	call fopen
    add esp,8	
	mov fin,eax
	
	mov esi,0
	
	citire1:
	push offset n
	push offset format
	push fin
	call fscanf
	add esp, 12
	
	mov eax, n
	mov vector[esi*4],eax

    inc esi
    cmp esi,100
	jne citire1
	
	push fin
	call fclose
	add esp,4
	
endm

;MACRO ALEGERE CULOARE PATRAT
choose_color macro  x, y, vector, var, len, i
local color_vector, finish, next1, next2, next3, next
    mov ebx, 0
	mov ebx, i
	
	color_vector:
	
	;0-alb
	cmp vector[ebx*4], 0
	jne next
	color_square len, x, y, 0FFFFFFH
	jmp finish
	
    next:
	;1-albastru
	cmp vector[ebx*4], 1
	jne next1
	color_square len, x, y, 000AACAH
	jmp finish
	next1:
	;2-mov
	cmp vector[ebx*4], 2
	jne next2
	color_square len, x, y, 0AA00CAH
	jmp finish
	next2:
	;3-roz
	cmp vector[ebx*4], 3
	jne next3
	color_square len, x, y, 0DD00AAH
	jmp finish
	next3:
    ;4-verde
    cmp vector[ebx*4], 4
    jne finish
    color_square len, x, y, 000DDAAH
	
	finish:
	
endm

;ALEG COLOANA PATRAT
choose_coloana_patrat macro x
local pas_urm_1, pas_urm_2, pas_urm_3, pas_urm_4, pas_urm_5, pas_urm_5, pas_urm_6, pas_urm_7, pas_urm_8, pas_urm_9, final
    cmp x, 150
	jl final
	cmp x, 180
	jg pas_urm_1
	mov edi, 1
	jmp final
	
	pas_urm_1:
	cmp x, 210
	jg pas_urm_2
	mov edi, 2
	jmp final
	
	pas_urm_2:
	cmp x, 240
	jg pas_urm_3
	mov edi, 3
	jmp final
	
	pas_urm_3:
	cmp x, 270
	jg pas_urm_4
	mov edi, 4
	jmp final
	
	pas_urm_4:
	cmp x, 300
	jg pas_urm_5
	mov edi, 5
	jmp final
	
	pas_urm_5:
	cmp x, 330
	jg pas_urm_6
	mov edi, 6
	jmp final
	
	pas_urm_6:
	cmp x, 360
	jg pas_urm_7
	mov edi, 7
	jmp final
	
	pas_urm_7:
	cmp x, 390
	jg pas_urm_8
	mov edi, 8
	jmp final
	
	pas_urm_8:
	cmp x, 420
	jg pas_urm_9
	mov edi, 9
	jmp final
	
	pas_urm_9:
	cmp x, 450
	jg final
	mov edi, 10
	
	
	final:
	
	
endm;

;ALEG LINIE PATRAT
choose_linie_patrat macro  y
local pas_urm_1, pas_urm_2, pas_urm_3, pas_urm_4, pas_urm_5, pas_urm_5, pas_urm_6, pas_urm_7, pas_urm_8, pas_urm_9, final
    cmp y, 150
	jl final
	cmp y, 180
	jg pas_urm_1
	mov esi, 1
	jmp final
	
	pas_urm_1:
	cmp y, 210
	jg pas_urm_2
	mov esi, 2
	jmp final
	
	pas_urm_2:
	cmp y, 240
	jg pas_urm_3
	mov esi, 3
	jmp final
	
	pas_urm_3:
	cmp y, 270
	jg pas_urm_4
	mov esi, 4
	jmp final
	
	pas_urm_4:
	cmp y, 300
	jg pas_urm_5
	mov esi, 5
	jmp final
	
	pas_urm_5:
	cmp y, 330
	jg pas_urm_6
	mov esi, 6
	jmp final
	
	pas_urm_6:
	cmp y, 360
	jg pas_urm_7
	mov esi, 7
	jmp final
	
	pas_urm_7:
	cmp y, 390
	jg pas_urm_8
	mov esi, 8
	jmp final
	
	pas_urm_8:
	cmp y, 420
	jg pas_urm_9
	mov esi, 9
	jmp final
	
	pas_urm_9:
	cmp y, 450
	jg final
	mov esi, 10
	
	final:
	
	
endm;

;VERIFICARE LINIE
verific_linie macro index_square
local urm1, urm2, done
    mov ecx, 0
	mov edx, 0
	mov ecx, index_square
	
	mov edx, vector[ecx*4-4]
	cmp vector[ecx*4], edx
	jne urm1
	mov edx, 0
	mov edx, vector[ecx*4+4] 
	cmp vector[ecx*4], edx
	jne urm1
	
	mov vector[ecx*4], 0
	mov vector[ecx*4-4], 0
	mov vector[ecx*4+4], 0
	
	jmp done
	
	urm1:
	mov edx, 0
	mov edx, vector[ecx*4-4]
	cmp vector[ecx*4], edx
	jne urm2
	mov edx, 0
	mov edx, vector[ecx*4-4*2]
	cmp vector[ecx*4], edx
	jne urm2
	
	mov vector[ecx*4], 0
	mov vector[ecx*4-4], 0
	mov vector[ecx*4-4*2], 0
	
	jmp done
	
	urm2:
	mov edx, 0
	mov edx, vector[ecx*4+4]
	cmp vector[ecx*4], edx
	jne done
	mov edx, 0
	mov edx, vector[ecx*4+4*2]
	cmp vector[ecx*4], edx
	jne done
	
	mov vector[ecx*4], 0
	mov vector[ecx*4+4], 0
	mov vector[ecx*4+4*2], 0
	
	done:

endm

;VERIFICARE COLOANA
verific_coloana macro index_square
local urm1, urm2, done
    mov ecx, 0
	mov edx, 0
	mov ecx, index_square
 
    mov edx, vector[ecx*4-4*10]
	cmp vector[ecx*4], edx
	jne urm1
	mov edx, 0
	mov edx, vector[ecx*4+4*10]
	cmp vector[ecx*4], edx
	jne urm1
	
	mov vector[ecx*4], 0
	mov vector[ecx*4-4*10], 0
	mov vector[ecx*4+4*10], 0
	
	jmp done
	
	urm1:
	mov edx, 0
	mov edx, vector[ecx*4-4*10]
	cmp vector[ecx*4], edx
	jne urm2
	mov edx, 0
	mov edx, vector[ecx*4-4*20]
	cmp vector[ecx*4], edx
	jne urm2
	
	mov vector[ecx*4], 0
	mov vector[ecx*4-4*10], 0
	mov vector[ecx*4-4*20], 0
	
	jmp done
	
	urm2:
	mov edx, 0
	mov edx, vector[ecx*4+4*10]
	cmp vector[ecx*4], edx
	jne done
	mov edx, 0
	mov edx, vector[ecx*4+4*20]
	cmp vector[ecx*4], edx
	jne done
	
	mov vector[ecx*4], 0
	mov vector[ecx*4+4*10], 0
	mov vector[ecx*4+4*20], 0
	
	done:
	
endm;

; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
	jmp afisare
	
evt_click:

    mov eax, 0
	mov ecx, 0
	mov ebx, 0
	mov edx, 0
	mov esi, 0
	mov edi, 0
    
	; mov eax, [ebp+arg3] ;EAX=y
	; mov ebx, area_width
	; mul ebx ; EAX=y*area_width
	; add eax, [ebp+arg2] ; EAX=y*area_width+x
	; shl eax,2 ; EAX=(y*area_width+x)*4
	; add eax, area
																						
	mov ecx, [ebp+arg2] ;ecx=x
    mov edx, [ebp+arg3]	;edx=y
	
	mov coloana_pixel, ecx ;coloana_pixel=x
	mov linie_pixel, edx ;linie_pixel=y
	
	;coloana pixel ,edi=x-coloana patrat
    choose_coloana_patrat  coloana_pixel
	;linie pixel ,esi=y-linie patrat
	choose_linie_patrat  linie_pixel 
	
	
tip_click:
    ;x-coloana-arg2
	;y-linie-arg3
	
	;calculez indexul patratului
    mov eax, esi
	mov edx, 0
	mov ebx, 10
	mul ebx ;eax=y(linia)*10
	mov ecx, 10
	sub ecx, edi ;ecx=10-x(coloana)
	sub eax, ecx ;eax=y*10-(10-x)
	dec eax ; eax=eax-1
	;eax=index patrat
    

    cmp ok, 0
	je CLICK_1
	mov ok,0
	mov vector_click[4*eax], 0
	
	;ALEGERE POZITIE PATRAT UNDE S-A DAT CLICK ANTERIOR
	cmp vector_click[4*eax-4], 1
	je swap_1
	cmp vector_click[4*eax+4], 1
	je swap_2
	cmp vector_click[4*eax-4*10], 1
	je swap_3
	cmp vector_click[4*eax+4*10], 1
	je swap_4
	
	jmp afisare
	
	swap_1:
	cmp vector[4*eax-4], 0
	je afisare
	cmp vector[4*eax], 0
	je afisare
	
    mov edx, vector[4*eax-4] ;cifra culoare click 1
	mov ecx, vector[4*eax] ;cifra culoare clik 2
	mov vector[4*eax-4], ecx
	mov vector[4*eax], edx
	
	mov vector_click[4*eax-4], 0
	
	mov indice_patrat_1, eax
	
	verific_coloana indice_patrat_1
	verific_linie indice_patrat_1
	
	dec eax
	mov indice_patrat_2, eax
	
	verific_coloana indice_patrat_2
	verific_linie indice_patrat_2
	
	jmp afisare
	
	swap_2:
	cmp vector[4*eax+4], 0
	je afisare
	cmp vector[4*eax], 0
	je afisare
	
	
	mov edx, vector[4*eax+4] ;culoare click 1
	mov ecx, vector[4*eax] ;culoare clik 2
	mov vector[4*eax+4], ecx
	mov vector[4*eax], edx
	
	mov vector_click[4*eax+4], 0
	
	mov indice_patrat_1, eax
	
	verific_coloana indice_patrat_1
	verific_linie indice_patrat_1
	
	inc eax
	mov indice_patrat_2, eax
	
	verific_coloana indice_patrat_2
	verific_linie indice_patrat_2
	
	jmp afisare
	
	swap_3:
	cmp vector[4*eax-4*10], 0
	je afisare
	cmp vector[4*eax], 0
	je afisare
	
	mov edx, vector[4*eax-4*10] ;culoare click 1
	mov ecx, vector[4*eax] ;culoare clik 2
	mov vector[4*eax-4*10], ecx
	mov vector[4*eax], edx
	
	mov vector_click[4*eax-4*10], 0
	
	mov indice_patrat_1, eax
	
	verific_coloana indice_patrat_1
	verific_linie indice_patrat_1
	
	sub eax, zece
	mov indice_patrat_2, eax
	
	verific_coloana indice_patrat_2
	verific_linie indice_patrat_2
	
	jmp afisare
	
	swap_4:
	cmp vector[4*eax+4*10], 0
	je afisare
	cmp vector[4*eax], 0
	je afisare
	
	mov edx, vector[4*eax+4*10] ;culoare click 1
	mov ecx, vector[4*eax] ;culoare clik 2
	mov vector[4*eax+4*10], ecx
	mov vector[4*eax], edx
	
	mov vector_click[4*eax+4*10], 0
	
	mov indice_patrat_1, eax
	
	verific_coloana indice_patrat_1
	verific_linie indice_patrat_1
	
	add eax, 10
	mov indice_patrat_2, eax
	
	verific_coloana indice_patrat_2
	verific_linie indice_patrat_2
	
	jmp afisare
	
	;PRIMUL CLICK
	CLICK_1 :
	mov ok, 1
	mov vector_click[4*eax], 1
    jmp afisare
	
evt_timer:
	inc counter
	
afisare:
	;afisam valoarea counter-ului curent (sute, zeci si unitati)
	mov ebx, 10
	mov eax, counter
	;cifra unitatilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 30, 10
	;cifra zecilor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 20, 10
	;cifra sutelor
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, 10, 10
	
	make_text_macro 'J', area, 160, 65
	make_text_macro 'O', area, 180, 65
	make_text_macro 'C', area, 200, 65
	
	make_text_macro 'C', area, 240, 65
	make_text_macro 'A', area, 260, 65
	make_text_macro 'N', area, 280, 65
	make_text_macro 'D', area, 300, 65
	make_text_macro 'Y', area, 320, 65
	
	make_text_macro 'C', area, 360, 65
	make_text_macro 'R', area, 380, 65
	make_text_macro 'U', area, 400, 65
	make_text_macro 'S', area, 420, 65
	make_text_macro 'H', area, 440, 65
	
	line_horizontal 150, 150, 300, 0H
	line_horizontal 150, 450, 300, 0H
	
	line_vertical 150, 150, 300, 0H
	line_vertical 450, 150, 300, 0H
	
    line_vertical 180, 150, 300, 0H
	line_vertical 210, 150, 300, 0H
	line_vertical 240, 150, 300, 0H
	line_vertical 270, 150, 300, 0H
	line_vertical 300, 150, 300, 0H
	line_vertical 330, 150, 300, 0H
	line_vertical 360, 150, 300, 0H
	line_vertical 390, 150, 300, 0H
	line_vertical 420, 150, 300, 0H

	line_horizontal 150, 180, 300, 0H
	line_horizontal 150, 210, 300, 0H
	line_horizontal 150, 240, 300, 0H
	line_horizontal 150, 270, 300, 0H
	line_horizontal 150, 300, 300, 0H
	line_horizontal 150, 330, 300, 0H
	line_horizontal 150, 360, 300, 0H
	line_horizontal 150, 390, 300, 0H
	line_horizontal 150, 420, 300, 0H
	
    choose_color 150, 150, vector, var, 30, 0
    choose_color 180, 150, vector, var, 30, 1
	choose_color 210, 150, vector, var, 30, 2
	choose_color 240, 150, vector, var, 30, 3
	choose_color 270, 150, vector, var, 30, 4
	choose_color 300, 150, vector, var, 30, 5
	choose_color 330, 150, vector, var, 30, 6
	choose_color 360, 150, vector, var, 30, 7
	choose_color 390, 150, vector, var, 30, 8
	choose_color 420, 150, vector, var, 30, 9
	
	
	choose_color 150, 180, vector, var, 30, 10
    choose_color 180, 180, vector, var, 30, 11
	choose_color 210, 180, vector, var, 30, 12
	choose_color 240, 180, vector, var, 30, 13
	choose_color 270, 180, vector, var, 30, 14
	choose_color 300, 180, vector, var, 30, 15
	choose_color 330, 180, vector, var, 30, 16
	choose_color 360, 180, vector, var, 30, 17
	choose_color 390, 180, vector, var, 30, 18
	choose_color 420, 180, vector, var, 30, 19
	
	choose_color 150, 210, vector, var, 30, 20
    choose_color 180, 210, vector, var, 30, 21
	choose_color 210, 210, vector, var, 30, 22
	choose_color 240, 210, vector, var, 30, 23
	choose_color 270, 210, vector, var, 30, 24
	choose_color 300, 210, vector, var, 30, 25
	choose_color 330, 210, vector, var, 30, 26
	choose_color 360, 210, vector, var, 30, 27
	choose_color 390, 210, vector, var, 30, 28
	choose_color 420, 210, vector, var, 30, 29
	
	choose_color 150, 240, vector, var, 30, 30
    choose_color 180, 240, vector, var, 30, 31
	choose_color 210, 240, vector, var, 30, 32
	choose_color 240, 240, vector, var, 30, 33
	choose_color 270, 240, vector, var, 30, 34
	choose_color 300, 240, vector, var, 30, 35
	choose_color 330, 240, vector, var, 30, 36
	choose_color 360, 240, vector, var, 30, 37
	choose_color 390, 240, vector, var, 30, 38
	choose_color 420, 240, vector, var, 30, 39
	
	choose_color 150, 270, vector, var, 30, 40
    choose_color 180, 270, vector, var, 30, 41
	choose_color 210, 270, vector, var, 30, 42
	choose_color 240, 270, vector, var, 30, 43
	choose_color 270, 270, vector, var, 30, 44
	choose_color 300, 270, vector, var, 30, 45
	choose_color 330, 270, vector, var, 30, 46
	choose_color 360, 270, vector, var, 30, 47
	choose_color 390, 270, vector, var, 30, 48
	choose_color 420, 270, vector, var, 30, 49
	
	choose_color 150, 300, vector, var, 30, 50
    choose_color 180, 300, vector, var, 30, 51
	choose_color 210, 300, vector, var, 30, 52
	choose_color 240, 300, vector, var, 30, 53
	choose_color 270, 300, vector, var, 30, 54
	choose_color 300, 300, vector, var, 30, 55
	choose_color 330, 300, vector, var, 30, 56
	choose_color 360, 300, vector, var, 30, 57
	choose_color 390, 300, vector, var, 30, 58
	choose_color 420, 300, vector, var, 30, 59
	
	choose_color 150, 330, vector, var, 30, 60
    choose_color 180, 330, vector, var, 30, 61
	choose_color 210, 330, vector, var, 30, 62
	choose_color 240, 330, vector, var, 30, 63
	choose_color 270, 330, vector, var, 30, 64
	choose_color 300, 330, vector, var, 30, 65
	choose_color 330, 330, vector, var, 30, 66
	choose_color 360, 330, vector, var, 30, 67
	choose_color 390, 330, vector, var, 30, 68
	choose_color 420, 330, vector, var, 30, 69
	
	choose_color 150, 360, vector, var, 30, 70
    choose_color 180, 360, vector, var, 30, 71
	choose_color 210, 360, vector, var, 30, 72
	choose_color 240, 360, vector, var, 30, 73
	choose_color 270, 360, vector, var, 30, 74
	choose_color 300, 360, vector, var, 30, 75
	choose_color 330, 360, vector, var, 30, 76
	choose_color 360, 360, vector, var, 30, 77
	choose_color 390, 360, vector, var, 30, 78
	choose_color 420, 360, vector, var, 30, 79
	
	choose_color 150, 390, vector, var, 30, 80
    choose_color 180, 390, vector, var, 30, 81
	choose_color 210, 390, vector, var, 30, 82
	choose_color 240, 390, vector, var, 30, 83
	choose_color 270, 390, vector, var, 30, 84
	choose_color 300, 390, vector, var, 30, 85
	choose_color 330, 390, vector, var, 30, 86
	choose_color 360, 390, vector, var, 30, 87
	choose_color 390, 390, vector, var, 30, 88
	choose_color 420, 390, vector, var, 30, 89
	
	choose_color 150, 420, vector, var, 30, 90
    choose_color 180, 420, vector, var, 30, 91
	choose_color 210, 420, vector, var, 30, 92
	choose_color 240, 420, vector, var, 30, 93
	choose_color 270, 420, vector, var, 30, 94
	choose_color 300, 420, vector, var, 30, 95
	choose_color 330, 420, vector, var, 30, 96
	choose_color 360, 420, vector, var, 30, 97
	choose_color 390, 420, vector, var, 30, 98
	choose_color 420, 420, vector, var, 30, 99
	
	
	;albastru : 000AACAH - 1
	;mov : 0AA00CAH - 2
	;roz : 0DD00AAH - 3
	;verde : 000DDAAH - 4
	

final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	
	;citire cifre culori in vector 
	citire vector, mode_read, file_name, n, fin
	
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	
	
	;terminarea programului
	push 0
	call exit
end start

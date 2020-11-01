format PE console
entry start

include 'win32a.inc'

; Кузнецов Михаил Алексндрович БПИ199
; 13 вариант
; Вычисление даты пасхи по введенному году
;--------------------------------------------------------------------------
section '.data' data readable writable

        strYear   db 'Enter yearfrom 1918 to 2099: ', 0
        strIncorSize db 'Incorrect year = %d', 10, 0
        strPashaApril db 'In %d, the Easter will happen on %d April', 10, 0
        strPashaMay db 'In %d, the Easter will happen on %d May', 10, 0
        strScanInt   db '%d', 0

        f            dd 0
        a            dd 0
        b            dd 0
        c            dd 0
        d            dd 0
        e            dd 0
        year         dd 0

;--------------------------------------------------------------------------
section '.code' code readable executable
start:
        ;Вводим год
        call YearInput
        ;Поиск числа a
        call count_a
        ;Поиск числа b
        call count_b
        ;Поиск числа c
        call count_c
        ;Поиск числа d
        call count_d
        ;Поиск числа e
        call count_e
        ;Поиск числа f
        call count_f

        ;Вывод вычисленной даты пасхи
        call printDate
finish:                         ; Завершениеработы программы
        call [getch]
        push 0
        call [ExitProcess]

;-------------------------------Ввод года-------------------------
YearInput:
        push strYear
        call [printf]
        add esp, 4

        push year
        push strScanInt         ; Считывание года
        call [scanf]
        add esp, 8

        cmp [year], 1918
        jl  failSize

        cmp [year], 2099
        jg  failSize

        ret
failSize:                       ; Вывод сообщения о некорректной длине
        push [year]
        push strIncorSize
        call [printf]
        jmp finish
;----------------------Деление чисел и поиск их остатка-----------
divide:
        mov eax, [esp+8]        ; Делимое
        cdq
        mov ebx, [esp+4]        ; Делитель
        idiv ebx

        ret
;------------------------------Подсчет числа a------------------
count_a:
        push [year]
        push 19
        call divide             ; Поиск остатка от деления года на 19
        mov [a], edx
        add esp, 8

        ret
;------------------------------Подсчет числа b------------------
count_b:
        push [year]
        push 4
        call divide             ; Поиск остатка от деления года на 4
        mov [b], edx
        add esp, 8

        ret
;------------------------------Подсчет числа c------------------
count_c:
        push [year]
        push 7
        call divide             ; Поиск остатка от деления года на 7
        mov [c], edx
        add esp, 8

        ret
;------------------------------Подсчет числа d------------------
count_d:
        mov ebx, [a]
        mov eax, 19
        mul bx                  ; Перемножение a и 19
        add eax, 15             ; Добавлнеие к произвелению 15
        push eax
        push 30
        call divide             ; Поиск остатка от деления a*19 + 15 на 30
        add esp, 8
        mov [d], edx

        ret
;------------------------------Подсчет числа e------------------
count_e:
        xor ecx, ecx

        mov ebx, [b]
        mov eax, 2
        mul ebx                 ; Перемножение b и 2
        add ecx, eax            ; Добавоение к сумме b*2

        mov ebx, [c]
        mov eax, 4
        mul ebx                 ; Перемножение c и 4
        add ecx, eax            ; Добавоение к сумме c*4

        mov ebx, [d]
        mov eax, 6
        mul ebx                 ; Перемножение d и 6
        add ecx, eax            ; Добавоение к сумме d*6
        add ecx, 6              ; Добавоение к сумме 6

        push ecx
        push 7
        call divide             ; Поиск остатка от деления 2*b + 4*c + 6*d + 6 на 7
        mov [e], edx
        add esp, 8

        ret
;------------------------------Подсчет числа f------------------
count_f:
        mov eax, [d]
        mov ecx, [e]
        add eax, ecx            ; Сложение e и f
        mov [f], eax
        ret
;------------------------------Вывод даты пасхи------------------
printDate:
        mov eax, [f]
        cmp eax, 26             ; Если f > 26, то перейти на вывод даты в марте. Иначе вывод даты в апреле
        ja printMay

        add eax, 4
        push eax
        push [year]
        push strPashaApril
        call [printf]           ; Вывод даты в апреле
        jmp outPrint            ; Переход к завешению вывода

printMay:
        sub eax, 26
        push eax
        push [year]
        push strPashaMay
        call [printf]           ; Вывод даты в марте

outPrint:                       ; Завершение вывода
        add esp, 12
        ret
;--------------------------------------------------------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll'

include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'
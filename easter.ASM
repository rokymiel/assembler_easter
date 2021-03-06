format PE console
entry start

include 'win32a.inc'

; �������� ������ ������������ ���199
; 13 �������
; ���������� ���� ����� �� ���������� ����
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
        ;������ ���
        call YearInput
        ;����� ����� a
        call count_a
        ;����� ����� b
        call count_b
        ;����� ����� c
        call count_c
        ;����� ����� d
        call count_d
        ;����� ����� e
        call count_e
        ;����� ����� f
        call count_f

        ;����� ����������� ���� �����
        call printDate
finish:                         ; ���������������� ���������
        call [getch]
        push 0
        call [ExitProcess]

;-------------------------------���� ����-------------------------
YearInput:
        push strYear
        call [printf]
        add esp, 4

        push year
        push strScanInt         ; ���������� ����
        call [scanf]
        add esp, 8

        cmp [year], 1918
        jl  failSize

        cmp [year], 2099
        jg  failSize

        ret
failSize:                       ; ����� ��������� � ������������ �����
        push [year]
        push strIncorSize
        call [printf]
        jmp finish
;----------------------������� ����� � ����� �� �������-----------
divide:
        mov eax, [esp+8]        ; �������
        cdq
        mov ebx, [esp+4]        ; ��������
        idiv ebx

        ret
;------------------------------������� ����� a------------------
count_a:
        push [year]
        push 19
        call divide             ; ����� ������� �� ������� ���� �� 19
        mov [a], edx
        add esp, 8

        ret
;------------------------------������� ����� b------------------
count_b:
        push [year]
        push 4
        call divide             ; ����� ������� �� ������� ���� �� 4
        mov [b], edx
        add esp, 8

        ret
;------------------------------������� ����� c------------------
count_c:
        push [year]
        push 7
        call divide             ; ����� ������� �� ������� ���� �� 7
        mov [c], edx
        add esp, 8

        ret
;------------------------------������� ����� d------------------
count_d:
        mov ebx, [a]
        mov eax, 19
        mul bx                  ; ������������ a � 19
        add eax, 15             ; ���������� � ������������ 15
        push eax
        push 30
        call divide             ; ����� ������� �� ������� a*19 + 15 �� 30
        add esp, 8
        mov [d], edx

        ret
;------------------------------������� ����� e------------------
count_e:
        xor ecx, ecx

        mov ebx, [b]
        mov eax, 2
        mul ebx                 ; ������������ b � 2
        add ecx, eax            ; ���������� � ����� b*2

        mov ebx, [c]
        mov eax, 4
        mul ebx                 ; ������������ c � 4
        add ecx, eax            ; ���������� � ����� c*4

        mov ebx, [d]
        mov eax, 6
        mul ebx                 ; ������������ d � 6
        add ecx, eax            ; ���������� � ����� d*6
        add ecx, 6              ; ���������� � ����� 6

        push ecx
        push 7
        call divide             ; ����� ������� �� ������� 2*b + 4*c + 6*d + 6 �� 7
        mov [e], edx
        add esp, 8

        ret
;------------------------------������� ����� f------------------
count_f:
        mov eax, [d]
        mov ecx, [e]
        add eax, ecx            ; �������� e � f
        mov [f], eax
        ret
;------------------------------����� ���� �����------------------
printDate:
        mov eax, [f]
        cmp eax, 26             ; ���� f > 26, �� ������� �� ����� ���� � �����. ����� ����� ���� � ������
        ja printMay

        add eax, 4
        push eax
        push [year]
        push strPashaApril
        call [printf]           ; ����� ���� � ������
        jmp outPrint            ; ������� � ��������� ������

printMay:
        sub eax, 26
        push eax
        push [year]
        push strPashaMay
        call [printf]           ; ����� ���� � �����

outPrint:                       ; ���������� ������
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
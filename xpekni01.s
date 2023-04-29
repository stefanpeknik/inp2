; Autor reseni: Jmeno Prijmeni login

; Projekt 2 - INP 2022
; Vernamova sifra na architekture MIPS64

; DATA SEGMENT
                .data
login:          .asciiz "za0"  ; sem doplnte vas login
cipher:         .space  17  ; misto pro zapis sifrovaneho loginu
key:            .asciiz "aa" ; klic pro sifrovani

params_sys5:    .space  8   ; misto pro ulozeni adresy pocatku
                            ; retezce pro vypis pomoci syscall 5
                            ; (viz nize "funkce" print_string)

; CODE SEGMENT
                .text

                ; ZDE NAHRADTE KOD VASIM RESENIM
main:

                daddi r19, r0, 0 ; create indexer
                daddi r10, r0, 0 ; create indexer for key
                while:
                    lbu r5, login(r19) ; save char from login to r10
                    daddi r7, r5, -97       ; r7 = r5 - 96
                    bgez r7, continue       ; if r7 >= 0, continue
                    b end_while             ; if r7 < 0, end while
                    
                    continue:               ; if condition is passed
                    daddi r10, r0, 0         ; r10 = 0
                    dadd r10, r10, r19         ; r10 = r19
                    daddi r7, r0, 0         ; r7 = 0
                    daddi r7, r0, 2         ; r7 = 2
                    ddiv r10, r7             ; r10 / r7
                    mfhi r10                 ; r10 = r10 % r7
                    beq r10, r0, add_label      ; if r10 == 0 then add
                    b sub_label             ; else sub

                    add_label:
                    lbu r4, key(r10)         ; r4 = key[r10]
                    daddi r4, r4, -96       ; r4 = r4 - 96
                    b create_cypher         ; go to create_cypher

                    sub_label:
                    lbu r4, key(r10)         ; r4 = key[r10]
                    daddi r4, r4, -96       ; r4 = r4 - 96
                    daddi r7, r0, 0         ; r7 = 0
                    daddi r7, r0, -1        ; r7 = -1
                    dmult r4, r7            ; r4 * r7
                    mflo r4                 ; r4 = r4 * r7
                    b create_cypher         ; go to create_cypher

                    create_cypher:
                    lbu r5, login(r19)
                    daddi r5, r5, -97       ; r5 = r5 - 97
                    dadd r5, r5, r4         ; r5 = r5 + r4
                    daddi r7, r0, 0         ; r7 = 0
                    daddi r7, r0, 26        ; r7 = 26
                    ddiv r5, r7             ; r5 = r5 / r7
                    mfhi r5      
                    
                    bgez r5, finish         ; if r5 >= 0, finish
                    daddi r5, r5, 26        ; r5 = r5 + 26
                    
                    finish:           ; r5 = r5 % r7
                    daddi r5, r5, 97        ; r5 = r5 + 97
                    b save_cypher           ; go to save_cypher

                    save_cypher:
                    sb r5, cipher(r19)       ; save char to cipher
                    daddi r19, r19, 1         ; increment indexer
                    b while
                end_while:

                daddi   r4, r0, cipher
                jal     print_string    ; vypis pomoci print_string - viz nize
                syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address

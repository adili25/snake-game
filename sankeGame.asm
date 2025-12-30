.MODEL SMALL

.STACK 100H 

.DATA
    snakeX DB 100 DUP(?)
    snakeY DB 100 DUP(?)
    score DB 0
    char_TL   DB 0DAh
    char_TR   DB 0BFh
    char_BL   DB 0C0h
    char_BR   DB 0D9h
    char_H    DB 0C4h
    char_V    DB 0B3h

.CODE
START: ;start here
    MOV AX,@DATA
    MOV DS,AX
    MOV AH, 00H
    MOV AL, 03H ;entering text mode 80*25
    INT 10H
    
CALL DRAW_CORNERS
CALL DRAW_ROWS
CALL DRAW_COLS

MOV AH, 4CH ;exit
INT 21H
          
DRAW_CORNERS PROC 
    ; WE CAN REDUCE THE LINES OF THE PRINTING CORNERS BY USING
    ; TWO ARRAYS ONE FOR THE COORDS(USING THE LOW COL AND HIGH FOR ROWS)
    ; AND THE OTHER FOR THE CHARS
    ; COORDS DW 0000H, 004FH, 1800H, 184FH
    ; CORNERS DB 0DAh, 0BFh, 0C0h, 0D9h (TL,TR,BL,BR) 
    
    MOV BH, 0 ;PAGE
    MOV CX, 1 
TOP_LEFT:
    MOV AH, 02H            
    MOV DH, 0 ;ROWS
    MOV DL, 0 ;COLS
    INT 10H
    
    MOV AH, 09H
    MOV AL, char_TL
    MOV BL, 0FH ;for white color
    INT 10H

TOP_RIGHT:
    MOV AH, 02H            
    MOV DH, 0 ;ROWS
    MOV DL, 79 ;COLS
    INT 10H
    
    MOV AH, 09H
    MOV AL, char_TR
    MOV BL, 0FH ;for white color
    INT 10H

BOTTOM_LEFT:
    MOV AH, 02H            
    MOV DH, 24 ;ROWS
    MOV DL, 0 ;COLS
    INT 10H
    
    MOV AH, 09H
    MOV AL, char_BL
    MOV BL, 0FH ;for white color
    INT 10H

BOTTOM_RIGHT:
    MOV AH, 02H            
    MOV DH, 24 ;ROWS
    MOV DL, 79 ;COLS
    INT 10H
    
    MOV AH, 09H
    MOV AL, char_BR
    MOV BL, 0FH ;for white color
    INT 10H   
    
    RET
DRAW_CORNERS ENDP          
    
          
DRAW_ROWS PROC
    
    MOV CX, 78
    MOV DL, 1
    MOV BL, 0FH
    
DRAW_ROWS_LOOP: 
    ;HIGHER ROW 
    MOV DH, 0  
    MOV AH, 02H
    INT 10H
    
    MOV AH, 09H
    MOV AL, char_H
    
    PUSH CX
    MOV CX, 1
    INT 10H
    POP CX
    
    ;LOWER ROW
    MOV DH, 24           
    MOV AH, 02H
    INT 10H
    
    MOV AH, 09H
    MOV AL, char_H      
           
    PUSH CX
    MOV CX, 1
    INT 10H
    POP CX
          
    ;INC THE COL (DL)      
    INC DL
    LOOP DRAW_ROWS_LOOP
     
    
    RET
DRAW_ROWS ENDP 

DRAW_COLS PROC
    
    MOV CX, 23
    MOV DH, 1
    MOV BL, 0FH
DRAW_COLS_LOOP:    
   ;RIGHT COL 
    MOV DL, 0  
    MOV AH, 02H
    INT 10H
    
    MOV AH, 09H
    MOV AL, char_V
    
    PUSH CX
    MOV CX, 1
    INT 10H
    POP CX
    
    ;LEFT COL
    MOV DL, 79           
    MOV AH, 02H
    INT 10H
    
    MOV AH, 09H
    MOV AL, char_V      
           
    PUSH CX
    MOV CX, 1
    INT 10H
    POP CX
          
    ;INC THE ROW (DL)      
    INC DH
    LOOP DRAW_COLS_LOOP
    
    RET
DRAW_COLS ENDP   

END START
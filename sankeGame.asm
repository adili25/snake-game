.MODEL SMALL

.STACK 100H 

.DATA
    char_TL DB 0DAh
    char_TR DB 0BFh
    char_BL DB 0C0h
    char_BR DB 0D9h
    char_H DB 0C4h
    char_V DB 0B3h
    
    snakeX DB 100 DUP(?)
    snakeY DB 100 DUP(?)
    snake_len DB 3
    
    foodX DB ?
    foodY DB ?
    
    score DB 0
    curr_dir DB 1 ;1-RIGHT, 2-UP, 3-RIGHT, 4-BOTTOM
    
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
CALL INIT_SNAKE

GAME_LOOP:
    CALL CHECK_INPUT
    CALL UPDATE_SNAKE
    CALL COLLISON
    CALL DRAW_SCREEN
    
    ;DELAY
    JMP GAME_LOOP
          
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

INIT_SNAKE PROC
                      
    MOV DH, 12
    MOV DL, 39
    MOV AH, 02H
    MOV BH, 0   
    INT 10H
    
    MOV AH, 09H
    MOV AL, '@'
    MOV CX, 1
    MOV BL, 0FH
    INT 10H
    
    RET                                             
INIT_SNAKE ENDP  

CHECK_INPUT PROC ;1-RIGHT, 2-TOP, 3-LEFT, 4-BOTTOM
    
    MOV AH, 01H
    INT 16H
    
    JZ NO_INPUT
    
    MOV AH, 00H ;IF THERE IS AN INPUT IT WILL BEEN SAVED IN AL
    INT 16H
    
    CMP AL, "a"
    JMP MOVE_LEFT
    CMP AL, "s"
    JMP MOVE_RIGHT
    
    MOVE_LEFT:
        CMP curr_dir, 1 
        JE ITS_RIGHT
        DEC curr_dir
        JMP NO_INPUT
        
        ITS_RIGHT:
            MOV curr_dir, 4
        JMP NO_INPUT
     
    MOVE_RIGHT:
        CMP curr_dir, 4 
        JE ITS_BOTTOM
        INC curr_dir
        JMP NO_INPUT
        
        ITS_BOTTOM:
            MOV curr_dir, 1
        JMP NO_INPUT
    
    NO_INPUT: ;THIS LABEL TO SKIP THE LOGIC
        RET
CHECK_INPUT ENDP

UPDATE_SNAKE PROC
    MOV CL, snake_len
    DEC CX
    
    MOV SI, CX
    
    UPDATE_BODY_LOOP:
        MOV AL, snakeX[SI-1]
        MOV snakeX[SI], AL
        
        MOV AL, snakeY[SI-1]
        MOV snakeY[SI], AL
        
        DEC SI
        LOOP UPDATE_BODY_LOOP
    
    HEAD_DIRUCTION:
    CMP curr_dir, 1
    JE MOVE_RIGHT_UPDATE
    CMP curr_dir, 2
    JE MOVE_UP_UPDATE
    CMP curr_dir, 3
    JE MOVE_LEFT_UPDATE
    CMP curr_dir, 4
    JE MOVE_DOWN_UPDATE
    JMP END_UPDATE

    MOVE_RIGHT_UPDATE:
    INC snakeX[0]       
    JMP END_UPDATE

    MOVE_UP_UPDATE:
    DEC snakeY[0]       
    JMP END_UPDATE

    MOVE_LEFT_UPDATE:
    DEC snakeX[0]       
    JMP END_UPDATE

    MOVE_DOWN_UPDATE:
    INC snakeY[0]       
    JMP END_UPDATE

    END_UPDATE:
    
        RET
UPDATE_SNAKE ENDP

GENERATE_FOOD PROC
    MOV AH, 2Ch ;RAND FUNCTION
    INT 21h
    
    MOV AL, DL
    MOV BL, 78
    
    CALC_X_LOOP: ;INSTADE OF THE DIV INISTRUCTION
        CMP AL, BL
        JL DONE_X
        SUB AL, BL
        JMP CALC_X_LOOP
    
    DONE_X:
        INC AL
        MOV foodX, AL
    
    MOV AH, 2Ch
    INT 21h
    
    MOV AL, DL
    ADD AL, DH
    MOV BL, 23
    
    CALC_Y_LOOP:
        CMP AL, BL
        JL DONE_Y
        SUB AL, BL
        JMP CALC_Y_LOOP
    
    DONE_Y:
        INC AL
        MOV foodY, AL
    
    RET 
GENERATE_FOOD ENDP

COLLISION PROC


    RET
COLLISION ENDP

DRAW_SCREEN PROC
    
    RET
DRAW_SCREEN ENDP

END START
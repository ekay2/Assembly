; Emily Kay - ECE109
;tic tac toe program using the graphics display in pennsim
;Player X is first and will input a input between 0-8 and q (q will quit the program and 0-8 will represent a box on the board)
;switches player and continues until someone quits program by typing q 				
				
				.ORIG x3000

				AND R0, R0, #0
				AND R1, R1, #0
				AND R2, R2, #0
				AND R6, R6, #0

				JSR CLEAR			;wipe the board

				LD R0, HSTART		;R0 is (0,30)
				JSR DRAWH			;horizontal line
				LD R0, HEND			;(0,60)
				JSR DRAWH			;horizontal line

				AND R0, R0, #0
				AND R1, R1, #0
				AND R2, R2, #0

				LD R0, VSTART		;R0 is (30,0)
				JSR DRAWV
				LD R0, VEND			;(60,0)
				JSR DRAWV
	
	TURN		AND R1, R1, #0
				ADD R1, R6, #0		;check whose turn it is
				BRp GETMOVEO		;O's turn
				
				LEA R0, STRING1		;"X turn: "
				PUTS
				BRnzp SKIPSTRING
	GETMOVEO	LEA R0, STRING2		;"O turn: "			
				PUTS

	SKIPSTRING	JSR GETMOV
				ADD R0, R0, #0
				BRn SKIPSTRING		;input is -1 so get input again
				;Q IS CHECKED IN GETMOV

				JSR DRAWB

	PAUSE		HALT
				.END


STRING1	.STRINGZ "\nX move: "
STRING2 .STRINGZ "\nO move: " 		

HSTART		.FILL xCF00		
HEND		.FILL xDE00
VSTART		.FILL xC01E
VEND		.FILL xC03C

;SUBROUTINES: 

CLEAR
				ST R7, SUBROUTINE7
				LD R0, STARTCOORD	;starts at 0,0 
				LD R1, TOTAL		;128*124 = 15872 = 3E00 hex

	FILL		STR R2, R0, #0		;R0 address is now black
				ADD R0, R0, #1		;increase address of R0
				ADD R1, R1, #-1		;-1 from total
				BRp FILL		;stop when counter is 0 (entire board is filled)

				LD R7, SUBROUTINE7
				RET

	STARTCOORD 	.FILL xC000
	TOTAL 		.FILL x3E00

DRAWH
				ST R7, SUBROUTINE7
				LD R1, ROW		;line is 90 long
				LD R2, WHITE

	LINEH		STR R2, R0, #0		;assign address to color white
				ADD R0, R0, #1		;go to next address
				ADD R1, R1, -1		;- counter
				BRp LINEH		;if counter reaches 0, go next. otherwise draw 128 length line

				LD R7, SUBROUTINE7
				RET

DRAWV
				ST R7, SUBROUTINE7
				LD R1, COL		;R1 is 90 (length of line)
				LD R2, WHITE
				LD R3, BELOW		;for adding to go to the next line down 

	LINEV		STR R2, R0, #0		;assign address to color white
				ADD R0, R0, R3		;go to next vertical point
				ADD R1, R1, -1		;- counter		
				BRp LINEV

				LD R7, SUBROUTINE7
				RET

	WHITE		.FILL x7FFF
	ROW			.FILL #90
	COL			.FILL #90
	BELOW		.FILL #128

DRAWB
				ST R7, SUBROUTINE7

				LD R2, LOWEST		;temp store -48 (0) to r2 to set it to decimal value
				ADD R0, R2, R0		;change from ascii value to number value
				
				LEA R1, BLOCK0		;loads r1 with address of first block
				ADD R1, R1, R0		;changes block address according to user input
				LDR R1, R1, #0		;sets proper starting location into R1

				LDR R0, R1, #0		;should check if theres a point at the top left (x)
				BRnp TURN
				ADD R1, R1, #8		;increase address of R1 to a place where O is taking color temporarily
				LDR R0, R1, #0		;check if theres an o in the box
				BRnp TURN
				ADD R1, R1, #-8		;set R1 back to its starting position

				LD R2, LINE			;to count how many times the rows have gone down

				ADD R6, R6, #0		;check whose turn it is
				BRnp TURNO			;O's turn
				
				LD R4, XSHAPE		;set x info
				LD R5, XCOLOR
				BRnzp LOOP

	TURNO		LD R4, OSHAPE		;set o info
				LD R5, OCOLOR

	LOOP		LD R3, LINE			;initialize row counter
	DRAW		LDR R0, R4, #0		;R0 holds register of shape
				BRnz BLACK			;skip if the address read has a black color
				STR R5, R1, #0		;change R1 display (box) to R5 display (color)
	BLACK		ADD R1, R1, #1		;go to next address
				ADD R4, R4, #1		;go to next part of shape
				ADD R3, R3, #-1		;decrease row counter
				BRp DRAW
				LD R0, NEXTROW		
				ADD R1, R1, R0		;+108 to go to next row
				ADD R2, R2, #-1		;decrease col counter
				BRp LOOP

				AND R2, R2, #0		
				ADD R2, R6, #0		;checks whose turn it is
				BRz CHANGETURN
				ADD R6, R6, #-1		;if o, set to 0 to change
				BRnzp ENDTURN
	CHANGETURN	ADD R6, R6, #1 		;if x, set to 1 to change

	ENDTURN		BRnzp TURN

				LD R7, SUBROUTINE7
				RET

	LINE	.FILL #20
	NEXTROW	.FILL #108

	BLOCK0	.FILL xC285
	BLOCK1	.FILL xC2A3
	BLOCK2	.FILL xC2C1
	BLOCK3	.FILL xD185
	BLOCK4	.FILL xD1A3
	BLOCK5	.FILL xD1C1
	BLOCK6	.FILL xE085
	BLOCK7	.FILL xE0A3
	BLOCK8	.FILL xE0C1

	XSHAPE	.FILL xA000
	XCOLOR	.FILL x7FED
	OSHAPE	.FILL xA200
	OCOLOR	.FILL x03E0

GETMOV

				ST R7, SUBROUTINE7

	INPUT		AND R0, R0, #0
				AND R1, R1, #0
				AND R2, R2, #0
				GETC				;get user input
				OUT					;output prev input

				ADD R1, R0, #0		;temp store user input
				ADD R2, R1, #-10	;check if input was enter (ascii 10) without changing R0
				BRz INVALID
				
				AND R2, R2, #0
				GETC				;get next input (need to make sure to check first input if it is enter, else its an invalid entry)
				OUT

				ADD R2, R2, R0
				ADD R2, R2,	#-10	;if input 2 is enter, valid
				BRnp INVALID		;if input is not enter, set to -1
				
				LD R3, CHECKQ
				ADD R2, R1, R3		;check if input is q
				BRz PAUSE

				AND R2, R2, #0
				LD R3, LOWEST
				ADD R2, R1, R3		;checks if ascii value of input is 0 or above
				BRzp CHECKTOP		
				BRnzp INVALID		;invalid input

	CHECKTOP	AND R2, R2, #0
				LD R3, HIGHEST
				ADD R2, R1, R3		;checks if ascii value of input is 8 or below
				BRnz SET			;
				BRnzp INVALID		;invalid input

	INVALID		AND R0, R0, #0
				ADD R0, R0, #-1		;set R0 to -1 if input was enter
				BRnzp LEAVE

	SET			AND R0, R0, #0
				ADD R0, R0, R1
				
	LEAVE		LD R7, SUBROUTINE7
				RET

	LOWEST		.FILL #-48
	HIGHEST		.FILL #-56
	CHECKQ		.FILL #-113

SUBROUTINE7	.BLKW 1

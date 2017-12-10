;;===============================
;; Name: Naoto Abe
;;===============================

;@plugin filename=lc3_udiv vector=x80

;psuedocode
;GCD(a, b) {
;	 R0 = a; 		// a must be put in R0
; 	 R1 = b; 		// b must be put in R1R1 = b;
;	 UDIV(); 		// UDIV is a trap that divides and mods
; 	
;	 // R0 = a / b
; 	 // R1 = a % b
;
; 	 if(R1 == 0) {  // if((a % b) == 0)
; 	 	 return b;
; 	 } else {
; 	 return GCD(b, R1);
; 	 }
;}


.orig x3000

	; TODO: Setup GCD call with arguments A and B
    
    LD R6, STACK		;load address of stack into R6
    ADD R6, R6, -2		;make space for arguments 

  	LD R0, A
  	LD R1, B

  	STR R0, R6, 0		;store aguments into stack
  	STR R1, R6, 1	

    JSR GCD				;service call to GCD

    LDR R0, R6, 0
    ST  R0, ANSWER
    LD R6, STACK 		;place stack back to its STACK position

    HALT


A       .fill 15
B       .fill 5
ANSWER  .blkw 1
STACK   .fill xF000



GCD
	; TODO: Implement GCD here
	ADD R6, R6, -3		;add space for frame
	STR R7, R6, 1
	STR R5, R6, 0

	ADD R6, R6, -3		;add space to save registers to be used 
	STR R0, R6, 0
	STR R1, R6, 1
	STR R2, R6, 2
	LDR R5, R6, 2		;place frame pointer one slot above old FP

	LDR R0, R5, 4
	LDR R1, R5, 5
	TRAP x80			; R0 = a/b R1 = a%b
	ADD R1, R1, 0
	BRz DONE
	BRp RECURSE

	LDR R2, R5, 5		;R2 = b
	STR R2, R5, 3 
DONE
	LDR R0, R5, -2
	LDR R1, R5, -1
	LDR R2, R5, 0
	ADD R6, R5, 0		;sp = FP
	ADD R6, R5, 3
	LDR R7, R5, 2
	LDR R5, R5, 1
  RET 
RECURSE
	ADD R6, R6, -2		;make space for arguments 
	STR R1, R6, 1		;store R1 as second argument
	LDR R0, R5, 5
	STR R0, R6, 0		;store b as first argument 
	JSR GCD
	LDR R0, R6, 0
	STR R0, R5, 3
	BR DONE
.end
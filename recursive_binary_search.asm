;;===============================
;; Name: Naoto Abe
;;===============================
;@plugin filename=lc3_udiv vector=x80
;
;pseudocode
;
;int binSearch(int[] arr, int target, int start, int end) {
;   if (start >= end) {
;       return -1;
;   }
;
;   int middle = (start + end) / 2; // Use UDIV for division here
;   int val = arr[middle];
;
;   if (val == target) {
;       return middle;
;   } else if (val > target) {
;       return binSearch(arr, target, start, middle);
;   } else {
;       return binSearch(arr, target, middle+1, end);
;   }
;}

.orig x3000

;;=====================================
;; Call bin_search subroutine with correct arguments here
;;=====================================

    LD R6, STACK        ; Initialize stack

    ; TODO: Setup BINSEARCH call with argumuents arr, target, start, end
    
    ADD R6, R6, -4      ;make space for parameters
    LD  R0, ARR          ;store parameters into stack
    STR R0, R6, 0
    LD  R0, TARGET
    STR R0, R6, 1
    AND R0, R0, 0
    STR R0, R6, -2
    LD  R0, ARR_SIZE
    STR R0, R6, -3


    LD R0, BIN_SEARCH_ADDR
    JSRR R0             ; call BIN_SEARCH

    LDR R0, R6, 0
    STR R0, ANSWER
    LD  R6, STACK

    HALT

ARR                 .fill x4000
ARR_SIZE            .fill 9
TARGET              .fill 11
ANSWER              .blkw 1         ; Store ANSWER here
BIN_SEARCH_ADDR     .fill BIN_SEARCH
STACK               .fill xF000


.end
;;=====================================
;; The array to be searched
;;=====================================

.orig x4000
.fill 3
.fill 5
.fill 6
.fill 6
.fill 8
.fill 10
.fill 11
.fill 50
.fill 52

.end
;;=====================================
;; Implement your bin_search subroutine here
;;=====================================

.orig x5000
BIN_SEARCH
    ADD R6, R6, -3
    STR R7, R6, 1
    STR R5, R6, 0

    ADD R6, R6, -5      ;make space for arguments and saved registers
    ADD R5, R6, 4       ;point new FP
    STR R0, R6, 0       ;save registers to be used
    STR R1, R6, 1
    STR R2, R6, 2

    LDR R0, R5, 6       ;R0 = start
    LDR R1, R5, 7       ;R1 = end

    NOT R2, R1
    ADD R2, R2, 1       ;R2 = -end
    ADD R2, R1, R2      ;R2 = start - end 
    BRzp NOTFOUND

    ADD R0, R0, R1
    AND R1, R1, 0
    ADD R1, R1, 2
    TRAP x80            ;R0 = (start + end) / 2

    STR R0, R5, -1
    LDR R1, R5, 4       ;R1 = address of first element in array 
    ADD R1, R1, R0      ;R1 = address of array[middle]
    LDR R1, R1, 0       ;R1 = value of array[middle]
    STR R1, R5, 0       ;store value as argument 

    LDR R0, R5, 0       ;R0 = value
    LDR R1, R5, 5       ;R1 = target

    NOT R2, R1
    ADD R2, R2, 1
    ADD R2, R0, R2      ;R2 = value - target
    BRz FOUND 
    BRp LEFT
    BR  RIGHT

DONE 
    LDR R0, R5, -4
    LDR R1, R5, -3
    LDR R2, R5, -2
    ADD R6, R5, 0
    ADD R6, R5, 3
    LDR R7, R5, 2
    LDR R5, R5, 1
RET

LEFT
    ADD R6, R6, -4      ;make space for parameters
    LDR R0, R5, 4       ;store arguments
    STR R0, R6, 0
    LDR R0, R5, 5
    STR R0, R6, 1
    AND R0, R0, 0
    STR R0, R6, 2
    LDR R0, R5, -1
    STR R0, R6, 3
    
    JSR BINSEARCH
    
    LDR R0, R6, 0
    STR R0, R5, 3
    BR  DONE
RIGHT 
    ADD R6, R6, -4      ;make space for parameters
    LDR R0, R5, 4       ;R0 = arr
    STR R0, R6, 0       ;store arr
    LDR R0, R5, 5       ;R0 = target
    STR R0, R6, 1       ;store target
    LDR R0, R5, -1
    ADD R0, R0, 1       ;R0 =middle + 1
    STR R0, R6, 2       ;store middle + 1
    LDR R0, R5, 7       ;R0 = end 
    STR R0, R6, 3       ;store end
    
    JSR BINSEARCH
    
    LDR R0, R6, 0
    STR R0, R5, 3
    BR  DONE

.end
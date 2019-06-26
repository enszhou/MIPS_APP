.text
_start:
	lw $t1 0x1000($0)
	lw $t2 0x1004($0)
	
	beq $t1 $0 _check_mem
	
	andi $s0 $s0 0
	addi $s1 $s0 1

_loop:
	beq $t2 $0 _end
	beq $t1 $0 _t1_equal_0
	beq $t1 $t2 _end
	
	andi $t3 $t1 1
	andi $t4 $t2 1
	or $t5 $t3 $t4
	beq $t5 $0 _t1_t2_even

	beq $t3 $0 _t1_nt2_even
	beq $t4 $0 _nt1_t2_even
	
	slt $t6 $t1 $t2
	beq $t6 $0 _t1_large_t2
	
	sub $t2 $t2 $t1                      # t1 < t2
	beq $0 $0 _loop
	
	_t1_large_t2:
		sub $t1 $t1 $t2  # t1 > t2
		beq $0 $0 _loop
		
	

_t1_nt2_even:
	srlv $t1 $t1 $s1
	beq $0 $0 _loop

_nt1_t2_even:
	srlv $t2 $t2 $s1
	beq $0 $0 _loop

_t1_t2_even:
	addi $s0 $s0 1
	srlv $t1 $t1 $s1
	srlv $t2 $t2 $s1
	beq $0 $0 _loop


_t1_equal_0:
	add $t1 $t2 $0	
	
_end:
	sllv $t0 $t1 $s0
	sw $t0 0x1008($0)
	eret 

_check_mem:
	lw $t0 0($t2)
	sw $t0 0x1008($0)
	sw $t2 0x100C($0)
	eret
	
	
	
	
	
	
	
	
	
	
	
	
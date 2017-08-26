        
        .text                   
        .globl  main            
main:
        la      $t0,M1       
        lw      $t0,0($t0)     
        
        la      $t1,M2       
        lw      $t1,0($t1)  
        
        
        multu $t0,$t1 
	mfhi $s0  	# Result is 00000001 41EFF6DE
	mflo $s1  
	
	
	divu $t0,$t1  
	mfhi $s2  
	mflo $s3  

end:    jr       $ra

        .data                   
M1:     .word   0x61322 
M2:     .word   0x34ff 
                               
 

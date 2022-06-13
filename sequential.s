	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 11, 0	sdk_version 11, 0
	.globl	_MatMulSequential       ## -- Begin function MatMulSequential
	.p2align	4, 0x90
_MatMulSequential:                      ## @MatMulSequential
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movl	%ecx, -28(%rbp)
	movl	%r8d, -32(%rbp)
	movl	%r9d, -36(%rbp)
	movl	$0, -40(%rbp)
LBB0_1:                                 ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB0_3 Depth 2
                                        ##       Child Loop BB0_5 Depth 3
	movl	-40(%rbp), %eax
	cmpl	-32(%rbp), %eax
	jge	LBB0_12
## %bb.2:                               ##   in Loop: Header=BB0_1 Depth=1
	movl	$0, -44(%rbp)
LBB0_3:                                 ##   Parent Loop BB0_1 Depth=1
                                        ## =>  This Loop Header: Depth=2
                                        ##       Child Loop BB0_5 Depth 3
	movl	-44(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jge	LBB0_10
## %bb.4:                               ##   in Loop: Header=BB0_3 Depth=2
	xorps	%xmm0, %xmm0
	movss	%xmm0, -48(%rbp)
	movl	$0, -52(%rbp)
LBB0_5:                                 ##   Parent Loop BB0_1 Depth=1
                                        ##     Parent Loop BB0_3 Depth=2
                                        ## =>    This Inner Loop Header: Depth=3
	movl	-52(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jge	LBB0_8
## %bb.6:                               ##   in Loop: Header=BB0_5 Depth=3
	movq	-8(%rbp), %rax
	movl	-40(%rbp), %ecx
	imull	-28(%rbp), %ecx
	addl	-52(%rbp), %ecx
	movslq	%ecx, %rdx
	movss	(%rax,%rdx,4), %xmm0    ## xmm0 = mem[0],zero,zero,zero
	movq	-16(%rbp), %rax
	movl	-52(%rbp), %ecx
	imull	-28(%rbp), %ecx
	addl	-44(%rbp), %ecx
	movslq	%ecx, %rdx
	mulss	(%rax,%rdx,4), %xmm0
	addss	-48(%rbp), %xmm0
	movss	%xmm0, -48(%rbp)
## %bb.7:                               ##   in Loop: Header=BB0_5 Depth=3
	movl	-52(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -52(%rbp)
	jmp	LBB0_5
LBB0_8:                                 ##   in Loop: Header=BB0_3 Depth=2
	movss	-48(%rbp), %xmm0        ## xmm0 = mem[0],zero,zero,zero
	movq	-24(%rbp), %rax
	movl	-40(%rbp), %ecx
	imull	-36(%rbp), %ecx
	addl	-44(%rbp), %ecx
	movslq	%ecx, %rdx
	movss	%xmm0, (%rax,%rdx,4)
## %bb.9:                               ##   in Loop: Header=BB0_3 Depth=2
	movl	-44(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -44(%rbp)
	jmp	LBB0_3
LBB0_10:                                ##   in Loop: Header=BB0_1 Depth=1
	jmp	LBB0_11
LBB0_11:                                ##   in Loop: Header=BB0_1 Depth=1
	movl	-40(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -40(%rbp)
	jmp	LBB0_1
LBB0_12:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
.subsections_via_symbols

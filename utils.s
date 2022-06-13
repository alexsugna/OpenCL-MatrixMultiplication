	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 11, 0	sdk_version 11, 0
	.globl	_getKernelSource        ## -- Begin function getKernelSource
	.p2align	4, 0x90
_getKernelSource:                       ## @getKernelSource
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
	movq	$0, -8(%rbp)
	leaq	L_.str(%rip), %rdi
	leaq	L_.str.1(%rip), %rsi
	callq	_fopen
	movq	%rax, -24(%rbp)
	cmpq	$0, -24(%rbp)
	je	LBB0_4
## %bb.1:
	xorl	%eax, %eax
	movl	%eax, %esi
	movq	-24(%rbp), %rdi
	movl	$2, %edx
	callq	_fseek
	movq	-24(%rbp), %rdi
	movl	%eax, -28(%rbp)         ## 4-byte Spill
	callq	_ftell
	xorl	%ecx, %ecx
	movl	%ecx, %esi
	xorl	%edx, %edx
	movq	%rax, -16(%rbp)
	movq	-24(%rbp), %rdi
	callq	_fseek
	movq	-16(%rbp), %rdi
	movl	%eax, -32(%rbp)         ## 4-byte Spill
	callq	_malloc
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	LBB0_3
## %bb.2:
	movq	-8(%rbp), %rdi
	movq	-16(%rbp), %rdx
	movq	-24(%rbp), %rcx
	movl	$1, %esi
	callq	_fread
LBB0_3:
	movq	-24(%rbp), %rdi
	callq	_fclose
LBB0_4:
	movq	-8(%rbp), %rax
	addq	$32, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_random2Darray          ## -- Begin function random2Darray
	.p2align	4, 0x90
_random2Darray:                         ## @random2Darray
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$48, %rsp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	movl	-4(%rbp), %eax
	imull	-8(%rbp), %eax
	movl	%eax, -12(%rbp)
	movslq	-12(%rbp), %rcx
	shlq	$2, %rcx
	movq	%rcx, %rdi
	callq	_malloc
	movq	%rax, -24(%rbp)
	movl	$0, -28(%rbp)
LBB1_1:                                 ## =>This Inner Loop Header: Depth=1
	movl	-28(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jge	LBB1_4
## %bb.2:                               ##   in Loop: Header=BB1_1 Depth=1
	movl	-28(%rbp), %eax
	addl	$1, %eax
	cvtsi2ss	%eax, %xmm0
	movq	-24(%rbp), %rcx
	movslq	-28(%rbp), %rdx
	movss	%xmm0, (%rcx,%rdx,4)
## %bb.3:                               ##   in Loop: Header=BB1_1 Depth=1
	movl	-28(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -28(%rbp)
	jmp	LBB1_1
LBB1_4:
	movl	$0, -28(%rbp)
LBB1_5:                                 ## =>This Inner Loop Header: Depth=1
	movl	-28(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jge	LBB1_8
## %bb.6:                               ##   in Loop: Header=BB1_5 Depth=1
	movl	-28(%rbp), %eax
	movl	%eax, -40(%rbp)         ## 4-byte Spill
	callq	_rand
	movl	-12(%rbp), %ecx
	subl	-28(%rbp), %ecx
	movl	$2147483647, %edx       ## imm = 0x7FFFFFFF
	movl	%eax, -44(%rbp)         ## 4-byte Spill
	movl	%edx, %eax
	cltd
	idivl	%ecx
	addl	$1, %eax
	movl	-44(%rbp), %ecx         ## 4-byte Reload
	movl	%eax, -48(%rbp)         ## 4-byte Spill
	movl	%ecx, %eax
	cltd
	movl	-48(%rbp), %esi         ## 4-byte Reload
	idivl	%esi
	movl	-40(%rbp), %edi         ## 4-byte Reload
	addl	%eax, %edi
	movl	%edi, -32(%rbp)
	movq	-24(%rbp), %r8
	movslq	-32(%rbp), %r9
	cvttss2si	(%r8,%r9,4), %eax
	movl	%eax, -36(%rbp)
	movq	-24(%rbp), %r8
	movslq	-28(%rbp), %r9
	movss	(%r8,%r9,4), %xmm0      ## xmm0 = mem[0],zero,zero,zero
	movq	-24(%rbp), %r8
	movslq	-32(%rbp), %r9
	movss	%xmm0, (%r8,%r9,4)
	cvtsi2ssl	-36(%rbp), %xmm0
	movq	-24(%rbp), %r8
	movslq	-28(%rbp), %r9
	movss	%xmm0, (%r8,%r9,4)
## %bb.7:                               ##   in Loop: Header=BB1_5 Depth=1
	movl	-28(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -28(%rbp)
	jmp	LBB1_5
LBB1_8:
	movq	-24(%rbp), %rax
	addq	$48, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_zeros2Darray           ## -- Begin function zeros2Darray
	.p2align	4, 0x90
_zeros2Darray:                          ## @zeros2Darray
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	movl	-4(%rbp), %eax
	imull	-8(%rbp), %eax
	movl	%eax, -12(%rbp)
	movslq	-12(%rbp), %rcx
	shlq	$2, %rcx
	movq	%rcx, %rdi
	callq	_malloc
	movq	%rax, -24(%rbp)
	movl	$0, -28(%rbp)
LBB2_1:                                 ## =>This Inner Loop Header: Depth=1
	movl	-28(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jge	LBB2_4
## %bb.2:                               ##   in Loop: Header=BB2_1 Depth=1
	movq	-24(%rbp), %rax
	movslq	-28(%rbp), %rcx
	xorps	%xmm0, %xmm0
	movss	%xmm0, (%rax,%rcx,4)
## %bb.3:                               ##   in Loop: Header=BB2_1 Depth=1
	movl	-28(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -28(%rbp)
	jmp	LBB2_1
LBB2_4:
	movq	-24(%rbp), %rax
	addq	$32, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_print2Darray           ## -- Begin function print2Darray
	.p2align	4, 0x90
_print2Darray:                          ## @print2Darray
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	%edx, -16(%rbp)
	movl	$0, -20(%rbp)
LBB3_1:                                 ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB3_3 Depth 2
	movl	-20(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jge	LBB3_8
## %bb.2:                               ##   in Loop: Header=BB3_1 Depth=1
	movl	$0, -24(%rbp)
LBB3_3:                                 ##   Parent Loop BB3_1 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movl	-24(%rbp), %eax
	cmpl	-16(%rbp), %eax
	jge	LBB3_6
## %bb.4:                               ##   in Loop: Header=BB3_3 Depth=2
	movq	-8(%rbp), %rax
	movl	-16(%rbp), %ecx
	imull	-20(%rbp), %ecx
	addl	-24(%rbp), %ecx
	movslq	%ecx, %rdx
	movss	(%rax,%rdx,4), %xmm0    ## xmm0 = mem[0],zero,zero,zero
	cvtss2sd	%xmm0, %xmm0
	leaq	L_.str.2(%rip), %rdi
	movb	$1, %al
	callq	_printf
## %bb.5:                               ##   in Loop: Header=BB3_3 Depth=2
	movl	-24(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -24(%rbp)
	jmp	LBB3_3
LBB3_6:                                 ##   in Loop: Header=BB3_1 Depth=1
	leaq	L_.str.3(%rip), %rdi
	movb	$0, %al
	callq	_printf
## %bb.7:                               ##   in Loop: Header=BB3_1 Depth=1
	movl	-20(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -20(%rbp)
	jmp	LBB3_1
LBB3_8:
	leaq	L_.str.3(%rip), %rdi
	movb	$0, %al
	callq	_printf
	addq	$32, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4               ## -- Begin function allClose
LCPI4_0:
	.long	2147483647              ## float NaN
	.long	2147483647              ## float NaN
	.long	2147483647              ## float NaN
	.long	2147483647              ## float NaN
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_allClose
	.p2align	4, 0x90
_allClose:                              ## @allClose
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	%rdi, -16(%rbp)
	movq	%rsi, -24(%rbp)
	movl	%edx, -28(%rbp)
	movl	%ecx, -32(%rbp)
	movss	%xmm0, -36(%rbp)
	movl	$0, -48(%rbp)
LBB4_1:                                 ## =>This Loop Header: Depth=1
                                        ##     Child Loop BB4_3 Depth 2
	movl	-48(%rbp), %eax
	cmpl	-28(%rbp), %eax
	jge	LBB4_10
## %bb.2:                               ##   in Loop: Header=BB4_1 Depth=1
	movl	$0, -52(%rbp)
LBB4_3:                                 ##   Parent Loop BB4_1 Depth=1
                                        ## =>  This Inner Loop Header: Depth=2
	movl	-52(%rbp), %eax
	cmpl	-32(%rbp), %eax
	jge	LBB4_8
## %bb.4:                               ##   in Loop: Header=BB4_3 Depth=2
	movq	-16(%rbp), %rax
	movl	-48(%rbp), %ecx
	imull	-32(%rbp), %ecx
	addl	-52(%rbp), %ecx
	movslq	%ecx, %rdx
	movss	(%rax,%rdx,4), %xmm0    ## xmm0 = mem[0],zero,zero,zero
	movss	%xmm0, -40(%rbp)
	movq	-24(%rbp), %rax
	movl	-48(%rbp), %ecx
	imull	-32(%rbp), %ecx
	addl	-52(%rbp), %ecx
	movslq	%ecx, %rdx
	movss	(%rax,%rdx,4), %xmm0    ## xmm0 = mem[0],zero,zero,zero
	movss	%xmm0, -44(%rbp)
	movss	-40(%rbp), %xmm0        ## xmm0 = mem[0],zero,zero,zero
	subss	-44(%rbp), %xmm0
	movaps	LCPI4_0(%rip), %xmm1    ## xmm1 = [NaN,NaN,NaN,NaN]
	pand	%xmm1, %xmm0
	ucomiss	-36(%rbp), %xmm0
	jb	LBB4_6
## %bb.5:
	movl	$0, -4(%rbp)
	jmp	LBB4_11
LBB4_6:                                 ##   in Loop: Header=BB4_3 Depth=2
	jmp	LBB4_7
LBB4_7:                                 ##   in Loop: Header=BB4_3 Depth=2
	movl	-52(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -52(%rbp)
	jmp	LBB4_3
LBB4_8:                                 ##   in Loop: Header=BB4_1 Depth=1
	jmp	LBB4_9
LBB4_9:                                 ##   in Loop: Header=BB4_1 Depth=1
	movl	-48(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -48(%rbp)
	jmp	LBB4_1
LBB4_10:
	movl	$1, -4(%rbp)
LBB4_11:
	movl	-4(%rbp), %eax
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"kernels.cl -save-temp"

L_.str.1:                               ## @.str.1
	.asciz	"rb"

L_.str.2:                               ## @.str.2
	.asciz	"%f "

L_.str.3:                               ## @.str.3
	.asciz	"\n"

.subsections_via_symbols

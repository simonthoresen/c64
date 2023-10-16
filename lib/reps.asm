.macro assert_immediate_arg(arg) 
{
	.if (arg.getType() != AT_IMMEDIATE)	{
		.error "The argument must be immediate!" 
	}
}

.pseudocommand asl x 
{
	:assert_immediate_arg(x)
	.for (var i = 0; i < x.getValue(); i++) {
		asl
	}
}

.pseudocommand lsr x 
{
	:assert_immediate_arg(x)
	.for (var i = 0; i < x.getValue(); i++) {
		lsr
	}
}

.pseudocommand rol x 
{
	:assert_immediate_arg(x)
	.for (var i = 0; i < x.getValue(); i++) {
		rol
	}
}

.pseudocommand ror x 
{
	:assert_immediate_arg(x)
	.for (var i = 0; i < x.getValue(); i++) {
		ror
	}
}

.pseudocommand pla x 
{
	:assert_immediate_arg(x)
	.for (var i = 0; i < x.getValue(); i++) {
		pla
	}
}

.pseudocommand nop x 
{
	:assert_immediate_arg(x)
	.for (var i = 0; i < x.getValue(); i++) {
		nop
	}
}

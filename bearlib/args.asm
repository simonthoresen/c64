.function _hi_byte(arg) 
{
    .if (arg.getType() == AT_IMMEDIATE) {
        .return CmdArgument(arg.getType(), >arg.getValue())
    }
    .return CmdArgument(arg.getType(), arg.getValue()+1)
}

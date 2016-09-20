/* creates section containing executable code */
.section INTERRUPT_VECTOR, "x"
/* exporting the name to the linker */
.global _Reset
_Reset:
    B ResetHandler /* Reset */
    B . /* Undefined */
    B . /* SWI */
    B . /* Prefetch Abort */
    B . /* Data Abort */
    B . /* reserved */
    B . /* IRQ */
    B . /* FIQ */

ResetHandler:
    /* stack_top will be defined during linking */
    ldr x30,=stack_top
    mov sp, x30
    /* branch and save the return address in link register */
    bl c_entry
    b .

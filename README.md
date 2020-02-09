# Compute x^n

Calculates x^n using a recursive function, where x and n are passed-by-value through the stack (not via registers) to the function, and the returned value is stored in the stack just above the parameter. Creates a local variable (called y) on the stack and saves the value of y on the stack. Once the control is completely returned back from the function (i.e., after calculating x^n), the returned value is stored in a local variable (called result) in the main function.

**report3.pdf** illustrates the structure of the stack frame.

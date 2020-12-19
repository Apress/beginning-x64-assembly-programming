# Errata for *Beginning x64 Assembly Programming*

In **Chapter 11**:
 
The floating point "division" section of fcalc.asm populates 3 xmm registers and the format string contains 3 "%f" placeholders.  However, before calling printf, rax is set to 1 (rather than three)

***

In **Chapter 12**:
 
In the "main:" section of function.asm (Listing 12-1), xmm1 is populated right before calling printf, but not used.  That is, the the format string only takes one float (xmm0), so xmm1 is set needlessly.

***

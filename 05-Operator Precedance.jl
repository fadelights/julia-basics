using Markdown

md"""

# Operator Precedence and Associativity

Julia applies the following order and associativity of operations, from highest precedence to lowest:

| Category       | Operators                                                                                         | Associativity              |
|:-------------- |:------------------------------------------------------------------------------------------------- |:-------------------------- |
| Syntax         | `.` followed by `::`                                                                              | Left                       |
| Exponentiation | `^`                                                                                               | Right                      |
| Unary          | `+ - √`                                                                                           | Right[^1]                  |
| Bitshifts      | `<< >> >>>`                                                                                       | Left                       |
| Fractions      | `//`                                                                                              | Left                       |
| Multiplication | `* / % & \ ÷`                                                                                     | Left[^2]                   |
| Addition       | `+ - \| ⊻`                                                                                        | Left[^2]                   |
| Syntax         | `: ..`                                                                                            | Left                       |
| Syntax         | `\|>`                                                                                             | Left                       |
| Syntax         | `<\|`                                                                                             | Right                      |
| Comparisons    | `> < >= <= == === != !== <:`                                                                      | Non-associative            |
| Control flow   | `&&` followed by `\|\|` followed by `?`                                                           | Right                      |
| Pair           | `=>`                                                                                              | Right                      |
| Assignments    | `= += -= *= /= //= \= ^= ÷= %= \|= &= ⊻= <<= >>= >>>=`                                            | Right                      |

You can also find the numerical precedence for any given operator via the built-in function `Base.operator_precedence`, where higher numbers take precedence:

    ```
    julia> Base.operator_precedence(:+), Base.operator_precedence(:*), Base.operator_precedence(:.)
    (11, 12, 17)
    
    julia> Base.operator_precedence(:sin), Base.operator_precedence(:+=), Base.operator_precedence(:(=))  # (Note the necessary parens on `:(=)`)
    (0, 1, 1)
    ```
    
A symbol representing the operator associativity can also be found by calling the built-in function `Base.operator_associativity`.

[^1]:
    The unary operators `+` and `-` require explicit parentheses around their argument 
    to disambiguate them from the operator `++`, etc. Other compositions of unary operators are parsed with
    right-associativity, e. g., `√√-a` as `√(√(-a))`.

[^2]:
    The operators `+`, `++` and `*` are non-associative. `a + b + c` is parsed as `+(a, b, c)` not `+(+(a, b),c)`.
    However, the fallback methods for `+(a, b, c, d...)` and `*(a, b, c, d...)`
    both default to left-associative evaluation.

"""

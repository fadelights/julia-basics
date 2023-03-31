x = 2
y = 7

# unary minus
-x

# power
x ^ y

# integer divide (`x / y`, truncated to an integer)
x ÷ y

# inverse divide (equivalent to `y / x`)
x \ y

# negation
!false

# and/or
true && false
true || false

# bitwise operators
a = Int8(+7)
b = Int8(-7)

bitstring(a)
bitstring(b)
bitstring(~a) # bitwise not
bitstring(a & b) # bitwise and
bitstring(a | b) # bitwise or
bitstring(a ⊻ b) # bitwise xor
bitstring(b >>> 1) # logical shift right
bitstring(b >> 1) # arithmetic shift right
bitstring(b << 1) # logical/arithmetic shift left

#= every binary arithmetic and bitwise operator also has an updating version
that assigns the result of the operation back into its left operand =#
x = 12
x <<= 1
x >>= 2
x ^= 2

#= for *every* binary operation like `^`, there is a corresponding "dot" operation `.^`
that is *automatically* defined to perform `^` element-by-element on arrays =#
A = [1, 2, 3]
B = [4, 5, 6]

A + B
A .+ 100

#= `X .^ Y` is parsed as the "dot" call `(^).(X, Y)`
which performs a broadcast operation =#
2 .* A.^2 .+ sin.(A)

# use the `@.` macro for a simpler syntax
@. 2A^2 + sin(A)

# dot calls are also *automatically* defined for functions
# every function `f(x)` has a corresponding dot call `f.(X)`
a = π
A = [0, π/2, π, 3π/2, 2π]

cos(a)
cos.(A)

# use `Ref` for a function argument to be treated as scalar
f(X, y) = sum(X) + y
f([1, 2], 3)
# f.([1, 2], [3, 4, 5])  # ERROR: DimensionMismatch...
f.(Ref([1, 2]), [3, 4, 5])  # correct way. the first argument is not broadcasted

# `NaN` is never equal to itself
# `isequal` can be used in such cases
NaN == NaN
[1, NaN] == [1, NaN]
missing == missing

isequal(NaN, NaN)
isequal([1, NaN], [1, NaN])
isequal(missing, missing)

# subtle comparisons for signed zeros
0.0 == -0.0
0.0 < -0.0
isequal(0.0, -0.0)

# comparisons can be chained
1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5
1 .< [1, 2, 3, 4, 5] .<= 3

# the notation `T(x)` or `convert(T,x)` converts `x` to a value of type `T`
Float16(122)
Int16(122.1) # InexactError

# rounding functions
x = 2.5
y = 3.5

round(x), round(y)
floor(x), floor(y)
ceil(x), ceil(y)
trunc(x), trunc(y)

# mathematical functions
using Markdown

md"""
Julia provides a comprehensive list of mathematical functions,
including categories such as:

- Rounding functions: `round`, `floor`, `ceil`, ...
- Division functions: `fld`, `cld`, `mod`, `gcd`, `lcm`, ...
- Sign and absolute value functions: `abs`, `abs2`, `flipsign`, `copysign`, ...
- Powers, logs and roots: `sqrt`, `cbrt`, `hypot`, `exp`, `log`, `log2`, ...
- Trigonometric and hyperbolic functions: `sin`, `cot`, `sec`, `sinc`, `atan`, `acoth`, `sinpi`, `sind` (degree based sine), ...

Many other special mathematical functions are provided by the package `SpecialFunctions.jl`.
"""

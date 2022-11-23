# numeric limits
for T in [Int8, Int16, Int32, Int64, Int128, UInt8, UInt16, UInt32, UInt64, UInt128]
    println("$(rpad(T,7)): [$(typemin(T)), $(typemax(T))]")
end

# checking for a specific type
typeof('a') == Char
'a' isa Char
isa('a', Char)

# 64-bit `Int64` is the default on x64 systems
Sys.WORD_SIZE
typeof(1)

# unsigned integers are input and output with hex values
x = 0x110F
typeof(x)

# binary and octal literals are also supported
x = 0b0101
typeof(x)

x = 0o77
typeof(x)

# negative sign in hex/octal/binary values results in 2's complement of the value
-0x2
-0x0002

#= exceeding the maximum representable value
of a given type results in a wraparound behavior =#
x = typemax(Int128)
x + 1
x + 1 == typemin(Int128)

# examples of floating-point numbers
1.0
1.
0.5
.5
-1.23
1e10
2.5e-4

# the above results are all `Float64` values
# literal `Float32` values can be entered by writing an `f` in place of `e`
x = 0.5f0
typeof(x)

#= hexadecimal floating-point literals are also valid,
but only as `Float64` values, with `p` preceding the base-2 exponent =#
0x1p0
0x1.8p3

# the underscore `_` can be used as digit separator
10_000, 0.000_000_005, 0xdead_beef, 0b1011_0010

# floating-point zeros
0.0 == -0.0
bitstring(0.0)
bitstring(-0.0)

# special float values
# Float16, Float32, Float64
Inf16, Inf32, Inf # a value greater than all finite floating-point values
-Inf16, -Inf32, -Inf # a value less than all finite floating-point values
NaN16, NaN32, NaN # a value not equal to any floating-point value (including itself)

1 / Inf
1 / 0
-5 / 0
0 / 0
10 + Inf
Inf - Inf

# `false` acts as a "strong zero"
0 * Inf
false * Inf

#= the `eps()` function:
`eps` gives the distance between 1.0 and
the next larger representable floating-point value =#
eps(Float16)
eps(Float32)
eps(Float64)

#= the distance between two adjacent representable floating-point numbers
is not constant, but is smaller for smaller values and larger for larger values =#
eps(1e+27)
eps(1.)
eps(0.0)
eps(1e-37)

#= `nextfloat` and `prevfloat` are used to represent the next smallest
representable value =#
x = 1.0
nextfloat(x)
prevfloat(x)

bitstring(x)
bitstring(nextfloat(x))
bitstring(prevfloat(x))

# arbitrary precision arithmetic
BigInt(typemax(Int128)) + 1
BigFloat(2.0 ^ 66) / 3
big"123456789012345678901234567890" + 1

#= type promotion between the primitive types above and `BigInt`/`BigFloat`
is not automatic and must be explicitly stated =#
typemin(Int128) - 1

# Julia supports numeric literal coefficients
x = 3
2x^2 + 3x - 1
2(x-1)^2 - 3(x-1) + 1

#= the precedence of numeric literal coefficients used for implicit multiplication
is higher than other binary operators such as multiplication, exponentation, etc =#
2^3x == 2^(3x)
1 / 2im == 1 / (2im)
6 // 2(2 + 1) == 6 // (2(2 + 1))

#= the precedence of numeric literal coefficients is slightly
lower than that of unary operators such as negation =#
-2x == (-2) * x
√2x == (√2) * x

#=
Expressions starting with 0x/0o/0b are always hexadecimal/octal/binary literals
Expressions starting with a numeric literal followed by `e` or `E` are always floating-point literals
Expressions starting with a numeric literal followed by `f` are always 32-bit floating-point literals
=#

#= Julia provides functions which return literal 0 and 1
corresponding to a specified type or the type of a given variable =#
zero(Float32)
zero(Bool)
one(Int16)
one(BigFloat)

# converting strings to numbers
parse(Int8, "16")
parse(BigInt, "123456789"^5)

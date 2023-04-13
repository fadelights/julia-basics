using Markdown

md"""
There are no `pass` keywords in Julia.
"""


md"""
In order to keep your previously installed packages
when upgrading from version 1.x to 1.x′, copy the `Project.toml`
file from the 1.x folder to 1.x′; then enter the REPL Pkg mode
and type `instantiate`.
"""


#= `while` and `try-catch` blocks define
their own local scopes; therefore, in order
to use a variable -- defined in the `Main` scope --
in a while statements, we will have to use the
`global` keyword =#
x = 0

# while x < 10
#     x += 2  # ERROR: UndefVarError...
#     println(x)
# end

while x < 10
    global x += 2  # Correct
    println(x)
end

#= since functions have their own local scope,
we do not need to use the `global` keyword inside
`while` blocks of a function =#
function f(x)
    while x < 10
        x += 2
        println(x)
    end
end


f(0)


md"""Objects are ALWAYS passed by reference to Julia functions."""


#= `floor` division can have different results
for negative numbers depending on the type of
operators used =#
-14 / 5
-14 ÷ 5
-14 ÷ 5.0
floor(-14 / 5)
trunc(-14 / 5)


#= in Python, the `%` sign is the modulus operator,
whereas in Julia, it is the remainder =#
-14 % 5
rem(-14, 5)
mod(-14, 5)


#= regular debugging with the `println` function
can get cumbersome pretty quickly; use the @show
macro instead =#
x, y, z = 11, 12, 13

# the foolish way
# println("x = $x")
# println("y = $y")
# println("z = $z")

# the way of the wise
@show x y z


#= some unicode characters use up multiple bytes,
and since indexing using the [] notation will
essentially move the pointer to the designated
byte, some indices may be invalid =#
fruits = "🍌 🍎 🍊"
length(fruits)
sizeof(fruits)

fruits[1]
# fruits[2]  # ERROR: StringIndexError...
fruits[nextind(fruits, 1)]  # correct


#= `X += Y` (and simialr operators)
allocate new memory for the left-hand side,
even when both `X` and `Y` are arrays. use `X .+= Y` for
in-place addition (and similar operations) =#
X = [1 2 3]
Y = [4 5 6]
X += Y  # new memory allocated for X
X .+= Y  # in-place addition


#= Julia does not provide a direct method of deleting
variables from memory, like the `clear` function in MATLAB,
but you can assign `nothing` to a sizeable variable,
essentially freeing the memory it has occupied, while
also allowing it to be collected by the garbage collector
on its next run.

the garbage collector may also be invoked manually via
a call to `GC.gc()` =#
A = rand(Int128, (10_000, 10_000))
sizeof(A) / 1e9  # size in GB

A = nothing
sizeof(A)
GC.gc()


#= in most Python modules, there exists a famous block
of code like so

```
if __name__ == "__main__":
    # do stuff
```

this is meant to add extra functionality to a script
in case it is run directly (and not via an import).
in Julia, the same thing can be accomplished as shown below
=#
if abspath(PROGRAM_FILE) == @__FILE__
    # do stuff
end


#= splatting vs slurping: a short story =#
#= "slurping"
In the context of function *definitions*,
the `...` operator is used to combine many
different arguments into a single argument =#
function printargs(args...)
    println(typeof(args))
    for (i, arg) in enumerate(args)
        @show i, arg
    end
end


printargs('j', 'a', 'n', 'e')

#= "splatting"
In the context of a function *call*,
the `...` operator is used to cause a single
function argument to be split apart into
many different arguments when used =#
function triplet(x, y, z)
    x * y * z
end


params = [2, 3, 7]
triplet(params...)


# `collect` is much faster than splatting
@time [1:10_000_000...]
@time collect(1:10_000_000)


#= one cannot simply add CTRL-C handling
to a Julia script =#


#= Julia's `run` function launches external
programs directly, without invoking an
operating-system shell (unlike the `system("...")`
function in other languages like Python, R, or C).
that means that `run` does not perform
wildcard expansion of `*` ("globbing"),
nor does it interpret shell pipelines
like `|` or `>`

you can still do globbing and pipelines
using Julia features, however; e.g. using
the built-in `pipeline` function or the
Glob.jl package =#
url = "https://www.gutenberg.org/cache/epub/1524/pg1524.txt"
run(`wget "$url" -O "hamlet.txt"`)

run(pipeline(`cat hamlet.txt`, `grep "swag"`, "swag.txt"))
run(pipeline("swag.txt", `cat`))


#= the `=` operator always returns the right-and side =#
function threeint()
    x::Int = 3.0
    x
end


function threefloat()
    x::Int = 3.0
end


threeint()
threefloat()


#= type-stability refers to the property that
the type of the output is predictable from
the "types" of the inputs.
in particular, it means that the type of the
output cannot vary depending on the "values"
of the inputs

type-instability incurs significant runtime
costs and must be avoided

the following function is type-unstable =#
function unstable(flag::Bool)
    if flag
        return 1
    else
        return 1.0
    end
end


#= use `methodswith` to get a list of all
methods accepting as input a specific type

NOTE: available only in interactive sessions =#
methodswith(Vector, Base)


#= "value" and "object" are two different notions.
two variables may have the same value but not be the
same object use === or \equiv TAB to check for identity =#
a = "banana"
b = "banana"
a === b

a = [1, 2, 3]
b = [1, 2, 3]
a === b

c = a
a === a

d = copy(a)
a === d


#= aliasing vs. copying vs. deep copying =#
a = BigInt(1)
b = BigInt(1)
a == b
a === b  # `BigInt` instances are not the same object

# aliasing, no copy
A = BigInt.([1, 2, 3])
B = A
A == B
A === B
A[1] == B[1]
A[1] === B[1]

# shallow copy
B = copy(A)
A == B
A === B
A[1] == B[1]
A[1] === B[1]  # the elements have not been copied, only aliased

# deep copy
B = deepcopy(A)
A == B
A === B
A[1] == B[1]
A[1] === B[1]  # the elements have also been copied


md"""
Types in module `Main` cannot be redefined.
wrap them inside a module and re-include that
module instead.
"""


md"""
The only difference between `using` and `import`
is that with `using` you need to say `function Foo.bar(...)`
to extend module `Foo`'s function `bar` with a new method,
but with `import Foo.bar`, you only need to say
`function bar(...)` and it automatically extends
module `Foo`'s function `bar`.

The reason this is important is that
you don't want to accidentally extend a function
that you didn't know existed, because that could
easily cause a bug. This is most likely to happen
with a method that takes a common type like a
string or integer, because both you and the other
module could define a method to handle such a
common type. If you use `import`, then you'll
replace the other module's implementation of
`bar(s::AbstractString)` with your new implementation,
which could easily do something completely different
(and break all/many future usages of the other
functions in module `Foo` that depend on calling `bar`)
"""


md"""
Sometimes, it may be inefficient to compute two related but different
values using different functions, when the whole process can be
combined into one. This section provides some of Julia's efficient
implementations of common related operations.
"""


# get the quotient and remainder of a division
q, r = divrem(7, 3)

# get the min and max values of a sequence
x = rand(1:1000, 100)
min, max = extrema(x)

# multi-value assignment
a, b, c = 10, 1e2, 1e3, 1e4  # extra values get discarded
a, b, c

a, b, c... = 10, 1e2, 1e3, 1e4  # extra values kept!
a, b, c

#= `mapreduce(f, op, itr)` is equivalent to
`reduce(op, map(f, itr))` but faster =#
mapreduce(x->x^2, +, 1:3)  # == 1 + 4 + 9

#= a more advanced example:
this example takes a vector of strings and converts
it to a numerical matrix =#
str_matrix = ["1 2 3"; "4 5 6"; "7 8 9"]
int_matrix = mapreduce(hcat, str_matrix) do x
    parse.(Int, split(x))
end'  # matrices are column-based in Julia, ' transposes the result

using Markdown

md"""

Julia's type system is dynamic, but gains some of the advantages
of static type systems by making it possible to indicate that
certain values are of specific types. This can be of great assistance
in generating efficient code, but even more significantly, it allows
method dispatch on the types of function arguments to be deeply
integrated with the language.

Adding annotations serves three primary purposes:
to take advantage of Julia's powerful multiple-dispatch mechanism,
to improve human readability,
and to catch programmer errors.

"""


md"""

The `::` operator can be used to attach type annotations
to expressions and variables in programs.
There are two primary reasons to do this:

1. As an assertion to help confirm that your program
    works the way you expect,
1. To provide extra type information to the compiler,
    which can then improve performance in some cases

One particularly distinctive feature of Julia's type system
is that concrete types may not subtype each other: all
concrete types are final and may only have abstract types
as their supertypes.

"""


#= when appended to an expression computing a value,
the `::` operator is read as "is an instance of".
it can be used anywhere to assert that the value of
the expression on the left is an instance of
the type on the right

this allows a type assertion to be attached
to any expression in-place =#
(1 + 2)::Int32
(1 + 2)::Int
(1 + 2)::Number

(1 + 2) isa Int32
(1 + 2) isa Int
(1 + 2) isa Number

#= when appended to a variable on the left-hand side
of an assignment, or as part of a `local` declaration,
the `::` operator declares the variable to always
have the specified type, like a type declaration
in a statically-typed language such as C

every value assigned to the variable will be
converted to the declared type using `convert`

this feature is useful for avoiding performance
"gotchas" that could occur if one of the assignments
to a variable changed its type unexpectedly =#
x::Int8 = 100
typeof(x)
x isa Int8
x isa Int  # Int is an alias for Int64
x isa Number

# type declarations cannot be used in the global scope
z = begin
    local y::Float16
    y = 12
    y
end

y
z

#= declarations can also be attached to function definitions,
this forces the return value to be converted to the specified
type =#
function sinc(x)::Float64
    x == 0 && return 1
    sin(π*x)/π*x
end


typeof(sinc(0))


#################### Abstract Types ####################
md"""
Abstract types cannot be instantiated, and serve only
as nodes in the type graph, thereby describing sets of
related concrete types: those concrete types which are
their descendants.

Recall that we introduced a variety of concrete types of
numeric values; e.g. `Int8`, `Int16`, `Int32`, `Int64`,
and `Int128` all have in common that they are
signed integer types.

It is common for a piece of code to make sense, for example,
only if its arguments are some kind of integer, but not really
depend on what particular kind of integer. For example,
the greatest common denominator algorithm works for all
kinds of integers, but will not work for floating-point
numbers. Abstract types allow the construction of a hierarchy
of types, providing a context into which concrete types
can fit. This allows you, for example, to easily program
to any type that is an integer, without restricting
an algorithm to a specific type of integer.

Abstract types are declared using the `abstract type` keyword.
The general syntaxes for declaring an abstract type are:

```
abstract type «name» end
abstract type «name» <: «supertype» end
```

The `<:`indicates that the newly declared abstract type
is a subtype of this "parent" type.

Some of Julia's abstract types that make up its numerical hierarchy:

```
abstract type Number end  # direct child of `Any`
abstract type Real          <: Number end
abstract type AbstractFloat <: Real end
abstract type Integer       <: Real end
abstract type Signed        <: Integer end
abstract type Unsigned      <: Integer end
```
"""

#= the `<:` symbol is a boolean operator, returning
`true` iff a type is a subtype of another type.

correspondingly, there exists a `>:` operator that
checks for being a supertype =#
Int8 <: Integer
Int8 <: Int
Number >: Float64

# we can check the super/sub-types of a `DataType`
supertype(String)
supertype(AbstractString)

subtypes(Number)
subtypes(Integer)

md"""
Abstract types allow programmers to write generic functions
that can later be used as the default method by many
combinations of concrete types.

An important point to note is that there is no loss in performance
if the programmer relies on a function whose arguments are
abstract types, because it is recompiled for each tuple of
argument concrete types with which it is invoked.
(There may be a performance issue, however, in the case of
function arguments that are containers of
abstract types.)
"""

function sadden(s::AbstractString)
    lowercase(strip(!isletter, s)) * "... :("
end


s = "Hey! Boy!"
typeof(s)

s′ = view(s, 1:4)
typeof(s′)

sadden(s)
sadden(s′)


#################### Primitive Types ####################
md"""
**Warning!**

It is almost always preferable to wrap an existing
primitive type in a new composite type than to define
your own primitive type.
"""

md"""
A primitive type is a concrete type whose data consists
of plain old bits. Classic examples of primitive types
are integers and floating-point values. Unlike most
languages, Julia lets you declare your own primitive types,
rather than providing only a fixed set of built-in ones.
In fact, the standard primitive types are all defined in
the language itself:

```
primitive type Bool <: Integer 8 end
primitive type Char <: AbstractChar 32 end

primitive type Int8    <: Signed   8 end
primitive type UInt8   <: Unsigned 8 end
primitive type Int16   <: Signed   16 end
primitive type UInt16  <: Unsigned 16 end
...
```

The general syntaxes for declaring a primitive type are:

```
primitive type «name» «bits» end
primitive type «name» <: «supertype» «bits» end
```

Currently, only sizes that are multiples of 8 bits
are supported and you are likely to experience LLVM
bugs with sizes other than that. Therefore, boolean values,
although they really need just a single bit,
cannot be declared to be any smaller than eight bits.

The types `Bool`, `Int8` and `UInt8` all have identical
representations: they are eight-bit chunks of memory.
Since Julia's type system is nominative, however,
they are not interchangeable despite having identical structure.
This is important: if structure determined type,
which in turn dictates behavior, then it would be impossible
to make `Bool` behave any differently than `Int8` or `UInt8`.
"""


#################### Composite Types ####################
abstract type AbstractPoint end

md"""
A composite type is a collection of named fields,
an instance of which can be treated as a single value
"""
struct Point <: AbstractPoint
    x::Float64
    y::Float64
    label  # typing is optional, defaults to `Any`
end

#= constructor syntax to instantiate.
typed values will try to be converted using the `convert` function =#
p1 = Point(big"7", big"13", 42)
p2 = Point(1., .2, Char(42))

p1.y
p2.label

typeof.([p1, p2])

md"""
The (mutable or immutable) attributes of an immutable struct
**cannot** be "reassigned".

The mutable attributes of an immutable struct can, however,
be "updated".

When we define a mutable struct, we are allowing for the
reassignment of its attributes.
"""
p = Point(0, 0, ['o', 'r', 'i', 'g', 'i', 'n'])
# p.x = 10  # ERROR: ...
# p.label = ['b', 'o', 'b']  # ERROR: ...
p.label[1:3] = ['O', 'R', 'I']  # vectos are mutable


mutable struct MPoint <: AbstractPoint
    x::Float64
    y::Float64
end

mp = MPoint(0, 0)
mp.x = 10


function dist(p1::AbstractPoint, p2::AbstractPoint)
    (p1.x - p2.x)^2 + (p1.y - p2.y)^2 |> sqrt
end

dist(Point(0, 3, "demo"), MPoint(4, 0))


# useful methods
fieldnames(Point)

p isa Point
p isa MPoint
p isa AbstractPoint

# mutable structs can have immutable fields too (though not recommended)
mutable struct HalfMPoint <: AbstractPoint
    x::Float64
    const y::Float64
end

hmp = HalfMPoint(12, 34)
hmp.x = 10
# hmp.y = 20  # ERROR: ...


#################### Type Union ####################
md"""A type union is a special abstract type which
includes as objects all instances of any of its
argument types, constructed using the special `Union` keyword."""
IntOrString = Union{Int, AbstractString}

1 isa IntOrString
.1 isa IntOrString
"Hell" isa IntOrString


function all_or_naught(x::Union{Int, Nothing})
    x === nothing && return 42
    x
end

all_or_naught(nothing)
all_or_naught(58)


#################### Parametric Types ####################
md"""
Types can take parameters, so that type declarations actually
introduce a whole family of new types -
one for each possible combination of parameter values.
"""


# %% parametric composite types
struct Dot{T}
    x::T
    y::T
end

typeof(Dot)
typeof(Dot{Int})

Dot{Float16} <: Dot
Dot{AbstractIrrational} <: Dot

Dot{Float64}(13, 66.6)
Dot{Char}('S', 'X')

# Julia will infer the type of `T` if not given
Dot(1, 2)
Dot('C', 'D')

# IMPORTANT: Julia's type parameters are invariant
Int <: Real
Dot{Int} <: Dot{Real}
Dot{Int} <: Dot{<:Real}

#= therefore, incorrect & correct ways to
define a method that accepts all arguments
of type `Dot{T}` where `T` is a subtype
of `Real` are shown below =#
function norm(d::Dot{Real})
    sqrt(d.x^2 + d.y^2)
end  # incorrect; does not work on any subtype of `Real`

# norm(Dot(3, 4))  # ERROR: MethodError...
# norm(Dot(3., 4.))  # ERROR: MethodError...


function norm(d::Dot{<:Real})
    sqrt(d.x^2 + d.y^2)
end  # correct way

norm(Dot(3, 4))
norm(Dot(3., 4.))


# %% parametric abstract types
md"""
Parametric abstract type declarations declare a
collection of abstract types, in much the same way.
"""

#= with this declaration, `Dotty{T}` is a distinct
abstract type for each **type or integer value** of `T` =#
abstract type Dotty{T} end

Dotty{Int} <: Dotty
Dotty{1} <: Dotty

# abstract parametric types are also invariant
String <: AbstractString
Dotty{String} <: Dotty{AbstractString}
Dotty{String} <: Dotty{<:AbstractString}

md"""
The notation `Dotty{<:Real}` can be used to express
the Julia analogue of a _covariant_ type, while
`Dotty{>:Int}` the analogue of a _contravariant_ type,
but technically these represent sets of types (UnionAll types).
"""
Dotty{Float32} <: Dotty{<:Number}
Dotty{Real} <: Dotty{>:Int}

# we may now do subtyping for all types of `T`
struct Jot{T} <: Dotty{T}
    i::T
    j::T
end

Jot{Int} <: Dotty{Int}

# this relationship is also invariant
Jot{Bool} <: Dotty{Integer}

# one can also constrain the range of an abstract type
abstract type NumericDotty{T<:Number} end

NumericDotty{Complex}
# NumericDotty{Char}  # ERROR: TypeError...

# parametric composite types can also be constrained
struct RealDot{T<:Real} <: NumericDotty{T}
    x::T
    y::T
end

RealDot(3//4, 7//8)


# %% tuple types
# who said you can parametrize only one type?
struct Boo{A, B}
    a::A
    b::B
end

md"""Tuples are an abstraction of the arguments of
a function - without the function itself.
The salient aspects of a function's arguments are
their order and their types. Therefore a tuple type
is similar to a parameterized immutable type where
each parameter is the type of one field."""

# IMPORTANT: tuple types are covarient in their parameters
Tuple{Int} <: Tuple{Real}  # note the use of `Tuple`

#= The last parameter of a tuple type can be the special value
`Vararg`, which denotes any number of trailing elements =#
const CustomTuple = Tuple{Char, Vararg{Int}}

('A',) isa CustomTuple
('B', 1) isa CustomTuple
('C', 1, 2, 3, 4, 5) isa CustomTuple
("D",) isa CustomTuple

md"""The special value `Vararg{T,N}` (when used as the
last parameter of a tuple type) corresponds to exactly
`N` elements of type `T`. `NTuple{N,T}` is a convenient
alias for `Tuple{Vararg{T,N}}`, i.e. a tuple type
containing exactly `N` elements of type `T`."""
(1, 2., 3+4im) isa Tuple{Vararg{Number, 3}}
(1, 2., 3+4im) isa NTuple{3, Number}


# %% parametric primitive types
primitive type Pointer{T} 64 end

Pointer{Float64} <: Pointer
Pointer{Float64} <: Pointer{AbstractFloat}  # invariant


#################### UnionAll Types ####################
# TBW: https://docs.julialang.org/en/v1/manual/types/#UnionAll-Types
md"""
Parametric types themselves, (without a specified type `T`) are
an umbrella sort of data type called `UnionAll` (and not `DataType`).
Such a type expresses the iterated union of types for all
values of some parameter.
"""
Vector{Int} <: Vector
typeof(Vector{Int})
typeof(Vector)

Dict{Int, String} <: Dict{Int} <: Dict
typeof(Dict{Int, String})
typeof(Dict{Int})
typeof(Dict)

#= `UnionAll` types are usually written using the keyword `where`
for example, `Pointer` could be more accurately be written as below =#
Pointer === Pointer{T} where T

md"""The type application syntax `A{B,C}` requires `A`
to be a `UnionAll` type, and first substitutes `B`
for the outermost type variable in `A`. The result
is expected to be another `UnionAll` type, into which
`C` is then substituted. So `A{B,C}` is equivalent to `A{B}{C}`."""
Dict === Dict{K,V} where V where K  # note the order of `K` and `V`
Dict{Int}{String} === Dict{Int, String}

#= using explicit `where` syntax, any subset of parameters can be fixed =#
Dict{Int} === Dict{Int, V} where V

# the type of all `Dict`s with `String` values, with keys as subtypes of `Real`
const StringDict = Dict{K, String} where K <: Real
StringDict{Int}(1 => "one", 2 => "two")
# StringDict{Symbol}(:one => "one", :two => "two")  # ERROR: TypeError...


#################### Singleton Types ####################
md"""
Immutable composite types with no fields are called singletons.
Formally, if
1. `T` is an immutable composite type (i.e. defined with struct),
1. a isa T && b isa T implies a === b,
then `T` is a singleton type.
"""
struct SingleMingle
end

Base.issingletontype(SingleMingle)
SingleMingle() === SingleMingle()

# these can have type parameters too
struct ParamSingleMingle{T}
end

Base.issingletontype(ParamSingleMingle)
Base.issingletontype(ParamSingleMingle{Int})

# type aliases are a thing
const Float = Float64
Float <: AbstractFloat

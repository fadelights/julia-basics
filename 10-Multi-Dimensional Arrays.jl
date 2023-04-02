using Markdown

md"""

Basic functions:

| Function       | Description                                                                      |
|:-------------- |:-------------------------------------------------------------------------------- |
| `eltype(A)`    | the type of the elements contained in `A`                                        |
| `length(A)`    | the number of elements in `A`                                                    |
| `ndims(A)`     | the number of dimensions of `A`                                                  |
| `size(A)`      | a tuple containing the dimensions of `A`                                         |
| `size(A,n)`    | the size of `A` along dimension `n`                                              |
| `axes(A)`      | a tuple containing the valid indices of `A`                                      |
| `axes(A,n)`    | a range expressing the valid indices along dimension `n`                         |
| `eachindex(A)` | an efficient iterator for visiting each position in `A`                          |
| `stride(A,k)`  | the stride (linear index distance between adjacent elements) along dimension `k` |
| `strides(A)`   | a tuple of the strides in each dimension                                         |

Many functions for constructing and initializing arrays are provided.
Visit [the Julia docs](https://docs.julialang.org/en/v1/manual/arrays/) for more info.

"""


# one dimensional array
a  = [1, 2, 3]

# use newlines or ; for vertical concatenation
b  = [[1, 2, 3], [4, 5, 6, 7]]  # no concat
b′ = [[1, 2, 3]; [4, 5, 6, 7]]
b″ = [[1, 2, 3]
      [4, 5, 6, 7]]

# use tabs or spaces for horizontal concatenation
c  = [1 2 3]
c′ = [[1, 2, 3] [4, 5, 6]]
c″ = [1:3 4:6]

# combination of tabs/spaces with semicolon/newlines
d  = [1 2
      3 4]
d′ = [1 2; 3 4]

# concatenation can be made easier by using the corresponding functions
md"""

| Syntax                 | Function | Description                                                                                                |
|:---------------------- |:-------- |:---------------------------------------------------------------------------------------------------------- |
|                        | `cat`    | concatenate input arrays along dimension(s) `k`                                                            |
| `[A; B; C; ...]`       | `vcat`   | shorthand for `cat(A...; dims=1)`                                                                          |
| `[A B C ...]`          | `hcat`   | shorthand for `cat(A...; dims=2)`                                                                          |
| `[A B; C D; ...]`      | `hvcat`  | simultaneous vertical and horizontal concatenation                                                         |
| `[A; C;; B; D;;; ...]` | `hvncat` | simultaneous n-dimensional concatenation, where number of semicolons indicate the dimension to concatenate |

"""


# [IMPORTANT]
md"""

### NOTE
Traditional comma-separated arrays in Julia are **vertical** by default!
Not paying attention to this can cause some serious headaches!

`[1, 2, 3]` is **vertical** while `[1 2 3]` is **horizontal**.

"""


# [IMPORTANT] learn the difference
hcat([1, 2, 3], [4, 5, 6])  # 3x2
hcat([1 2 3], [4 5 6])      # 1x6

vcat([1, 2, 3], [4, 5, 6])  # 6
vcat([1 2 3], [4 5 6])      # 2x3

# typed array literals
Int[1 2 3]
Float64[1 2 3]
Any["1" 2 3.0]
Bool[1 1; 1 0] == Bool[[1 1]; [1 0]]

# comprehensions; similar to set construction syntax in mathematics
[i+1 for i in 1:10]
[j^2 for j = ("Hey!", "Hello!")]
[(i, j) for i ∈ 2:3, j ∈ 1:4]
[(i, j) for i ∈ 2:3 for j ∈ 1:4]

# generators; comprehensions without brackets ⇒ no memory allocated
iterator = (1/n^2 for n=1:1000)
sum(iterator)  # performs sum without allocating memory

# more advanced generators/comprehensions
[(i,j) for i=1:3 for j=1:i if i+j == 4]

# indexing
A = permutedims(reshape(1:16, (4, 4)))

A[1]  # providing only one element, treats it as a flat "column-major" vector
A[2]
A[5]
A[6]

A[1, 1]
A[4, 4]
# A[1, 5]  # ERROR: BoundsError...

A[1, :]
A[[1, 3], :]
A[:, 1]
A[:, [1, 3]]

A[1:2]
A[1:2] == A[[1, 2]]
A[1:6]

A[1:2, 3:4]
A[1:2, 3:4] == A[[1, 2], [3, 4]]

# %% advanced indexing
A[[1 2; 3 4]]
A[[1 2; 3 4], 4]
A[[1 2; 3 4], [3, 4]]
A[[1 2; 3 4], [1 2; 3 4]]

A[1, [1 2]]
A[1, [1 2; 3 4]]
A[[1, 2], [1 2; 3 4]]
A[[1 2], [1 2; 3 4]]

A[end]
A[end, end]
A[1, end]
A[end, 1]

# assignment
B = [14 15; 16 17]

B[1, 1] *= 10
B[[1, 2], 2] = [66, 99]
B[[1, 2], 2] = [660 990]
# B[2, :] = 0  # ERROR: ArgumentError: ... use broadcasting instead
B[2, :] .= 0

# pay attention to column-major broadcasting rules
B .+ [1, 2]  # [[1 1]; [2 2]]
B .+ [1 2]  # [[1 2]; [1 2]]

# use of functions for assignment
setindex!(B, 1, 2, 2)  # setindex!(B, X, i_1, i_2, ..., i_n)

# %% more advanced indexing
# cartesian indices
A[CartesianIndex(3, 2, 1)] == A[3, 2, 1]
A[3, 2, 1]  # as long as it's 1...
A[3, 2, 1, 1, 1, 1]

# arrays of `CartesianIndex` ease point-wise indexing
A[[CartesianIndex(1, 1),
   CartesianIndex(2, 2),
   CartesianIndex(3, 3),
   CartesianIndex(4, 4)]]

# WARNING: `CartesianIndex` does not support the `end` keyword

# use `CartesianIndices` to get a list of all `CartesianIndex`es
CartesianIndices(A)

# `LinearIndices` are column-major
LinearIndices(A)

# logical indexing
filter = A .> 4
A[filter]

# %% recommended iteration methods
# element-wise
for a in A
    println(a)
end

# index-wise
for i in eachindex(A)
    println(i)
end

# (not) broadcasting
# ([1, 2, 3], [4, 5, 6]) .+ [1, 2, 3]  # ERROR: DimensionMismatch...
([1, 2, 3], [4, 5, 6]) .+ ([1, 2, 3], )  # correct way. the tuple "protects" the array from being broadcast element-wise
([1, 2, 3], [4, 5, 6]) .+ tuple([1, 2, 3])  # correct

#= slicing an array creates a copy of it,
therefore it is recommended to create a view
into an array when copies are not required;
to prevent new memory allocation--which also
saves time =#
a = [1, 2, 3, 4, 5]
a[3:end]  # new copy; expensive operation
view(a, 3:lastindex(a))  # referencing same location; lightweight operation

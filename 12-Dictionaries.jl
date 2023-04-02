# construction
Dict()  # empty dict
Dict("A"=>7, "B"=>13, "C"=>42)  # each `x=>y` is called a `Pair` object
Dict([("A", 7), ("B", 13), ("C", 42)])  # using iterator of tuples of the form (key, val)
Dict(i => i^2 for i in 1:10)  # using generators

# explicit type specification: `Dict{KeyType, ValueType}(...)`
Dict{String, Real}("A"=>7, "B"=>13, "C"=>42)

# retrieval and insertion
D = Dict('A'=>[1, 2, 3], 'B'=>[4, 5, 6])
D['A']
# D['C']  # ERROR: KeyError...
D['C'] = [7, 8, 9]

# %% methods
haskey(D, 'C')
haskey(D, 'D')

#= `get` receives a `default` argument
to be used when a key is not present in the dict.
consult the documentation for other manners of
calling this method =#
get(D, 'C', [0, 0, 0])
get(D, 'D', [0, 0, 0])

# deleting mappings from a dict
delete!(D, 'A')
delete!(D, 'D')  # left unchanged if a given key isn't present

# pop!(D, 'D')  # ERROR: KeyError...
pop!(D, 'D', 0)  # supply default value to return for when key isn't present

# retrieve stuff
keys(D)
values(D)  # unnecessary, since elements of an iterator are normally considered its "values"
pairs(D)  # unnecessary... sorta

# merge dicts
a = Dict('a'=>1, 'b'=>2)
b = Dict('b'=>666, 'c'=>911)

merge(a, b)
merge(b, a)

# %% increasing performance
#= use `sizehint!` to suggest that collection `s`
reserve capacity for at least `n` elements.
this can improve performance =#

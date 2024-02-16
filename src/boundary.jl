
"""
Extract a subdomain from the lower boundary of `domain` along `axis` with a width of `n` (along `axis`)
"""
function extract_from_lower(domain::CartesianIndices{N}, axis::Int, n::Int) where {N}
  lo = first(domain.indices[axis])
  hi = lo + n - 1
  idx = ntuple(j -> j == axis ? UnitRange(lo, hi) : domain.indices[j], N)

  return CartesianIndices(idx)
end

"""
Extract a subdomain from the upper boundary of `domain` along `axis` with a width of `n` (along `axis`)
"""
function extract_from_upper(domain::CartesianIndices{N}, axis::Int, n::Int) where {N}
  hi = last(domain.indices[axis])
  lo = hi - n + 1
  idx = ntuple(j -> j == axis ? UnitRange(lo, hi) : domain.indices[j], N)

  return CartesianIndices(idx)
end

"""
Take a given CartesianIndices and extract only the lower boundary indices at
an offset of `n` along a given `axis`.

# Example
```julia
julia> domain = CartesianIndices((1:10, 4:8))
CartesianIndices((1:10, 4:8))

julia> lower_boundary_indices(domain, 2, 0) # select the first index on axis 2
CartesianIndices((1:10, 4:4))
```

"""
function lower_boundary_indices(domain::CartesianIndices{N}, axis::Int, n::Int) where {N}
  bc = first(domain.indices[axis]) + n

  idx = ntuple(j -> j == axis ? UnitRange(bc, bc) : domain.indices[j], N)

  return CartesianIndices(idx)
end

"""
Take a given CartesianIndices and extract only the upper boundary indices at
an offset of `n` along a given `axis`.

# Example
```julia
julia> domain = CartesianIndices((1:10, 4:8))
CartesianIndices((1:10, 4:8))

julia> upper_boundary_indices(domain, 2, 1)
CartesianIndices((1:10, 8:8))
```

"""
function upper_boundary_indices(domain::CartesianIndices{N}, axis::Int, n::Int) where {N}
  bc = last(domain.indices[axis]) + n

  idx = ntuple(j -> j == axis ? UnitRange(bc, bc) : domain.indices[j], N)

  return CartesianIndices(idx)
end
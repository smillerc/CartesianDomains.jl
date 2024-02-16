"""
Shift a single `CartesianIndex` by `n` on a given `axis`
"""
function shift(I::CartesianIndex{N}, axis::Int, n::Int) where {N}
  return I + n * δ(axis, I)
end

"""
Shift a `CartesianIndices` domain by `n` on a given `axis`
"""
function shift(domain::CartesianIndices{N}, axis::Int, n::Int) where {N}
  lo = first(domain.indices[axis]) + n
  hi = last(domain.indices[axis]) + n

  idx = ntuple(j -> j == axis ? UnitRange(lo, hi) : domain.indices[j], N)

  return CartesianIndices(idx)
end


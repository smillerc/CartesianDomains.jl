"""
    shift(I::CartesianIndex, n::Int)

Shift a `CartesianIndex` by `n` on all axes
"""
function shift(I::CartesianIndex{N}, n::Int) where {N}
  I_shifted = I
  for axis in 1:N
    I_shifted = shift(I_shifted, axis, n)
  end

  return I_shifted
end

"""
    shift(I::CartesianIndex, n::Int)

Shift a `CartesianIndex` by `n` on all axes
"""
function shift(domain::CartesianIndices{N}, n::Int) where {N}
  shifted_domain = domain
  for axis in 1:N
    shifted_domain = shift(shifted_domain, axis, n)
  end

  return shifted_domain
end

"""
    shift(I::CartesianIndex, axis::Int, n::Int)

Shift a single `CartesianIndex` by `n` on a given `axis`
"""
function shift(I::CartesianIndex{N}, axis::Int, n::Int) where {N}
  return I + n * δ(axis, I)
end

"""
    shift(domain::CartesianIndices, axis::Int, n::Int)
  
Shift a `CartesianIndices` domain by `n` on a given `axis`
"""
function shift(domain::CartesianIndices{N}, axis::Int, n::Int) where {N}
  lo = first(domain.indices[axis]) + n
  hi = last(domain.indices[axis]) + n

  idx = ntuple(j -> j == axis ? UnitRange(lo, hi) : domain.indices[j], N)

  return CartesianIndices(idx)
end

"""
    shift(domain::CartesianIndices{N}, axes::NTuple{N2,Int}, n::NTuple{N2,Int}
) where {N,N2}

Shift a `CartesianIndices` domain by `n` where n is a Tuple on given set of `axes`
"""
function shift(
  domain::CartesianIndices{N}, axes::NTuple{N2,Int}, n::NTuple{N2,Int}
) where {N,N2}

  #
  for (axis, nshift) in zip(axes, n)
    domain = shift(domain, axis, nshift)
  end

  return domain
end
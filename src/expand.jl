"""
Expand the `CartesianIndices` by `n` indices on all axes
"""
function expand(domain::CartesianIndices{N}, n::Int) where {N}
  return CartesianIndices(
    UnitRange.(first.(domain.indices) .- n, last.(domain.indices) .+ n)
  )
end

"""
Expand the `CartesianIndices` by `n` indices on `axis`
"""
function expand(domain::CartesianIndices{N}, axis::Int, n::Int) where {N}
  axis_mask = ntuple(j -> j == axis ? n : 0, N)
  return CartesianIndices(
    UnitRange.(first.(domain.indices) .- axis_mask, last.(domain.indices) .+ axis_mask)
  )
end

# ------------------------------------------------------------------------------
# upper boundary versions
# ------------------------------------------------------------------------------
"""
Expand the CartesianIndices upper index by `n` on `axis`
"""
function expand_upper(domain::CartesianIndices{N}, axis::Int, n::Int) where {N}
  axis_mask = ntuple(j -> j == axis ? n : 0, N)
  return CartesianIndices(
    UnitRange.(first.(domain.indices), last.(domain.indices) .+ axis_mask)
  )
end

"""
Expand the CartesianIndices ending index by `n` on all axes
"""
function expand_upper(domain::CartesianIndices{N}, n::Int) where {N}
  return CartesianIndices(UnitRange.(first.(domain.indices), last.(domain.indices) .+ n))
end

# ------------------------------------------------------------------------------
# lower boundary versions
# ------------------------------------------------------------------------------

"""
Expand the CartesianIndices starting index by `-n` on all axes
"""
function expand_lower(domain::CartesianIndices{N}, axis::Int, n::Int) where {N}
  axis_mask = ntuple(j -> j == axis ? n : 0, N)
  return CartesianIndices(
    UnitRange.(first.(domain.indices) .- axis_mask, last.(domain.indices))
  )
end

"""
Expand the CartesianIndices starting index by `-n` on all axes
"""
function expand_lower(domain::CartesianIndices{N}, n::Int) where {N}
  return CartesianIndices(UnitRange.(first.(domain.indices) .- n, last.(domain.indices)))
end

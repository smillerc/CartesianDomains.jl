module CartesianDomains

export shift, expand, extract_from_lower, extract_from_upper
export expand_lower, expand_upper
export lower_boundary_indices, upper_boundary_indices
export tile

export haloedge_regions, upper_haloedge_regions, lower_haloedge_regions
export upper_edge_regions, lower_edge_regions
export edge_regions

"""
  Apply a delta function to the cartesian index on a specified axis. For
  example, `δ(3, CartesianIndex(1,2,3))` will give `CartesianIndex(0,0,1)`.
"""
δ(axis, ::CartesianIndex{N}) where {N} = CartesianIndex(ntuple(j -> j == axis ? 1 : 0, N))

include("expand.jl")
include("boundary.jl")
include("shift.jl")
include("halo.jl")
include("tile.jl")

# """
# Get indices of of `±n` for an arbitary `axis`. For a 2d index, and
# and offset on the `j` axis, this would be [i,j-n:j+n]. This makes
# it simple to generate arbitrary stencils on arbitrary axes.

# # Arguments
#  - I::CartesianIndex{N}
#  - axis::Int: which axis to provide the ±n to
#  - n::Int: how much to offset on a given axis

#  # Example
# ```julia
# julia> I = CartesianIndex((4,5))
# CartesianIndex(4, 5)

# julia> plus_minus(I, 2, 2)
# CartesianIndices((4:4, 3:7))
# ```

# """
# function plus_minus(I::CartesianIndex{N}, axis::Int, n::Int) where {N}
#   return (I - n * δ(axis, I)):(I + n * δ(axis, I))
# end

# function plus_minus(I::CartesianIndex{N}, axis::Int, (minus, plus)::NTuple{2,Int}) where {N}
#   return (I - minus * δ(axis, I)):(I + plus * δ(axis, I))
# end

end


"""
    haloedge_regions(domain::CartesianIndices{N}, axis::Int, nhalo::Int) where {N}

Extract the halo regions along the edges of `domain` with a width of `nhalo` 
and corresponding edge regions from the interior of the domain. This will create 
and edge region of the same dimension as the halo region.

# Example
```julia
julia> A = [i for i in 1:10];

julia> full = CartesianIndices(A) # this is the entire "domain"
CartesianIndices((10,))

julia> halo, edge = haloedge_regions(full, 1, 2)
(
  halo = (lo = CartesianIndices((1:2,)), hi = CartesianIndices((9:10,))), 
  edge = (lo = CartesianIndices((3:4,)), hi = CartesianIndices((7:8,)))
)
```
"""
function haloedge_regions(domain::CartesianIndices{N}, axis::Int, nhalo::Int) where {N}

  # Shrink by nhalo along all axes to get the 
  # non-halo region in the "center" of the domain
  inner_domain = expand(domain, -nhalo)

  # edge regions
  edge_lo = extract_from_lower(inner_domain, axis, nhalo)
  edge_hi = extract_from_upper(inner_domain, axis, nhalo)

  halo_lo = shift(edge_lo, axis, -nhalo)
  halo_hi = shift(edge_hi, axis, +nhalo)

  return (
    halo=(lo=halo_lo, hi=halo_hi), #
    edge=(lo=edge_lo, hi=edge_hi), #
  )
end

"""
    haloedge_regions(domain::CartesianIndices{N}, axis::Int, nhalo::Int, nedge::Int) where {N}

Extract the halo regions along the edges of `domain` with a width of `nhalo` 
and corresponding edge regions of size `nedge` from the interior of the domain. This will 
provide an edge region with a size `nedge` elements along `axis`. As an example, say you
have a halo region of 2 elements, but you only want the outermost edge that is adjacent
to the halo region. Calling `haloedge_regions(domain, 3, 2, 1)` will give you a 
halo region 2 elements thick on the third axis, but the edge region will only be 1 
element thick.

# Example
```julia
julia> A = [i for i in 1:10];

julia> full = CartesianIndices(A) # this is the entire "domain"
CartesianIndices((10,))

julia> halo, edge = haloedge_regions(full, 1, 2, 1) # this uses a halo region of 2 and edge of 1
(
  halo = (lo = CartesianIndices((1:2,)), hi = CartesianIndices((9:10,))), 
  edge = (lo = CartesianIndices((3:3,)), hi = CartesianIndices((8:8,)))
)
```
"""
function haloedge_regions(
  domain::CartesianIndices{N}, axis::Int, nhalo::Int, nedge::Int
) where {N}

  # Shrink by nhalo along all axes to get the 
  # non-halo region in the "center" of the domain
  inner_domain = expand(domain, -nhalo)

  # edge regions
  _edge_lo = extract_from_lower(inner_domain, axis, nhalo)
  _edge_hi = extract_from_upper(inner_domain, axis, nhalo)

  halo_lo = shift(_edge_lo, axis, -nhalo)
  halo_hi = shift(_edge_hi, axis, +nhalo)

  edge_lo = extract_from_lower(_edge_lo, axis, nedge)
  edge_hi = extract_from_upper(_edge_hi, axis, nedge)

  return (
    halo=(lo=halo_lo, hi=halo_hi), #
    edge=(lo=edge_lo, hi=edge_hi), #
  )
end
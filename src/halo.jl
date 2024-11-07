
"""
    haloedge_regions(full_domain::CartesianIndices{N}, axis::Int, nhalo::Int) where {N}

Extract the halo regions along the edges of `full_domain` with a width of `nhalo` 
and corresponding edge regions from the interior of the full_domain. This will create 
and edge region of the same dimension as the halo region.

# Example
```julia
julia> A = [i for i in 1:10];

julia> full = CartesianIndices(A) # this is the entire "full_domain"
CartesianIndices((10,))

julia> halo, edge = haloedge_regions(full, 1, 2)
(
  halo = (lo = CartesianIndices((1:2,)), hi = CartesianIndices((9:10,))), 
  edge = (lo = CartesianIndices((3:4,)), hi = CartesianIndices((7:8,)))
)
```
"""
function haloedge_regions(full_domain::CartesianIndices{N}, axis::Int, nhalo::Int) where {N}
  haloedge_regions(full_domain, axis, nhalo, nhalo)
end

"""
    haloedge_regions(full_domain::CartesianIndices{N}, axis::Int, nhalo::Int, nedge::Int) where {N}

Extract the halo regions along the edges of `full_domain` with a width of `nhalo` 
and corresponding edge regions of size `nedge` from the interior of the full_domain. This will 
provide an edge region with a size `nedge` elements along `axis`. As an example, say you
have a halo region of 2 elements, but you only want the outermost edge that is adjacent
to the halo region. Calling `haloedge_regions(full_domain, 3, 2, 1)` will give you a 
halo region 2 elements thick on the third axis, but the edge region will only be 1 
element thick.

# Example
```julia
julia> A = [i for i in 1:10];

julia> full = CartesianIndices(A) # this is the entire "full_domain"
CartesianIndices((10,))

julia> halo, edge = haloedge_regions(full, 1, 2, 1) # this uses a halo region of 2 and edge of 1
(
  halo = (lo = CartesianIndices((1:2,)), hi = CartesianIndices((9:10,))), 
  edge = (lo = CartesianIndices((3:3,)), hi = CartesianIndices((8:8,)))
)
```
"""
function haloedge_regions(
  full_domain::CartesianIndices{N}, axis::Int, nhalo::Int, nedge::Int
) where {N}
  halo_lo, edge_lo = lower_haloedge_regions(full_domain, axis, nhalo, nedge)
  halo_hi, edge_hi = upper_haloedge_regions(full_domain, axis, nhalo, nedge)

  return (
    halo=(lo=halo_lo, hi=halo_hi), #
    edge=(lo=edge_lo, hi=edge_hi), #
  )
end

function lower_haloedge_regions(
  full_domain::CartesianIndices{N}, axis::Int, nhalo::Int, nedge::Int
) where {N}
  @assert nedge <= nhalo "The size of the edge region must be <= than the halo region"

  # Shrink by nhalo along all axes to get the 
  # non-halo region in the "center" of the full_domain
  inner_domain = expand(full_domain, -nhalo)

  # edge regions
  _edge_lo = extract_from_lower(inner_domain, axis, nhalo)

  halo_lo = shift(_edge_lo, axis, -nhalo)

  edge_lo = extract_from_lower(_edge_lo, axis, nedge)

  return (halo=halo_lo, edge=edge_lo)
end

function upper_haloedge_regions(
  full_domain::CartesianIndices{N}, axis::Int, nhalo::Int, nedge::Int
) where {N}
  @assert nedge <= nhalo "The size of the edge region must be <= than the halo region"

  # Shrink by nhalo along all axes to get the 
  # non-halo region in the "center" of the full_domain
  inner_domain = expand(full_domain, -nhalo)

  # edge regions
  _edge_hi = extract_from_upper(inner_domain, axis, nhalo)

  halo_hi = shift(_edge_hi, axis, +nhalo)

  edge_hi = extract_from_upper(_edge_hi, axis, nedge)

  return (halo=halo_hi, edge=edge_hi)
end

"""
    lower_edge_region(full_domain::CartesianIndices, axis::Int, nhalo::Int, nedge::Int)

Extract the subdomain from `full_domain` along the low edge of the inner domain with 
a width of `nedge` along a given `axis`. The inner domain is the domain within `full_domain`
that does not include the halo region. This function is designed to provide edges along
the inner domain of a given width. This is useful for splitting a problem into domains
in the "center" and domains along the edge.
"""
function lower_edge_regions(
  full_domain::CartesianIndices{N}, axis::Int, nhalo::Int, nedge::Int
) where {N}

  # Shrink by nhalo along all axes to get the 
  # non-halo region in the "center" of the full_domain
  inner_domain = expand(full_domain, -nhalo)
  edge_lo = extract_from_lower(inner_domain, axis, nedge)
  return edge_lo
end

"""
    upper_edge_region(full_domain::CartesianIndices, axis::Int, nhalo::Int, nedge::Int)

Extract the subdomain from `full_domain` along the high edge of the inner domain with 
a width of `nedge` along a given `axis`. The inner domain is the domain within `full_domain`
that does not include the halo region. This function is designed to provide edges along
the inner domain of a given width. This is useful for splitting a problem into domains
in the "center" and domains along the edge.
"""
function upper_edge_regions(
  full_domain::CartesianIndices{N}, axis::Int, nhalo::Int, nedge::Int
) where {N}

  # Shrink by nhalo along all axes to get the 
  # non-halo region in the "center" of the full_domain
  inner_domain = expand(full_domain, -nhalo)

  # edge regions
  edge_hi = extract_from_upper(inner_domain, axis, nedge)
  return edge_hi
end

"""
    edge_regions(full_domain::CartesianIndices, axis::Int, nhalo::Int, nedge::Int)
  
Extract the subdomains from `full_domain` along the boundaries of the halo
region (defined by a thickness of `nhalo`), with a thickness of `nedge`.
"""
function edge_regions(
  full_domain::CartesianIndices{N}, axis::Int, nhalo::Int, nedge::Int
) where {N}
  edge_lo = lower_edge_regions(full_domain, axis, nhalo, nedge)
  edge_hi = upper_edge_regions(full_domain, axis, nhalo, nedge)

  return (; lo=edge_lo, hi=edge_hi)
end
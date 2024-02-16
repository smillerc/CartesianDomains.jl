
"""
Extract the halo regions along the edges of `domain` with a width of `nhalo` 
and corresponding edge regions from the interior of the domain
"""
function get_haloedge_regions(domain::CartesianIndices{N}, axis::Int, nhalo::Int) where {N}

  # Shrink by nhalo along all axes to get the 
  # non-halo region in the "center" of the domain
  inner_domain = expand(domain, -nhalo)
  @show inner_domain

  # edge regions
  edge_lo = extract_from_lower(inner_domain, axis, nhalo)
  edge_hi = extract_from_upper(inner_domain, axis, nhalo)

  @show edge_lo edge_hi
  halo_lo = shift(edge_lo, axis, -nhalo)
  halo_hi = shift(edge_hi, axis, +nhalo)

  return (
    halo=(lo=halo_lo, hi=halo_hi), #
    edge=(lo=edge_lo, hi=edge_hi), #
  )
end

using .Iterators: partition, product

"""
    tile(domain, fraction)

Split `domain` up by `fraction` into smaller chunks. This is designed to split a 
CartesianIndex into subdomains. `fraction` can be a single `Int` or a `NTuple{Int}`
"""
function tile(domain, fraction; cell_based=true)
  splits = cld.(size(domain), fraction)
  tiles = collect(CartesianIndices.(product(partition.(axes(domain), splits)...)))

  if cell_based
    return tiles
  else
    return expand_upper.(tiles, 1)
  end
end

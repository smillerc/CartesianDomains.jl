
using .Iterators: partition, product

"""
    tile(domain, fraction)

Split `domain` up by `fraction` into smaller chunks. This is designed to split a 
CartesianIndex into subdomains. `fraction` can be a single `Int` or a `NTuple{Int}`
"""
function tile(domain, fraction)
  splits = cld.(size(domain), fraction)
  tiles = product(partition.(axes(domain), splits)...)
  return collect(tiles)
end

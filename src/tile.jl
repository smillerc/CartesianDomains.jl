
using .Iterators: partition, product
using LinearAlgebra: norm

"""
    tile(domain::CartesianIndices{N}, fraction::NTuple{N,Int}; cell_based=true) where {N}

Split `domain` up by `fraction` into smaller chunks. This is designed to split a
CartesianIndex into subdomains.
"""
function tile(
  domain::CartesianIndices{N}, fraction::NTuple{N,Int}; cell_based=true
) where {N}
  splits = cld.(size(domain), fraction)
  _tiles = collect(CartesianIndices.(product(partition.(axes(domain), splits)...)))

  I0 = CartesianIndex(ntuple(i -> 1, N))
  offset = first(domain) - I0
  tiles = shift.(_tiles, offset)
  if cell_based
    return tiles
  else
    return expand_upper.(tiles, 1)
  end
end

"""
    tile(domain::CartesianIndices{1}, n::Int; cell_based=true)

Split a 1D Cartesian domain into `n` tiles
"""
function tile(domain::CartesianIndices{1}, n::Int; cell_based=true)
  return tile(domain, (n,); cell_based=cell_based)
end

"""
    tile(domain::CartesianIndices{2}, n::Int; cell_based=true)

Split a 2D Cartesian domain into `n` tiles
"""
function tile(domain::CartesianIndices{2}, n::Int; cell_based=true)
  return tile(domain, num_2d_tiles(n); cell_based=cell_based)
end

"""
    tile(domain::CartesianIndices{3}, n::Int; cell_based=true)

Split a 3D Cartesian domain into `n` tiles
"""
function tile(domain::CartesianIndices{3}, n::Int; cell_based=true)
  return tile(domain, num_3d_tiles(n); cell_based=cell_based)
end

"""Return all common denominators of n"""
function denominators(n::Integer)
  denominators = Int[]
  for i in 1:n
    if mod(n, i) == 0
      push!(denominators, i)
    end
  end
  return denominators
end

"""Returns the optimal number of tiles in (i,j) given total number of tiles n"""
function num_2d_tiles(n)
  # find all common denominators of the total number of images
  denoms = denominators(n)

  # find all combinations of common denominators
  # whose product equals the total number of images
  dim1 = Int[]
  dim2 = Int[]
  for j in eachindex(denoms)
    for i in eachindex(denoms)
      if denoms[i] * denoms[j] == n
        push!(dim1, denoms[i])
        push!(dim2, denoms[j])
      end
    end
  end
  # pick the set of common denominators with the minimal norm
  # between two elements -- rectangle closest to a square
  num_2d_tiles = [dim1[1], dim2[1]]
  for i in 2:length(dim1)
    n1 = norm([dim1[i], dim2[i]] .- sqrt(n))
    n2 = norm(num_2d_tiles .- sqrt(n))
    if n1 < n2
      num_2d_tiles = [dim1[i], dim2[i]]
    end
  end

  return tuple(reverse(num_2d_tiles)...)
end

"""Returns the optimal number of tiles in (i,j,k) given total number of tiles n"""
function num_3d_tiles(n)
  # find all common denominators of the total number of images
  denoms = denominators(n)

  # find all combinations of common denominators
  # whose product equals the total number of images
  dim1 = Int[]
  dim2 = Int[]
  dim3 = Int[]
  for k in eachindex(denoms)
    for j in eachindex(denoms)
      for i in eachindex(denoms)
        if denoms[i] * denoms[j] * denoms[k] == n
          push!(dim1, denoms[i])
          push!(dim2, denoms[j])
          push!(dim3, denoms[k])
        end
      end
    end
  end
  # pick the set of common denominators with the minimal norm
  # between two elements -- rectangle closest to a square
  num_3d_tiles = [dim1[1], dim2[1], dim3[1]]
  for i in 2:length(dim1)
    n1 = norm([dim1[i], dim2[i], dim3[i]] .- sqrt(n))
    n2 = norm(num_3d_tiles .- sqrt(n))
    if n1 < n2
      num_3d_tiles = [dim1[i], dim2[i], dim3[i]]
    end
  end

  return tuple(reverse(num_3d_tiles)...)
end

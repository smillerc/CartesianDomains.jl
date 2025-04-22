using CartesianDomains
using Test
using BenchmarkTools

@testset "CartesianDomains.jl" begin
  domain = CartesianIndices((1:10, 4:8))

  @test lower_boundary_indices(domain, 1, +1) == CartesianIndices((2:2, 4:8))
  @test lower_boundary_indices(domain, 1, 0) == CartesianIndices((1:1, 4:8))
  @test lower_boundary_indices(domain, 1, -1) == CartesianIndices((0:0, 4:8))

  @test upper_boundary_indices(domain, 2, +1) == CartesianIndices((1:10, 9:9))
  @test upper_boundary_indices(domain, 2, 0) == CartesianIndices((1:10, 8:8))
  @test upper_boundary_indices(domain, 2, -1) == CartesianIndices((1:10, 7:7))

  @test expand(domain, 2, -1) == CartesianIndices((1:10, 5:7))
  @test expand(domain, 2, 0) == CartesianIndices((1:10, 4:8))
  @test expand(domain, 2, 2) == CartesianIndices((1:10, 2:10))

  @test expand(domain, 2) == CartesianIndices((-1:12, 2:10))

  @test expand_lower(domain, 2) == CartesianIndices((-1:10, 2:8))
  @test expand_upper(domain, 2) == CartesianIndices((1:12, 4:10))

  b1 = @benchmark shift(CartesianIndex((4, 5, 6)), 3, +2)
  @test b1.allocs == 0

  b2 = @benchmark expand($domain, 2)
  @test b2.allocs == 0

  b3 = @benchmark lower_boundary_indices($domain, 1, +1)
  @test b3.allocs == 0

  b4 = @benchmark upper_boundary_indices($domain, 1, +1)
  @test b3.allocs == 0

  @test shift(CartesianIndex((4, 5, 6)), 3, +2) == CartesianIndex(4, 5, 8)
  @test shift(CartesianIndex((4, 5, 6)), +1) == CartesianIndex(5, 6, 7)
  @test shift(CartesianIndex((4, 5, 6)), 1, -2) == CartesianIndex(2, 5, 6)
  @test shift(CartesianIndex((4, 5, 6)), 0, +2) == CartesianIndex(4, 5, 6)
  @test shift(CartesianIndices((4, 5, 6)), +1) == CartesianIndices((2:5, 2:6, 2:7))

  # δ isn't exported...
  @test CartesianDomains.δ(1, CartesianIndex((4, 5, 6))) == CartesianIndex((1, 0, 0))

  nhalo = 2
  halo, edge = haloedge_regions(domain, 1, nhalo)

  @test halo == (lo=CartesianIndices((1:2, 6:6)), hi=CartesianIndices((9:10, 6:6)))
  @test edge == (lo=CartesianIndices((3:4, 6:6)), hi=CartesianIndices((7:8, 6:6)))

  nhalo = 2
  edge_width = 2
  full = CartesianIndices((10, 20, 30))
  edge_domains = extract_edge_regions(full, nhalo, edge_width)

  @test edge_domains == [
    CartesianIndices((3:4, 5:16, 5:26)),
    CartesianIndices((3:8, 3:4, 5:26)),
    CartesianIndices((3:8, 3:18, 3:4)),
    CartesianIndices((7:8, 5:16, 5:26)),
    CartesianIndices((3:8, 17:18, 5:26)),
    CartesianIndices((3:8, 3:18, 27:28)),
  ]

  # data = zeros(Int, size(full))
  # for (i, subdomain) in enumerate(edge_domains)
  #   data[subdomain] .= i
  # end

  # x, y, z = 0:10, 1:6, 2:0.1:3

  # nodes = expand_upper(full, 1)
  # x, y, z = nodes.indices
  # vtk_grid("3d_fields", x, y, z) do vtk
  #   vtk["data", VTKCellData()] = data
  # end

  full = CartesianIndices((10, 20))

  edge_domains = extract_edge_regions(full, nhalo, edge_width)

  @test edge_domains == [
    CartesianIndices((3:4, 5:16)),
    CartesianIndices((3:8, 3:4)),
    CartesianIndices((7:8, 5:16)),
    CartesianIndices((3:8, 17:18)),
  ]
  # data = zeros(Int, size(full))
  # for (i, subdomain) in enumerate(edge_domains)
  #   data[subdomain] .= i
  # end

  # x, y = 0:10, 1:6

  # nodes = expand_upper(full, 1)
  # x, y = nodes.indices
  # vtk_grid("2d_fields", x, y) do vtk
  #   vtk["data", VTKCellData()] = data
  # end

  tiles = tile(full, 2)
  @test tile(full, (1, 2)) == tile(full, 2)
  @test size(tiles) == (1, 2)

  @test tiles[1] == CartesianIndices((1:10, 1:10))
  @test tiles[2] == CartesianIndices((1:10, 11:20))

  @test size(tile(CartesianIndices((40, 40, 40)), 3)) == (1, 1, 3)
end

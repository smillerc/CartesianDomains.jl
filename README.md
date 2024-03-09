# CartesianDomains

[![Build Status](https://github.com/smillerc/CartesianDomains.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/smillerc/CartesianDomains.jl/actions/workflows/CI.yml?query=branch%3Amain)


`CartesianDomains.jl` is a lightweight library used to work with Cartesian domains and provide conveinent indexing functions. This arose from a need to write dimension-agnostic code for stencil-like operations and halo-aware domains.

The currently exported functions include:
 - `shift`: Shift a `CartesianIndex` by `n` along a given axis. This is useful for getting indices like `[i+1,j,k]` but in a dimension agnostic manner
 - `expand`: Expand a `domain:CartesianIndices{N}` by `n` (or contract by `-n`) along all `axes` or a specified `axis`
 - `expand_lower`: Expand a `domain:CartesianIndices{N}` by `n` (or contract by `-n`) along the lower bound on all along all `axes` or a specified `axis`
 - `expand_upper`: Expand a `domain:CartesianIndices{N}` by `n` (or contract by `-n`) along the upper bound on all along all `axes` or a specified `axis`
 - `extract_from_lower`: Extract a subdomain at the lower bound from `domain:CartesianIndices{N}` along all axes or a give `axis` with a width of `n`
 - `extract_from_upper`: Extract a subdomain from the upper bound from `domain:CartesianIndices{N}` along all axes or a give `axis` with a width of `n`
 - `haloedge_regions`: Extract halo and corresponding edge regions from a domain along a given axis, where the subdomain has a size `nhalo` along a given `axis`. The user can also specify `nedge` if the edge region needs to be a smaller size than `nhalo`

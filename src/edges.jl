function extract_edge_regions(
  full_domain::CartesianIndices{N}, nhalo::Int, width::Int
) where {N}
  edges = ntuple(axis -> edge_regions(full_domain, axis, nhalo, width), N)

  # each edge domain extends from lo:hi, but they need to be trimmed so that
  # there isn't overlap

  # which axis has the larger domain?
  length_per_axis = [length(ax.lo) for ax in edges]
  max_axis = argmax(length_per_axis)

  axis_trim_order = reverse(sortperm(length_per_axis)) # i.e. [3,1,2] for [k, i, j]
  trim_axes = axis_trim_order[begin:(end - 1)]
  axes_to_trim = reverse(axis_trim_order[(begin + 1):end])

  lo_edges = [ax.lo for ax in edges]
  hi_edges = [ax.hi for ax in edges]

  for trim_axis in trim_axes # axes [k,i] need to be trimmed
    for axis in axes_to_trim # trim along [i,j], then just [j]

      # if size(lo_edges[trim_axis], axis) > 1
      lo_edges[trim_axis] = expand(lo_edges[trim_axis], axis, -width)
      hi_edges[trim_axis] = expand(hi_edges[trim_axis], axis, -width)
      # end

    end
    pop!(axes_to_trim) # remove an axis to trim along each time
  end

  return (lo_edges..., hi_edges...)
end
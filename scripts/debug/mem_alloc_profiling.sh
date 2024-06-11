# https://docs.kernel.org/mm/allocation-profiling.html

# top10 alloc size
sort -rg /proc/allocinfo | head
# top10 alloc calls
sort -rgk 2 /proc/allocinfo | head

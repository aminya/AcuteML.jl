# Benchmark Result

-------------------------------------

# v 0.10.3

Outside Atom

8.700 μs (100 allocations: 3.61 KiB)
3.957 μs (66 allocations: 3.17 KiB)
201.799 μs (401 allocations: 16.27 KiB)

-------------------------------------

# v 0.10.2

Outside Atom

8.700 μs (100 allocations: 3.61 KiB)
3.938 μs (66 allocations: 3.17 KiB)
220.101 μs (403 allocations: 16.33 KiB)

Inside Atom

9.000 μs (100 allocations: 3.61 KiB)
4.114 μs (66 allocations: 3.17 KiB)
300.800 μs (403 allocations: 16.33 KiB)

-------------------------------------

# v 0.10

small bump in extraction is because of two additional `hasmethod` check in `nodeparse`. Using traits this will be fixed

8.899 μs (100 allocations: 3.61 KiB)
3.938 μs (66 allocations: 3.17 KiB)
308.500 μs (403 allocations: 16.33 KiB)

-------------------------------------

# V 0.9.2 - julia 1.4

10.000 μs (99 allocations: 3.39 KiB)
3.986 μs (66 allocations: 3.17 KiB)
281.099 μs (356 allocations: 14.53 KiB)

-------------------------------------

# V 0.8.2

9.800 μs (100 allocations: 3.41 KiB)
4.057 μs (66 allocations: 3.17 KiB)
275.499 μs (356 allocations: 14.53 KiB)

-------------------------------------

# V 0.7

11.299 μs (108 allocations: 11.61 KiB)
5.267 μs (73 allocations: 11.36 KiB)
261.400 μs (371 allocations: 23.11 KiB)

-------------------------------------

# V 0.6

9.099 μs (92 allocations: 11.34 KiB)
16.800 μs (72 allocations: 11.58 KiB)
474.400 μs (348 allocations: 22.61 KiB)

-------------------------------------

# V 0.5

9.200 μs (93 allocations: 11.36 KiB)
19.799 μs (72 allocations: 11.58 KiB)
489.401 μs (348 allocations: 22.61 KiB

-------------------------------------
# V 0.4


9.999 μs (92 allocations: 11.34 KiB)
20.900 μs (72 allocations: 11.58 KiB)
493.499 μs (363 allocations: 23.23 KiB)

# BigsSegfault

This is a Julia repository to share a segfaulting problem. See the [JuliaLang issue on this topic](https://github.com/ChrisRackauckas/BigsSegfault.jl/edit/master/README.md).
It's pretty simple to cause the segfault: just do

```julia
Pkg.clone("https://github.com/ChrisRackauckas/BigsSegfault.jl")
using BigsSegfault
f(1.0,2.0)
```
The problem looks like it comes from Bigs inlining in precompilation. The
entire package is:

```julia
__precompile__() ## Required in order to segfault

module BigsSegfault
const α = parse(BigFloat,"1.01")
f = (t,u) -> (α*u)

function fmaker(α=1.0)
  f(t,u) = α*u
  return f
end
export f,α,fmaker
end # module
```

The reason I put this in a package is because the segfaults do not happen if
precompilation is disabled, or if `f` is defined in a manner such that α does
not inline [for example, using

```julia
function fmaker(α=1.0)
  f(t,u) = α*u
  return f
end
```

and then using the `f` developed from there will not segfault].

```julia
using BigsSegfault
f2 = fmaker()
f2(1.0,2.0) # No segfault
```

Note that this segfault also requires Juno to be restarted (not just killing the
current process, but the window has to be closed and re-opened).

This segfault problem also happens with inlined Rational{BigInt}, generic functions,
and more. For more examples, check out the tests which are commented out in
DifferentialEquations.jl with the mention "Bigs problem". Another example of this
issue [can be found on julia-users](https://groups.google.com/forum/#!topic/julia-users/cSliYJ-a_wE).

__precompile__() ## Required in order to segfault

module BigsSegfault
const α = parse(BigFloat,"1.01")
f = (t,u) -> (α*u)
## Other test
function fmaker(α2=1.01)
  f(t,u) = α2*u
  return f
end
export f,α,fmaker
end # module

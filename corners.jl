#########################
# Guido Dipietro - 2020 #
#########################

using BenchmarkTools

cp = (1,2,3,4,5,6,7,8) # like,speffz
co = (0,0,0,0,0,0,0,0) # 1 = clockwise
cube = (cp, co)

# Atoms
Rp((a,b,c,d,e,f,g,h)) = (a,c,f,d,e,g,b,h)
Ro(a) = @. (a + (0,1,2,0,0,1,2,0)) % 3
Up((a,b,c,d,e,f,g,h)) = (d,a,b,c,e,f,g,h)
xp((a,b,c,d,e,f,g,h)) = (d,c,f,e,h,g,b,a)
xo(a) = @. (a + (2,1,2,1,2,1,2,1)) % 3

# Movedefs
R((p,o)) = Rp(p), (Ro∘Rp)(o)
U((p,o)) = Up(p), Up(o)
x((p,o)) = xp(p), (xo∘xp)(o)
D = x ∘ x ∘ U ∘ x ∘ x
y = U ∘ D ∘ D ∘ D
F = x ∘ x ∘ x ∘ U ∘ x
B = y ∘ y ∘ F ∘ y ∘ y
z = F ∘ B ∘ B ∘ B
L = y ∘ y ∘ R ∘ y ∘ y

# Move (string) to Move (func)
function m_to_mf(m, funcs)
    func = getfield(Main,Symbol(m[1]))
    length(m)==2 ? (m[2]=='2' ? func∘func : func∘func∘func) : func
end

# String of moves to single func
str_to_func(string) = foldl(∘, map(m_to_mf, reverse(split(string))))

############

# Running
scramble = "R' U' F D2 B2 U2 L2 B2 U2 F2 R' B2 R' U' F' R D2 L D L' U2 F R' U' F"
solution = "U F2 B U B D R2 L2 F2 U' F2 L2 D F2 D' R2 D' B D L B'"

# One single function that represents this cube state! It is the solved state here.
# pos = str_to_func(scramble*" "*solution)

# Benchmarking:
@btime _pos(cube) setup=(_pos=str_to_func(scramble*" "*solution))
# 19.999 μs (1 allocation: 144 bytes)
# ((1, 2, 3, 4, 5, 6, 7, 8), (0, 0, 0, 0, 0, 0, 0, 0))
# 😲😲😲😲😲😲😲😲😲😲😲😲😲😲

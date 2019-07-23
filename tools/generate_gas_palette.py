import sys, png

size = 16

if len(sys.argv) != 1 + 3:
    print("Usage: generate_gas_palette.py R G B")
    sys.exit(1)
R, G, B = map(int, sys.argv[1:])

def white(C, x):
    return C + (x * (255 - C)) // 255

img = [[0 for i in range(size * 4)] for j in range(size)]
for ind in range(size ** 2):
    x, y = ind // size, ind % size
    img[x][y * 4 + 0] = white(R, 255 - ind) # R
    img[x][y * 4 + 1] = white(G, 255 - ind) # G
    img[x][y * 4 + 2] = white(B, 255 - ind) # B
    img[x][y * 4 + 3] = ind                 # A

png.from_array(img, 'RGBA').save("palette.png")
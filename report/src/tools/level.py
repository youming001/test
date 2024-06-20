src = open("assets/level/level.ascii.txt", "r")
tgt = open("assets/level/level.mem", "w")

m = src.read()
m = m.replace(" ", "0")
m = m.replace("@", "1")
m = m.replace("$", "2")
m = m.replace(".", "3")
m = m.replace("#", "4")
m = m.replace("\n", "")
m = list(map(int, m))

for px in m: tgt.write(str(px) + "\n")
print(f"[+] Generated level.mem from level.ascii.txt.")
print(f"    Levels: {len(m) // 100}.")
print(f"    Chunks: {len(m)}.")

src.close()
tgt.close()

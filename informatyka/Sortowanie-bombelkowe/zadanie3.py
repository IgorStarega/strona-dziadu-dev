n = 15
tablica_slowa = []

for i in range(n):
    tablica_slowa.append(input(f"Podaj {i+1} element tablicy: "))
tablica_dlugosca = []
for i in range(n):
    tablica_dlugosca.append(len(tablica_slowa[i]))
for j in range(0, n-1):
    for i in range(0, n-1):
        if tablica_dlugosca[i] > tablica_dlugosca[i+1]:
            tablica_slowa[i], tablica_slowa[i+1] = tablica_slowa[i+1], tablica_slowa[i]
            tablica_dlugosca[i], tablica_dlugosca[i+1] = tablica_dlugosca[i+1], tablica_dlugosca[i]

print(tablica_slowa)

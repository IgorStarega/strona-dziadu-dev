tablica = []

n = 5

def czy_jest_liczba(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

for i in range(n):
    tablica.append(input(f"Podaj {i+1} element tablicy: "))

tablica_slowa = []
tablica_liczby = []

for i in range(len(tablica)):
    if czy_jest_liczba(tablica[i]):
        tablica_liczby.append(int(tablica[i]))
    else:
        tablica_slowa.append(tablica[i])

tablica_slowa.sort()
tablica_liczby.sort()

min_len = min(len(tablica_slowa), len(tablica_liczby))

for i in range(min_len):
    if len(tablica_slowa[i]) == len(str(tablica_liczby[i])):
        polaczone = tablica_slowa[i] + str(tablica_liczby[i])
        print(polaczone)
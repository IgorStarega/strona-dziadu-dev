import random

def MinMax(tablica):
    if tablica[0] > tablica[1]:
        max = tablica[0]
        min = tablica[1]
    else:
        max = tablica[1]
        min = tablica[0]
    for i in range(2, len(tablica)-1, 2):
        if tablica[i] > tablica[i+1]:
            if tablica[i] > max:
                max = tablica[i]
            if tablica[i+1] < min:
                min = tablica[i+1]
        else:
            if tablica[i+1] > max:
                max = tablica[i+1]
            if tablica[i] < min:
                min = tablica[i]

    return min, max

dlugosc = int(input("Podaj długość tabeli z liczbami: "))

tablica = [0] * dlugosc

for i in range(dlugosc):
    tablica[i] = random.randint(1, 100)

print(tablica)

minimalna, maksymalna = MinMax(tablica)

print(f"Minimalna liczba w tablicy to {minimalna}, a maksymalna to {maksymalna}.")
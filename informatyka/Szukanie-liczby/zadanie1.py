import random

dlugosc = int(input("Podaj długość tabeli z liczbami: "))

tablica = [0] * dlugosc

for i in range(dlugosc):
    tablica[i] = random.randint(1, 100)

print(tablica)

szukana = int(input("Podaj szukaną liczbę: "))

for i in range(len(tablica)):
    if tablica[i] == szukana:
        print(f"Liczba {szukana} znajduje się na pozycji {i}.")
        break
else:
    print(f"Liczba {szukana} nie została znaleziona w tablicy.")
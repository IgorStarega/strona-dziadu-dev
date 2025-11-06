import random

dlugosc = int(input("Podaj długość tabeli z liczbami: "))

tablica = [0] * dlugosc

for i in range(dlugosc):
    tablica[i] = random.randint(1, 100)

print(tablica)

tablica = sorted(tablica)

szukana = int(input("Podaj szukaną liczbę: "))

lewy = 0
prawy = len(tablica) - 1

while lewy < prawy:

    # Obliczanie środka

    srodek = (lewy + prawy) // 2

    # Jeżeli znaleziona została liczba szukana, zakończ program

    if tablica[srodek] == szukana:
        print(f"Liczba {szukana} znajduje się na pozycji {srodek}.")
        exit()
    if tablica[srodek] < szukana:
        lewy = srodek + 1
    else:
        prawy = srodek

print(f"Liczba {szukana} nie znajduje się w tablicy.")
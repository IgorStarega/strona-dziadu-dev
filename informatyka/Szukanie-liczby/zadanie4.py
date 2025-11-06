n = int(input("Podaj rozmiar tablicy (n): "))

tablica = [0] * n
tablica_sumy_cyfr = [0] * n

for i in range(n):
    tablica[i] = int(input(f"Podaj liczbę: {i + 1}: "))

maks = 0

for i in range(n):
    liczba = tablica[i]
    suma_cyfr = 0

    # Przechodzenie przez cyfry liczby

    while liczba > 0:
        suma_cyfr = suma_cyfr + liczba % 10
        liczba //= 10

    # Przypisywanie sumy cyfr liczby w miejscu tej liczby w tablicy oryginalnej

    tablica_sumy_cyfr[i] = suma_cyfr

# Znajdowanie indeksu maksymalnej sumy cyfr

indeks_maksa = tablica_sumy_cyfr.index(max(tablica_sumy_cyfr))

print(f"Liczba o największej sumie cyfr to {tablica[indeks_maksa]} z sumą cyfr równą {tablica_sumy_cyfr[indeks_maksa]}.")
# Alumno: Néstor Rodríguez Vico

# 9 - Escribe una función palindromo(frase) que determine si frase es un palíndromo. Es decir, 
# que se lea igual de izquierda a derecha que de derecha a izquierda (sin considerar espacios).

def palindromo(frase):
    return frase.replace(" ", "") == frase.replace(" ", "")[::-1]

print(palindromo("amad a la dama"))
print(palindromo("no es palindromo"))
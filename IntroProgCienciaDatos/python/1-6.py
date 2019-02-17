# Alumno: Néstor Rodríguez Vico

# 6 - Escribe una función es_inversa(palabra1, palabra2) que devuelve True si una palabra es la 
# misma que la otra pero con los caracteres en orden inverso. Por ejemplo 'absd' y 'dsba'

def es_inversa(palabra1, palabra2):
    return palabra1 == palabra2[::-1]

print(es_inversa("absd", "dsba"))
print(es_inversa("absd", "absd"))
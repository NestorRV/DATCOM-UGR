# Alumno: Néstor Rodríguez Vico

# 7 - Escribe una función comunes(palabra1, palabra2) que devuelva una cadena formada por 
# los caracteres comunes a las dos palabras.

def comunes(palabra1, palabra2):
    comunes = ""
    for i in palabra1:
        if i in palabra2:
            comunes += i
    return comunes

print(comunes("nestor", "tortilla"))
print(comunes("nestor", "azul"))
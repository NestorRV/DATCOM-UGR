# Alumno: Néstor Rodríguez Vico

# 5 - Escribe una función vocales(palabra) que devuelva las vocales que aparecen en la palabra.

def vocales(palabra):
    vocales = ""
    for i in palabra:
        if (i == "a" or i == "e" or i == "i" or i == "o" or i == "u"):
            vocales += i
    return vocales

print(vocales("supercalifragilisticoespialidoso"))
print(vocales("sprclfrglstcsplds"))
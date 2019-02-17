# Alumno: Néstor Rodríguez Vico

# 4 - Escribe una función num_vocales(palabra) que devuelva el número de vocales 
# que aparece en la palabra.

def num_vocales(palabra):
    counter = 0
    for i in palabra:
        if (i == "a" or i == "e" or i == "i" or i == "o" or i == "u"):
            counter += 1
    return counter

print(num_vocales("supercalifragilisticoespialidoso"))
print(num_vocales("sprclfrglstcsplds"))
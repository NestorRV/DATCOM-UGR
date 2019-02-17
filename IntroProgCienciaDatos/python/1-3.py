# Alumno: Néstor Rodríguez Vico

# 3 - Escribe una función buscar(palabra, sub) que devuelva la posición en la que se puede 
# encontrar sub dentro de palabra o -1 en caso de que no esté.

def buscar(palabra, sub):
    found = 0
    pos = -1
    for i in palabra:
        found += 1
        if (i == sub):
            return found
    return pos

print(buscar("supercalifragilisticoespialidoso", 'o'))
print(buscar("supercalifragilisticoespialidoso", 'x'))
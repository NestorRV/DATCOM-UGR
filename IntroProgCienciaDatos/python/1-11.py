# Alumno: Néstor Rodríguez Vico

# 11 - Escribe una función trocear(palabra, num) que devuelva una lista con trozos de tamaño 
# num de palabra.

def trocear(palabra, num):
    return [palabra[i:i+num] for i in range(0, len(palabra), num)]

print(trocear("nestor", 2))
print(trocear("nestor", 20))
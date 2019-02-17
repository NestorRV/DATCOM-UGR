# Alumno: Néstor Rodríguez Vico

# 8 - Escribe una función eco_palabra(palabra) que devuelva una cadena formada por palabra 
# repetida tantas veces como sea su longitud. Por ejemplo 'hola' -> 'holaholaholahola'

def eco_palabra(palabra):
    output = ""
    length = len(palabra)
    for i in range(length):
        output += palabra
    return output

print(eco_palabra("hola"))
print(eco_palabra("h"))
# Alumno: Néstor Rodríguez Vico

# 12 - Un anagrama de una palabra pal1 es una palabra formada con las mismas letras que pal1 
# pero en orden distinto. Escribe una función anagrama(palabra1, palabra2) que determine si es 
# una anagrama. Ejemplo: marta – trama,

def anagrama(palabra1, palabra2):
	return sorted(palabra1) == sorted(palabra2)

print(anagrama("marta", "trama"))
print(anagrama("marta", "random"))
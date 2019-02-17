# Alumno: Néstor Rodríguez Vico

# 1 - Escribe una función contar_letras(palabra, letra) que devuelva el número de veces que 
# aparece una letra en una palabra.

def contar_letras(palabra, letra):
	counter = 0
	for i in palabra:
		if (i == letra):
			counter += 1
	return counter

print(contar_letras("supercalifragilisticoespialidoso", 'o'))
print(contar_letras("supercalifragilisticoespialidoso", 'x'))
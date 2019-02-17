# Alumno: Néstor Rodríguez Vico

# 2 - Escribe una función eliminar_letras(palabra, letra) que devuelva una versión de 
# palabra que no contiene el carácter letra.

def eliminar_letras(palabra, letra):
	new = ''
	for i in palabra:
		if (i != letra):
			new += i
	return new

print(eliminar_letras("supercalifragilisticoespialidoso", 'o'))
print(eliminar_letras("supercalifragilisticoespialidoso", 'x'))
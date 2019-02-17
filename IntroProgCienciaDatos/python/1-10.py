# Alumno: Néstor Rodríguez Vico

# 10 - Escribe una función orden_alfabetico(palabra) que determine si las letras que forman 
# palabra aparecen en orden alfabético. Por ejemplo: 'abejo'

def orden_alfabetico(palabra):
    return palabra == ''.join(sorted(palabra))

print(orden_alfabetico("abejo"))
print(orden_alfabetico("random"))
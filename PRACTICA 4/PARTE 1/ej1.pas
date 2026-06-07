{Considere que desea almacenar en un archivo la información correspondiente a los alumnos de la
Facultad de Informática de la UNLP. De los mismos deberá guardarse nombre y apellido, DNI, legajo
y año de ingreso. Suponga que dicho archivo se organiza como un árbol B de orden M.}

// A
const
	M = ..; //Orden del arbol
type
	alumno = record
		nombre: string[20];
		apellido: string[20];
		dni: integer;
		legajo: integer;
		ingreso: string[4];
	end;
	
	nodo = record
		cant_datos: integer;
		datos: array[1..M-1] of alumno;
		hijos: array[1..M] of integer;
	end;
	arbolB : file of nodo;

var 
	archivo : arbolB;

// B
{Registro persona: 64 bytes
Tamaño nodo: 512 bytes
Integer: 4 bytes

 N = (M-1) * A + M * B + C
 N = tamaño del nodo (en bytes)
 A = tamaño de un registro.
 B = tamaño de cada enlace a un hijo.
 C = tamaño que ocupa el campo referido a la cantidad de claves. 
 
 512 = (M-1) * 64 + M * 4 + 4
 512 = 64M - 64 + 4m + 4
 512 = 68M - 60
 512 + 60 = 68M
 572 = 68M
 8 = M
 
 El orden del arbol seria 8, entrarian 7 registros persona.

}

// C
{
 El valor M determina la cantidad maxima de claves y de hijos que puede tener un arbol B. Cuanto mas grande sea M,
 mas datos se podran guardar.
}

// D
{
 Yo eligiria el dni ya que es un campo que requiere menos memoria y aparte es una clave unica ya que es imposible que se repitan,
 aunque tambien se podria utilizar el legajo ya que tampoco se repite pero es una cadena de caracteres mayor. Dependiendo de como
 guardes los datos, si como string o como integer.
}	

// E
{
 En el mejor de los casos necesitarias una sola ya que podria estar en el primer nodo, y en el peor de los casos
 tantas lecturas como sea la altura del arbol. 
}	

// F
{
 Si se desea buscar un alumno por un criterio diferente se debe tener en cuenta el árbol por completo, siendo necesarias n lecturas en el 
 peor de los casos, siendo n la cantidad total de nodos que hay en el árbol.
}	
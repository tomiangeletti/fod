//A
const
    M = .. //Orden del arbol
type
    alumno = record
        nombre: string;
        apellido: string;
        dni: integer;
        legajo: integer;
        anioIngreso: integer;
    end;
    nodo = record
        cant_claves: integer;
        claves: array[1..M-1] of longint;
        enlaces: array[1..M-1] of integer;
        hijos: array[1..M] of integer;
    end;
    TArchivoDatos = file of alumno;
    arbolB = file of nodo;
var
    archivoDatos: TArchivoDatos;
    archivoIndice: arbolB;

// B
{
	N = (M-1) * A + (M-1) * A + M * B + C
    512 = (M-1) * 4 + (M-1) * 4 + M * 4 + 4
    512 = 4M - 4 + 4M - 4 + 4M + 4
    512 = 12M - 4
    512 + 4 = 12M
    516 / 12 = M
    M = 43
    
	El orden del arbol B es de 43.
}

// C
{
	Implica que aumentan la cantidad de registros que caben en un nodo.
}

// D
{
	Se abre el archivo indice, se busca la clave 12345678, se guarda su posicion, cerras ese archivo
	y luego abris el de alumnos, y te paras en la posicion que te guardaste antes.
}

// E
{
	No, no tendria sentido usar el indice porque justamente ahi las claves son el DNI, tendrias que modificar
	la estructura del archivo indice para poder hacerlo.
}
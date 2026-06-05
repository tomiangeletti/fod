{Realizar un programa que gestione un archivo de libros de una librería. De cada libro se registra:
código, género, título, autor, cantidad de páginas y precio. El programa debe presentar un menú
con las siguientes opciones:

a. Crear el archivo y cargarlo con datos ingresados por teclado, utilizando la técnica de
lista invertida para recuperar espacio libre en el archivo.

b. Abrir el archivo existente y permitir su mantenimiento mediante las siguientes
operaciones:
	i. Dar de alta un libro leyendo la información desde el teclado. Para esta
	operación, en caso de ser posible, deberá recuperarse el espacio libre usando la
	lista invertida.
	ii. Modificar los datos de un libro leyendo la información desde el teclado. El
	código del libro no puede ser modificado.
	iii. Eliminar un libro cuyo código es ingresado por teclado.
c. Exportar el contenido del archivo de libros a un archivo de texto llamados “libros.txt”,
excluyendo los registros marcados como borrados.
NOTAS:

● Debe utilizar una lista invertida para la recuperación del espacio libre.
○ El primer registro del archivo se utiliza como cabecera de la lista.
■ El campo código de la cabecera tiene el valor cero (0) si no hay espacio libre.
■ Si el campo código de la cabecera tiene un valor negativo, indica la posición del
primer registro a reutilizar.
○ Los registros libres (aquellos marcados como borrados) utilizan el campo código como
enlace, almacenando la posición en forma negativa del siguiente registro en la lista
invertida
○ En la operación de alta:
■ Si la cabecera indica que hay espacio libre, se debe reutilizar el primer registro
disponible. Además, se debe actualizar la cabecera con la siguiente posición en
la lista invertida de espacios libres.
■ Si la cabecera indica que no hay espacio libre, se debe agregar el nuevo registro
al final del archivo.
○ En la operación de baja:
■ El registro borrado se debe incorporar a la lista invertida de espacios libres. Al ser
una lista invertida (o pila), el último registro borrado es el próximo a ser reutilizado.
Para ello, en el registro borrado se almacena el valor actual de la cabecera,
mientras que la cabecera se actualiza con la posición (en valor negativo) del
registro borrado.
● Tanto en la creación como en la apertura el nombre del archivo debe ser proporcionado por el
usuario}

program pr3ej3;
type
    libro = record
        codigo    : integer;
        genero    : string[30];
        titulo    : string[60];
        autor     : string[40];
        paginas   : integer;
        precio    : real;
    end;

    archivo = file of libro;
var
    arc : archivo;
    reg : libro;
    cab : libro;

procedure crearArchivo(var arch: archivo);
var
	l : libro;
	nombre: string;
begin
	cab.codigo := 0;
	writeln('[-] Ingrese el nombre del archivo: ')
	read(nombre);
	assign(arch, nombre);
	rewrite(arch);
	write(arch, cab); {ponemos la cabecera como primer registro como dice el enunciado}
	writeln('[-] Ingrese el codigo (0 para finalizar) : ');
	readln(l.codigo);
	while (l.codigo <> 0) do
	begin
		writeln('[-] Ingrese el genero'); readln(l.genero);
		writeln('[-] Ingrese el titulo'); readln(l.titulo);
		writeln('[-] Ingrese el autor'); readln(l.autor);
		writeln('[-] Ingrese las paginas'); readln(l.paginas);
		writeln('[-] Ingrese el precio'); readln(l.precio);
		write(arch,l);
		writeln('[-] Ingrese el codigo (0 para finalizar) : '); readln(l.codigo);
	end;
	close(arch);
end;

procedure leerLibro(var l : libro);
begin
	writeln('[-] Ingrese el codigo: '); readln(l.codigo);
	writeln('[-] Ingrese el genero: '); readln(l.genero);
	writeln('[-] Ingrese el titulo: '); readln(l.titulo);
	writeln('[-] Ingrese el autor: '); readln(l.autor);
	writeln('[-] Ingrese las paginas: '); readln(l.paginas);
	writeln('[-] Ingrese el precio: '); readln(l.precio);
end;

procedure escribirCabecera(var arch: archivo);
begin
	seek(arch, 0);
	write(arch, cab);
end;

procedure agregarLibro(var arch: archivo);
var
	l, aux : libro;
	pos: integer;
begin
	reset(arch);
	leerLibro(l);
	if (cab.codigo < 0) then
	begin
		pos := abs(cab.codigo); {devuelve la posicion en positivo}
		seek(arch, pos);
		read(arch, aux);
		seek(arch, pos);
		cab.codigo := aux.codigo;
		write(arch,l);
		escribirCabecera(arch);
	end
	else
		seek(arch, filesize(arch));
		write(arch,l);
	close(arch);
end;

procedure modificarDatos(var arch: archivo);
var
	l, aux : libro;
	codigo: integer;
	encontrado : boolean;
begin
	encontrado := false;
	reset(arch);
	seek(arch, 1); {ignoramos la posicion 0 porque es la cabecera}
	read(arch, l);
	writeln('[-] Ingrese el codigo del libro a modificar: '); readln(codigo);
	leerLibro(aux); {ignoramos el valor que el usuario ponga en el codigo, si no hay que hacer 1 millon de procedimientos}
	while (not(EOF(arch))) and (not(encontrado)) do
	begin
		if (l.codigo = codigo) then
		begin
			l.genero := aux.genero;
			l.titulo := aux.titulo;
			l.autor := aux.autor;
			l.paginas := aux.paginas;
			l.precio := aux.precio;
			l.codigo := codigo;
			seek(arch, filepos(arch) - 1);
			write(arch,l);
			encontrado := true;
		end
		else
			read(arch,l);
	end;
	if (not(encontrado)) then
		writeln('El codigo ingresado no existe.');
	close(arch);
end;

procedure eliminarLibro(var arch: archivo);
var
	codigo, pos, aux: integer;
	encontrado : boolean;
	l : libro;
begin
	encontrado := false;
	reset(arch);
	read(arch, cab);
	read(arch,l); {aca ya estamos en la posicion 1}
	writeln('[-] Escribe el codigo del libro a eliminar: '); readln(codigo);
	while (not(EOF(arch))) and (not(encontrado)) do
	begin
		if (l.codigo = codigo) then
		begin
			pos := filepos(arch) - 1;
			aux := cab.codigo;
			cab.codigo := -(pos);
			l.codigo := aux;
			escribirCabecera(arch);
			seek(arch,pos);
			write(arch,l);
			encontrado := true;
		end
		else
			read(arch,l);
	end;
	if (not(encontrado)) then
		writeln('[X] Error: no se pudo eliminar el archivo debido a que el codigo no exite.');
	close(arch);
end;

procedure exportar(var arch : archivo);
var
	txt : Text;
	l : libro;
begin
	reset(arch);
	assign(txt, 'texto');
	rewrite(txt);
	seek(arch, 1);
	read(arch, l);
	while (not(EOF(arch))) do
	begin
		if (l.codigo <= 0) then
			read(arch, l)
		else
		begin
			write(txt, l); {creo que solo soporta formato string o texto pero para no hacer el codigo mas largo, se entiende.}
			read(arch,l);
		end;
	end;
	close(arch);
	close(txt);
end;

{PROGRAMA PRINCIPAL}
var
	opcion : integer;
begin
	repeat
		writeln('1. Crear archivo.');
		writeln('2. Dar de alta un libro.');
		writeln('3. Modificar libro.');
		writeln('4. Eliminar un libro.');
		writeln('5. Exportar a txt.');
		writeln('6. Salir.');
		readln(opcion);
		case (opcion) of
			1: crearArchivo(arch);
			2: agregarLibro(arch);
			3: modificarDatos(arch);
			4: eliminarLibro(arch);
			5: exportar(arch);
			6: writeln('Saliendo');
		end;
	until (opcion = 6)
end.
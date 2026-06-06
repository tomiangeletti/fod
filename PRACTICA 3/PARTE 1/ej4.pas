{Se desea implementar un sistema de gestión de flores utilizando un archivo con reutilización de
espacio.
● Las bajas lógicas se realizan apilando los registros eliminados.
● Las altas deben reutilizar los espacios libres disponibles antes de agregar nuevos registros al final
del archivo.
● El registro en la posición 0 se utiliza como cabecera de la pila de registros borrados.
Política de reutilización:
● Si el campo código del registro cabecera es 0, significa que no hay registros borrados
disponibles.
● Si el campo código es -N, indica que el próximo registro libre se encuentra en la posición N del
archivo.
● Cada registro borrado debe almacenar en su campo codigo el valor negativo que apunte al
siguiente registro libre, formando así una pila enlazada.
a. Implementación requerida
Implementar el siguiente módulo:
{ Abre el archivo y agrega una flor, recibida como parámetro,
respetando la política de reutilización de espacio descripta }
{procedure agregarFlor (var a: tArchFlores; nombre: string; codigo: integer);
b. Listado del archivo
Realizar un procedimiento que liste el contenido del archivo omitiendo las flores eliminadas (es
decir, aquellos registros que forman parte de la pila de libres).
Se permite modificar o agregar estructuras auxiliares si se considera necesario para obtener
correctamente el listado.
c. Implemente el siguiente módulo:
{Abre el archivo y elimina la flor recibida como parámetro manteniendo la
política descripta anteriormente}
{procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);}

program pr3ej4;
type
	reg_flor = record
		nombre: string[45];
		codigo : integer;
	end;
	tArchFlores := file of reg_flor;

var
	arch: tArchFlores
	cab, reg : reg_flor;

procedure escribirCabecera(var arch: tArchFlores);
begin
	seek(arch, 0);
	write(arch,cab);
end;

procedure agregarFlor(var a: tArchFlores; nombre: string; codigo: integer);
var
	pos : integer;
begin
	reset(a);
	if (cab.codigo < 0) then {significa que se puede reutilizar espacio}
	begin
		pos := abs(cab.codigo);
		seek(a, pos);
		read(a, reg);
		seek(a, pos);
		cab.codigo := reg.codigo;
		reg.nombre := nombre;
		reg.codigo := codigo;
		write(a,reg);
		escribirCabecera(a);
	end
	else
	begin
		seek(a, filesize(a));
		reg.nombre := nombre;
		reg.codigo := codigo;
		write(a,reg);
	end;
	close(a);
end;

procedure listarFlores(var arch : tArchFlores);
begin
	reset(arch);
	seek(arch, 1);
	read(arch,reg);
	while (not(EOF(arch))) do
	begin
		if (reg.codigo > 0) then
		begin
			writeln('Nombre: ', reg.nombre, ' Codigo: ', reg.codigo);
		end;
		read(arch,reg);
	end;
	close(arch);
end;

procedure eliminarFlor (var arch: tArchFlores; flor:reg_flor);
var
	pos, aux: integer;
	ok : boolean;
begin
	reset(arch);
	ok := false;
	seek(arch, 1);
	read(arch, reg);
	while (not(EOF(arch))) and (not(ok)) do
	begin
		if (reg.nombre = flor.nombre) and (reg.codigo = flor.codigo) then
		begin
			pos := filepos(arch) - 1;
			aux := cab.codigo;
			cab.codigo := -(pos);
			reg.codigo := aux;
			escribirCabecera(arch);
			seek(arch,pos);
			write(arch,reg);
			ok := true;
		end
		else
			read(arch,reg);
	end;
	close(arch); {suponemos que la flor existia}
end;

{otra vez el programa principal me dio paja :D}


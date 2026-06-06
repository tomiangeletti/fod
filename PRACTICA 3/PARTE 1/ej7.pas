{Se cuenta con un archivo con información de las diferentes distribuciones de linux existentes.
De cada distribución se conoce: nombre, año de lanzamiento, número de versión del kernel, cantidad
de desarrolladores y descripción. 
El nombre de las distribuciones no puede repetirse. Este archivo
debe ser mantenido realizando bajas lógicas y utilizando la técnica de reutilización de espacio libre
llamada lista invertida. Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:

a. BuscarDistribucion: módulo que recibe por parámetro el archivo, un nombre de
distribución y devuelve la posición dentro del archivo donde se encuentra el registro
correspondiente a la distribución dada (si existe) o devuelve -1 en caso de que no
exista.

b. AltaDistribucion: módulo que recibe como parámetro el archivo y el registro que
contiene los datos de una nueva distribución, y se encarga de agregar la distribución al
archivo reutilizando espacio disponible en caso de que exista. El control de unicidad lo
debe realizar utilizando el módulo anterior. En caso de que la distribución que se quiere
agregar ya exista se debe informar “ya existe la distribución”.

c. BajaDistribucion: módulo que recibe como parámetro el archivo y el nombre de una
distribución, y se encarga de dar de baja lógicamente la distribución dada. Para marcar
una distribución como borrada se debe utilizar el campo cantidad de desarrolladores
para mantener actualizada la lista invertida. Para verificar que la distribución a borrar
exista debe utilizar el módulo BuscarDistribucion. En caso de no existir se debe informar
“Distribución no existente”.}

program pr3ej7;
type
	distro = record
		nombre: string;
		anio: string;
		kernel: string;
		desarolladores: integer;
		descripcion: string;
	end;
	
	archivo : file of distro;

var
	arch: archivo;
	cab: distro;

procedure escribirCabecera(var arch: archivo);
begin
	seek(arch, 0);
	write(arch,cab);
end;

function buscarDistribucion(var arch: archivo; dato : string): integer;
var
	pos : integer;
	d : distro;
	ok : boolean;
begin
	ok := false;
	pos := -1; {en el caso que no exista}
	reset(arch);
	seek(arch,1);
	read(arch, d);
	while (not(EOF(arch))) and (not(ok)) do
	begin
		if (d.nombre = dato) then
		begin
			pos := filepos(arch) - 1;
			ok := true;
			read(arch,d);
		end
		else
			read(arch,d);
	end;
	close(arch);
	buscarDistribucion := pos;
end;

procedure altaDistribucion(var arch: archivo; dato : distro);
var
	aux, pos : integer;
	d : distro;
begin
	aux := buscarDistribucion(arch,dato.nombre);
	if (aux <> -1) then
	begin
		writeln('[X] Error: la distribucion', dato.nombre, ' ya existe.');
	end
	else
	begin
		reset(arch);
		if (cab.desarolladores < 0) then
		begin
			pos := abs(cab.desarolladores);
			seek(arch, pos);
			read(arch, d);
			seek(arch, pos);
			cab.desarolladores := d.desarolladores;
			write(arch, dato);
			escribirCabecera(arch);
		end
		else
		begin
			seek(arch, filesize(arch));
			write(arch, dato);
		end;
	end;
	close(arch);
end;

procedure bajaDistribucion(var arch: archivo; dato : distro);
var
	pos, aux : integer;
	d : distro;
begin
	pos := buscarDistribucion(arch, dato.nombre);
	if (pos = -1) then
	begin
		writeln('[X] Error: la distribucion', dato.nombre, ' no existe.');
	end
	else
	begin
		reset(arch);
		read(arch, cab);
		aux := cab.desarolladores;
		cab.desarolladores := -(pos);
		d.desarolladores := aux;
		escribirCabecera(arch);
		seek(arch, pos);
		write(arch, dato);
	end;
	close(arch);
end;
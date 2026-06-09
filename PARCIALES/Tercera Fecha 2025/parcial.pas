program parcialMascotas;
type
	mascota = record
		codigo: integer;
		nombre: string;
		especie: string;
		edad: integer;
		duenio: string;
		telefono: string;
	end;
	
	archivo: file of mascota;
	
var
	arc: archivo;
	cab, reg: mascota;

function existeMascota(var arc: archivo; dato : integer): integer;
var
	pos : integer;
	ok : boolean;
begin
	reset(arc);
	pos := 0;
	ok := false;
	seek(arc, 1);
	read(arc,reg);
	while (not(EOF(arc))) and (not(ok)) do
	begin
		if (reg.codigo = dato) then
		begin
			pos := filepos(arc) - 1;
			ok := true;
		end;
		read(arc,reg);
	end;
	close(arc);
	existeMascota := pos;
end;

procedure leerMascota(var m : mascota);
begin
	writeln('Ingrese el codigo: '); readln(m.codigo);
	writeln('Ingrese el nombre: '); readln(m.nombre);
	writeln('Ingrese la especie: '); readln(m.especie);
	writeln('Ingrese la edad: '); readln(m.edad);
	writeln('Ingrese el dueño: '); readln(m.duenio);
	writeln('Ingrese el telefono: '); readln(m.telefono);
end;

procedure escribirCabecera(var arch: archivo);
begin
	seek(arch, 0);
	write(arch,cab);
end;

procedure altaMascota(var arc : archivo);
var
	aux, pos : integer;
	m : mascota;
begin
	leerMascota(m);
	aux := existeMascota(arc, m.codigo);
	if (aux <> 0) then
	begin
		writeln('Error, el codigo ya existe.');
	end
	else
	begin
		reset(arc);
		if (cab.codigo < 0 ) then
		begin
			pos := abs(cab.codigo);
			seek(arc, pos);
			read(arc,reg);
			seek(arc,pos);
			cab.codigo := reg.codigo;
			write(arc,m);
			escribirCabecera(arc);
		end
		else
		begin
			seek(arc, filesize(arc));
			write(arc,m);	
		end;
	end;
	close(arc);
end;

procedure bajaMascota(var arc: archivo);
var
	cod, pos, aux : integer;
begin
	writeln('Ingrese el codigo a eliminar: '); readln(cod);
	pos := existeMascota(arc, cod);
	if (pos = 0) then 
		writeln('Error, mascota no registrada.')
	else
	begin
		reset(arc);
		read(arc,cab);
		aux := cab.codigo;
		seek(arc, pos);
		read(arc,reg);
		seek(arc,pos);
		cab.codigo := -(reg.codigo);
		reg.codigo := aux;
		write(arc,reg);
		escribirCabecera(arc);
	end;
	close(arc);
end;
	
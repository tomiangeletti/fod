program parcialLPF;
const
	VALOR_ALTO = '99999999';
type
	equipo = record
		codigo: string[20];
		nombre: string[20];
		jugados: integer;
		ganados: integer;
		empatados: integer;
		perdidos: integer;
		puntos: integer;
	end;

	dato_det = record
		codigo: string[20];
		fecha: string;
		puntos: integer;
		codigo_rival: string[20];
	end;
	
	maestro: file of equipo;
	detalle: file of dato_det;
	vector_archivo = array[1..12] of detalle;
	vector_registro = array[1..12] of dato_det;

var
	mae: maestro;
	regm: equipo;
	regd, min: dato_det;
	v_arc: vector_archivo;
	v_reg: vector_registro;
	
procedure reiniciarAux(var e : equipo);
begin
	e.ganados := 0;
	e.empatados := 0;
	e.perdidos := 0;
	e.puntos := 0;
	e.jugados := 0;
end;

procedure sumarMaestro(e : equipo; var m : equipo);
begin
	m.ganados := m.ganados + e.ganados;
	m.empatados := m.empatados + e.empatados;
	m.perdidos := m.perdidos + e.perdidos;
	m.puntos := m.puntos + e.puntos;
	m.jugados := m.jugados + e.jugados;
end;

procedure leer(var archivo: detalle; var dato: dato_det);
begin
	if (not(EOF(archivo))) then
		read(archivo,dato)
	else
		dato.codigo := VALOR_ALTO;
end;

procedure leerPrimerRegistro(var v_arc : vector_archivo; var v_reg : vector_registro);
var
	i : integer
begin
	for (i := 1 to 12) do
	begin
		reset(v_arc[i]);
		leer(v_arc[i], v_reg[i]);
	end;
end;


procedure minimo(var v_arc : vector_archivo; var v_reg : vector_registro; var min : dato_det);
var
	i, posMin: integer
begin
	min.codigo := VALOR_ALTO;
	for (i := 1 to 12) do
	begin
		if (v_reg[i] < min.codigo) then
		begin
			min := v_reg[i];
			posMin := i;
		end;
	end;
	leer(v_arc[posMin], v_reg[posmin]);
end;


procedure actualizarMaestro(var v_arc : vector_archivo; var v_reg : vector_registro; var min : dato_det; var mae: maestro);
var
	max: integer
	codActual, max_nombre: string;
	aux: equipo;
begin
	reset(mae);
	max := -1
	read(mae,regm);
	leerPrimerRegistro(v_arc, v_reg);
	minimo(v_arc, v_reg, min);
	while (min.codigo <> VALOR_ALTO) do
	begin
		codActual := min.codigo;
		reiniciarAux(aux); {aca toma valores 0 en los campos que necesita.}
		while (min.codigo = codActual) do
		begin
			aux.puntos := aux.puntos + min.puntos;
			aux.jugados := aux.jugados + 1;
			if (min.puntos = 3) then begin
				aux.ganados := aux.ganados + 1;
			end
			else if (min.puntos = 1) then 
			begin
				aux.empatados := aux.empatados + 1;
			end
			else if (min.puntos = 0) then
			begin
				aux.perdidos := 0;
			end
			minimo(v_arc, v_reg, min);
		end;
		if (aux.puntos > max) then
			max := aux.puntos;
			max_nombre := aux.nombre
		while (regm.codigo <> codActual) do
		begin
			read(mae,regm);
		end;
		sumarMaestro(aux,regm);
		seek(mae, filepos(mae) - 1);
		write(mae, regm);
	end;
end;

procedure cerrarArchivos(var v_arc : vector_archivo);
var
	i : integer;
begin
	for (i := 1 to 12) do
	begin
		close(v_arc[i]);
	end;
end;

{PROGRAMA PRINCIPAL}
var
	i : integer;
	nom: string;
begin
	for (i := 1 to 12) do
	begin
		writeln('Escriba el nombre del archivo ', i, ':'); readln(nom);
		assign(v_arc[i], nom);
	end;
	actualizarMaestro(v_arc, v_reg, min, mae);
	cerrarArchivos(v_arc);
end.
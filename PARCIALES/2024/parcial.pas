program parcial;
const
	VALOR_ALTO = 999999;
	DF = 30;
type
	municipio = record
		codigo : integer;
		nombre : string[20];
		casos : integer;
	end;
	
	dato_det = record
		codigo : integer;
		casos : integer;
	end;
	
	maestro : file of municipio;
	detalle : file of dato_det;
	vector_archivos = array[1..DF] of detalle;
	vector_registros = array[1..DF] of dato_det;

var
	mae : maestro;
	regm : municipio;
	v_arc : vector_archivos;
	v_reg : vector_registros;
	min : dato_det;
	
procedure leer(var archivo : detalle; var dato : dato_det);
begin
	if (not(EOF(archivo))) then
		read(archivo, dato)
	else
		dato.codigo := VALOR_ALTO;
end;

procedure leerPrimerRegistro(var v_arc :vector_archivos; var v_reg : vector_registros);
var
	i : integer
begin
	for (i := 1 to DF) do
	begin
		reset(v_arc[i]);
		leer(v_arc[i], v_reg[i]);
	end;
end;

procedure minimo(var v_arc :vector_archivos; var v_reg : vector_registros; var min : dato_det);
var
	i, posMin : integer;
begin
	min.codigo := VALOR_ALTO;
	for (i := 1 to DF) do
	begin
		if (v_reg[i].codigo < min.codigo) then
		begin
			min := v_reg[i];
			posMin := i;
		end;
	end;
	leer(v_arc[posMin], v_reg[posMin]);
end;

procedure actualizarMaestro(var v_arc :vector_archivos; var v_reg : vector_registros; var min : dato_det; var mae : maestro);
var
	casosTot, codAct : integer;
begin
	leerPrimerRegistro(v_arc, v_reg);
	reset(mae);
	read(mae, regm);
	minimo(v_arc, v_reg, min);
	while (minimo.codigo <> VALOR_ALTO) do
	begin
		casosTot := 0;
		codAct := minimo.codigo;
		while (codAct = min.codigo) do
		begin
			casosTot := casosTot + min.casos;
			minimo(v_arc, v_reg, min);
		end;
		while (regm.codigo <> codAct) do
		begin
			read(mae, regm);
		end;
		seek(mae, filepos(mae) - 1);
		regm.casos := regm.casos + casosTot;
		if (regm.casos > 15) then
			writeln('El municipio ', regm.nombre, ' con codigo ', regm.codigo, ' tiene mas de 15 casos positivos.');
		write(mae, regm);
	end;
	close(mae);
end;

procedure cerrarArchivos(var v : vector_archivos);
var
	i : integer;
begin
	for (i := 1 to DF) do
	begin
		close(v[i]);
	end;
end;

procedure pedirNombres(var v : vector_archivos);
var
	i : integer;
	nombre : string;
begin
	for (i := 1 to DF) do
	begin
		writeln('Ingrese el nombre del archivo ', i); readln(nombre);
		assign(v[i], nombre);
	end;
end;

{PROGRAMA PRINCIPAL}
begin
	pedirNombres(v_arc);
	assign(mae, 'maestro');
	actualizarMaestro(v_arc, v_reg, min, mae);
	cerrarArchivos(v_arc);
end.
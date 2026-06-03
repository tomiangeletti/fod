{Se desea modelar la información necesaria para un sistema de recuento de casos de COVID del
Ministerio de Salud de la Provincia de Buenos Aires.

Diariamente se reciben 10 archivos detalle provenientes de distintos municipios. La información contenida
en cada uno de ellos es la siguiente: código de localidad, código de cepa, cantidad de casos activos,
cantidad de casos nuevos, cantidad de casos recuperados y cantidad de casos fallecidos.

El ministerio cuenta con un archivo maestro que almacena la siguiente información: código de localidad,
nombre de la localidad, código de cepa, nombre de la cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de casos recuperados y cantidad de casos fallecidos.

Todos los archivos están ordenados por código de localidad y código de cepa.

Se solicita desarrollar el procedimiento que permita actualizar el archivo maestro a partir de los 10 archivos
detalle, teniendo en cuenta el siguiente criterio:
● A la cantidad de casos fallecidos del maestro se le debe sumar el valor recibido en el detalle.

● A la cantidad de casos recuperados del maestro se le debe sumar el valor recibido en el detalle.

● La cantidad de casos activos del maestro debe actualizarse con el valor recibido en el detalle.

● La cantidad de casos nuevos del maestro debe actualizarse con el valor recibido en el detalle.

Realizar las declaraciones necesarias, el programa principal y los procedimientos que se requieran para
efectuar la actualización solicitada.

Además, informar la cantidad de localidades que poseen más de 50 casos activos, independientemente de
que hayan sido actualizadas o no.}

program pr2ej6;
const
	VALOR_ALTO = '999999999999';
	DF = 10;
type
	info_det = record
		cod_loc: string;
		cod_cepa: string;
		casos_activos: integer;
		casos_nuevos: integer;
		casos_rec: integer;
		fallecidos: integer;
	end;
	
	info_mae = record
		cod_loc: string;
		nombre_loc: string;
		cod_cepa: string;
		casos_activos: integer;
		casos_nuevos: integer;
		casos_rec: integer;
		fallecidos: integer;
	end;
	
	maestro : file of info_mae;
	detalle: file of info_det;
	vector_arc = array[1..DF] of detalle;
	vector_reg = array[1..DF] of info_det;

var
	v_arc: vector_arc;
	v_reg: vector_reg;
	regm: info_mae;
	mae: maestro;
	min: info_det;
	
procedure leer(var archivo: detalle; var dato: info_det);
begin
	if (not(EOF(archivo))) then
		read(archivo,dato)
	else
		dato.cod_loc := VALOR_ALTO;
end;

procedure leerPrimerRegistro(var v_arc: vector_arc; var v_rec: vector_reg);
var
	i: integer;
begin
	for (i := 1 to DF) do
	begin
		reset(v_arc[i]);
		read(v_arc[i], v_reg[i]);
	end;
end;

procedure minimo(var v_arc: vector_arc; var v_rec: vector_reg; var min: info_det);
var
	i, posMin: integer;
begin
	{ordenado por codigo de LOCALIDAD y codigo de CEPA.}
	min.cod_loc := VALOR_ALTO;
	for (i := 1 to DF) do
	begin
		if (v_reg[i].cod_loc < min.cod_loc) then
		begin
			posMin := i;
			min := v_reg[i];
		end
		else if (v_reg[i].cod_loc = min.cod_loc) then
		begin
			if (v_reg[i].cod_cepa < min.cod_cepa) then
			begin
				posMin := i;
				min := v_reg[i];
			end;
		end;
	end;
	leer(v_arc[posMin], v_reg[posMin]);
end;

procedure actualizarDatos(var mae: maestro, var regm: info_mae; fallecidos, recuperados, activos, nuevos,: integer; codLocAct, codCepAct : string);
{Actualiza los datos del registro, lo hice para mejor legibilidad ;~}
begin
	regm.cod_loc:= codLocAct;
	regm.cod_cepa:= codCepAct;
	regm.casos_activos := activos;
	regm.casos_nuevos := nuevos;
	regm.casos_rec := regm.casos_rec + recuperados;
	regm.fallecidos := regm.fallecidos + fallecidos;
	seek(mae, filepos(mae) - 1);
	write(mae,regm);
end;

procedure actualizarMaestro(var v_arc: vector_arc; var v_rec: vector_reg; var min: info_det; var mae: maestro);
var
	fallecidos, recuperados, activos, nuevos, cantLocCumple: integer;
	codLocAct, codCepAct: string;
begin
	cantLocCumple := 0;
	reset(mae);
	leerPrimerRegistro(v_arc, v_rec);
	minimo(v_arc, v_reg, min);
	read(mae, regm);
	
	while(min.cod_loc <> VALOR_ALTO) do
	begin
		fallecidos, recuperados, activos, nuevos := 0;
		codLocAct := min.cod_loc;
		codCepAct := min.cod_cepa;
		while (codLocAct = min.cod_loc) and (codCepAct = min.cod_cepa) do
		begin
			fallecidos := fallecidos  + min.fallecidos;
			recuperados := recuperados + min.casos_rec;
			activos := activos + min.casos_activos;
			nuevos := nuevos + min.casos_nuevos;
			minimo(v_arc, v_reg, min);
		end;
		while (regm.cod_loc <> codLocAct) or (regm.cod_cepa <> codCepAct) do
		begin
			read(mae,regm);

		end;
		actualizarDatos(mae, regm, fallecidos, recuperados, activos, nuevos);
	end;
end;

procedure cerrarArchivos(var v_arc : vector_arc);
var
	i : integer;
begin
	for (i := 1 to DF) do
	begin
		close(v_arc[i]);
	end;
end;

procedure contarLocalidades(var mae: maestro);
var
	cant, total : integer;
	act: string;
begin
	reset(mae);
	total := 0;
	read(mae, regm);
	while (regm.cod_loc <> VALOR_ALTO) do
	begin
		cant := 0;
		act := regm.cod_loc;
		while (regm.cod_loc = act) do
		begin
			cant := cant + regm.casos_activos;
			if not EOF(mae) then
				read(mae, regm)
			else
				regm.cod_loc := VALOR_ALTO;
			end;
		end;
		if (cant > 50) then
			total := total + 1;
	end;
	writeln('La cantidad de localidades con mas de 50 casos activos es: ', total);
end;

{PROGRAMA PRINCIPAL}
begin
	assign(mae, 'maestro');
	actualizarMaestro(v_arc, v_reg, min, mae);
	cerrarArchivos(v_arc);
	contarLocalidades(mae);
	close(mae);
end.
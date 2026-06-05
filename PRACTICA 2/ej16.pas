{La editorial X, autora de diversos semanarios, posee un archivo maestro con la información
correspondiente a las diferentes emisiones de los mismos. De cada emisión se registra: fecha, código
de semanario, nombre del semanario, descripción, precio, total de ejemplares y total de ejemplares
vendidos.

Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el país. La
información que poseen los detalles es la siguiente: fecha, código de semanario y cantidad de
ejemplares vendidos. Realice las declaraciones necesarias, la llamada al procedimiento y el
procedimiento que recibe el archivo maestro y los 100 detalles y realice la actualización del archivo
maestro en función de las ventas registradas. Además deberá informar fecha y semanario que tuvo más
ventas y la misma información del semanario con menos ventas.

Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan ventas de
semanarios si no hay ejemplares para hacerlo}

program pr2ej16;
const
	VALOR_ALTO = 'ZZZZZZZZZZZZZZZZ';
	DF = 100;
type
	emision = record
		fecha: string;
		codigo: string;
		nombre: string;
		descripcion: string;
		precio: real;
		ejemplares: integer;
		ejemplares_vendidos: integer;
	end;
	
	venta = record
		fecha: string;
		codigo: string;
		ejemplares_vendidos: integer;
	end;
	
	maestro: file of emision;
	detalle: file of venta;
	
	vector_arc = array[1..DF] of detalle;
	vector_reg = array[1..DF] of venta;

var
	mae: maestro;
	v_arc: vector_arc;
	v_reg: vector_reg;
	regm: emision;
	min: venta;

procedure leer(var archivo: detalle; var dato: venta);
begin
	if (not(EOF(archivo))) then
		read(archivo, dato)
	else
		dato.fecha := VALOR_ALTO;
end;

procedure leerPrimerRegistro(var v_arc : vector_arc; var v_reg : vector_reg);
var
	i : integer;
begin
	for (i := 1 to DF) do
	begin
		reset(v_arc[i]);
		leer(v_arc[i], v_reg[i]);
	end;
end;

procedure minimo(var v_arc : vector_arc; var v_reg : vector_reg; var min : venta);
var
	i, posMin : integer;
begin
	posMin := -1;
	min.fecha := VALOR_ALTO;
	for (i := 1 to DF) do
	begin
		if (v_reg[i].fecha < min.fecha) then
		begin
			min := v_reg[i];
			posMin := i;
		end
		else if (v_reg[i].fecha = min.fecha) then
		begin
			if (v_reg[i].codigo < min.codigo) then
			begin
				min := v_reg[i];
				posMin := i;
			end;
		end;
	end;
	leer(v_arc[posMin], v_reg[posMin]);
end;

procedure actualizarMaestro(var mae: maestro; var v_arc : vector_arc; var v_reg : vector_reg; var min : venta; var regm: emision);
var
	fechaAct, codAct, : string;
	maximo, ventaminimo : venta;
	i, cont: integer;
begin
	leerPrimerRegistro(v_arc, v_reg);
	reset(mae);
	read(mae, regm);
	minimo(v_arc, v_reg, min);
	minimo := min;
	maximo := min;
	while (min.fecha <> VALOR_ALTO) do
	begin
		cont := 0;
		fechaAct := min.fecha;
		codAct := min.codigo;
		while (min.fecha = fechaAct) and (min.codigo = codAct)do
		begin
			cont := cont + min.ejemplares_vendidos;
			minimo(v_arc, v_reg, min);
		end;
		if (ventaMinimo.ejemplares_vendidos > cont) then
				ventaMinimo := min
			else if (maximo.ejemplares_vendidos < cont) then
				maximo := min;
		while (regm.fecha <> fechaAct) or (regm.codigo <> codAct) do
		begin
			read(mae, regm);
		end;
		regm.ejemplares_vendidos := regm.ejemplares_vendidos + cont;
		seek(mae, filepos(mae) - 1);
		write(mae,regm);
	end;
	writeln('Seminario con mas ventas: ', maximo.codigo, 'Fecha: ', maximo.fecha);
	writeln('Seminario con menos ventas: ', ventaMinimo.codigo, 'Fecha', ventaMinimo.fecha);
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

{PROGRAMA PRINCIPAL}
begin
	assign(mae, 'maestro');
	actualizarMaestro(mae, v_arc, v_reg, min, regm);
	close(mae);
	cerrarArchivos(v_arc);
end.
{Suponga que trabaja en una oficina donde se encuentra instalada una red local (LAN). La misma está
conformada por 5 máquinas conectadas entre sí y a un servidor central.

Semanalmente, cada máquina genera un archivo detalle de logs que registra las sesiones abiertas por los
usuarios en cada terminal, junto con su duración. Cada archivo contiene los siguientes campos: código de
usuario, fecha y tiempo de sesión.

Se solicita desarrollar un procedimiento que reciba los archivos detalle y genere un archivo maestro con la
siguiente información: código de usuario, fecha y tiempo total de sesiones abiertas.

Notas:
● Cada archivo detalle está ordenado por código de usuario y fecha.

● Un usuario puede iniciar más de una sesión el mismo día, ya sea en la misma máquina o en
diferentes máquinas.}

program pr2ej5;
const
	VALOR_ALTO = '999999999';
	DF = 5;
type
	usuario = record
		codigo: string;
		fecha: string;
		tiempo: integer;
	end;
	
	det: file of usuario;
	mae: file of usuario;
	vector_arc = array[1..DF] of det;
	vector_reg = array[1..DF] of usuario;

var
	maestro: mae;
	v_arc: vector_arc;
	v_reg: vector_reg;
	regm, min: usuario;
	
procedure leer(var archivo: det; var dato: usuario);
begin
	if (not(EOF(archivo))) then
		read(archivo,dato)
	else
		dato.codigo := VALOR_ALTO;
end;

procedure leerPrimerRegistro(var v_arc: vector_arc; var v_reg: vector_reg);
var
	i: integer;
begin
	for (i := 1 to DF) do
	begin
		reset(v_arc[i]);
		leer(v_arc[i], v_reg[i]);
	end;
end;

procedure minimo(var v_arc: vector_arc; var v_reg: vector_reg; var min: usuario);
var
	i, posMin: integer;
begin
	min.codigo := VALOR_ALTO;
	for (i := 1 to DF) do
	begin
		if (v_reg[i].codigo < min.codigo) then
		begin
			posMin := i;
			min := v_reg[i];
		end
		else if (v_reg[i].codigo = min.codigo) then
		begin
			if (v_reg[i].fecha < min.fecha) then
			begin
				posMin := i;
				min := v_reg[i];
			end;
		end;
	end;
	leer(v_arc[posMin],v_reg[posMin]);
end;

procedure crearMaestro(var maestro: mae; var v_arc: vector_arc; var v_reg: vector_reg; var min: usuario);
var
	codActual, fechaActual: string;
	tiempoTot: integer;
begin
	rewrite(maestro);
	leerPrimerRegistro(v_arc, v_reg);
	minimo(v_arc, v_reg, min);
	while (min.codigo <> VALOR_ALTO) do
	begin
		codActual := min.codigo;
		fechaActual := min.fecha;
		tiempoTot := 0;
		while (codActual = min.codigo) and (fechaActual = min.fecha) do
		begin
			tiempoTot := tiempoTot + min.tiempo;
			minimo(v_arc, v_reg, min);
		end;
		regm.codigo := codActual;
		regm.fecha := fechaActual;
		regm.tiempo := tiempoTot;
		write(maestro,regm);
	end;
end;

procedure cerrarArchivos(var v_arc: vector_arc);
var
	i: integer;
begin
	for (i := 1 to DF) do
	begin
		close(v_arc[i]);
	end;
end;

{PROGRAMA PRINCIPAL}
begin
	crearMaestro(maestro, v_arc, v_reg, min);
	cerrarArchivos(v_arc);
end.
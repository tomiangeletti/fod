{Se tiene información en un archivo de las horas extras realizadas por los empleados de una empresa en
un mes. 
Para cada empleado se tiene la siguiente información: departamento, división, número de 
empleado, categoría y cantidad de horas extras realizadas por el empleado. Se sabe que el archivo se
encuentra ordenado por departamento, luego por división y, por último, por número de empleado.

Presentar en pantalla un listado con el siguiente formato:
Departamento
División
Número de Empleado Total de Hs. Importe a cobrar
...... .......... .........
...... .......... .........
Total de horas división: ____
Monto total por división: ____
División
.................
Total horas departamento: ____
Monto total departamento: ____

Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al iniciar el
programa con el valor de la hora extra para cada categoría. La categoría varía de 1 a 15. En el
archivo de texto debe haber una línea para cada categoría con el número de categoría y el valor de la
hora, pero el arreglo debe ser de valores de horas, con la posición del valor coincidente con el
número de categoría.}

program pr2ej11;
const
	VALOR_ALTO = 'ZZZZZZZZZ';
type
	empleado = record
		departamento: string;
		division: string;
		numero: string;
		categoria: integer;
		horasExtra: real;
	end;
	
	valores_horas = array[1..15] of real;
	
	maestro: file of empleado;

var
	mae: maestro;
	regm: empleado;
	vector: valores_horas;
	txt: Text;

procedure cargarVector(var v : valores_horas);
var
	i, cat: integer;
	monto: real;
begin
	assign(txt, 'texto');
	reset(txt);
	for (i := 1 to 15) do
	begin
		read(txt, cat, monto);
		v[cat] := monto;
	end;
	close(txt);
end;

procedure leer(var archivo: maestro; var dato: empleado);
begin
	if (not(EOF(archivo))) then
		read(archivo,dato)
	else
		dato.departamento := VALOR_ALTO;
end;

procedure reportar(var mae: maestro; var v :valores_horas; var regm: empleado);
var
	dptoActual, divActual, nroActual: string;
	totHorasDiv, montoTotDiv, totHorasDpto, montoTotalDpto, importe: real;
begin
	cargarVector(v);
	leer(mae,regm);
	while (regm.departamento <> VALOR_ALTO) do
	begin
		dptoActual := regm.departamento;
		writeln('--------------------------------');
		writeln('Departamento: ', dptoActual);
		totHorasDpto := 0;
		montoTotalDpto := 0;
		while (regm.departamento = dptoActual) do
		begin
			divActual := regm.division;
			writeln('--------------------------------');
			writeln('División: ', divActual);
			totHorasDiv := 0;
			montoTotDiv := 0;
			while (regm.departamento = dptoActual) and (regm.division = divisionActual) do
			begin
				nroActual := regm.numero;
				writeln('--------------------------------');
				writeln('Numero de empleado 	Total de hs.	Importe a cobrar');
				while (regm.departamento = dptoActual) and (regm.division = divActual) and (regm.numero = nroActual) do
				begin
					importe := regm.horasExtra * v[regm.categoria];
					totHorasDiv := totHorasDiv + regm.horasExtra;
					montoTotDiv := montoTotDiv + importe;
					writeln(nroActual, '	', regm.horasExtra, '	', importe);
					leer(mae, regm);
				end;
			end;
			montoTotalDpto := montoTotalDpto + montoTotDiv;
			totHorasDpto := totHorasDpto + totHorasDiv;
			writeln('Total de horas division: ', totHorasDiv);
			writeln('Monto total por division: ', montoTotDiv);
			writeln('--------------------------------');
		end;
		writeln('Total horas departamento: ', totHorasDpto);
		writeln('Monto total departamento: ', montoTotalDpto);
	end;
	close(mae);
end;

{PROGRAMA PRINCIPAL}
begin
	assign(mae, 'maestro');
	reportar(mae, v, regm);
end.
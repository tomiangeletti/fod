{Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus próximos
vuelos. 
En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la cantidad de asientos
disponibles. 

La empresa recibe todos los días dos archivos detalles para actualizar el archivo maestro.

En dichos archivos se tiene destino, fecha, hora de salida y cantidad de asientos comprados. 

Se sabe que los archivos están ordenados por destino más fecha y hora de salida, y que en los detalles pueden
venir 0, 1 ó más registros por cada uno del maestro. 
Se pide realizar los módulos necesarios para:
a. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje sin asiento
disponible.

b. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que tengan menos de
una cantidad específica de asientos disponibles. La misma debe ser ingresada por teclado.

NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez}

program pr2ej14;
const
	VALOR_ALTO = 'ZZZZZZZZZZZZ';
type
	vuelos = record
		destino: string;
		fecha: string;
		hora: string;
		asientos: integer;
	end;
	
	datos_det = record
		destino: string;
		fecha: string;
		hora: string;
		asientos_comprados: integer;
	end;
	
	maestro: file of vuelos;
	detalle: file of datos_det;
var
	mae: maestro;
	regm: vuelos;
	det1: detalle;
	det2: detalle;
	regd1, regd2, min: datos_det;

procedure leer(var archivo: detalle; var dato: datos_det);
begin
	if (not(EOF(archivo))) then
		read(archivo, dato)
	else
		dato.destino := VALOR_ALTO;
end;

procedure minimo(var det1, det2: detalle; var regd1, regd2, min: datos_det);
begin
    if (regd1.destino < regd2.destino) then
    begin
        min := regd1;
        leer(det1, regd1);
    end
    else if (regd1.destino > regd2.destino) then
    begin
        min := regd2;
        leer(det2, regd2);
    end
    else
    begin
        { mismo destino }
        if (regd1.fecha < regd2.fecha) then
        begin
            min := regd1;
            leer(det1, regd1);
        end
        else if (regd1.fecha > regd2.fecha) then
        begin
            min := regd2;
            leer(det2, regd2);
        end
        else
        begin
            { misma fecha }
            if (regd1.hora <= regd2.hora) then
            begin
                min := regd1;
                leer(det1, regd1);
            end
            else
            begin
                min := regd2;
                leer(det2, regd2);
            end;
        end;
    end;
end;

procedure actualizarMaestro(var mae: maestro; var det1, det2: detalle; var regd1, regd2, min: datos_det);
var
	acumulador: integer;
	destAct, fechaAct, horaAct: string;
begin
	reset(mae);
	reset(det1);
	reset(det2);
	leer(det1, regd1);
	leer(det2, regd2);
	minimo(det1, det2, regd1, regd2, min);
	read(mae, regm);
	while (min.destino <> VALOR_ALTO) do
	begin
		acumulador := 0;
		destAct := min.destino;
		fechaAct := min.fecha;
		horaAct := min.hora;
		while (min.destino = destAct) and (min.fecha = fechaAct) and (min.hora = horaAct) do
		begin
			acumulador := acumulador + min.asientos_comprados;
			minimo(det1, det2, regd1, regd2, min);
		end;
		while (regm.destino <> destAct) or (regm.fecha <> fechaAct) or (regm.hora <> horaAct) do
		begin
			read(mae, regm);
		end;
		regm.asientos := regm.asientos - acumulador;
		seek(mae, filepos(mae) - 1);
		write(mae, regm);
	end;
end;

{PROGRAMA PRINCIPAL}
begin
	assign(mae, 'maestro');
	assign(det1, 'detalle1');
	assign(det2, 'detalle2');
	actualizarMaestro(mae, det1, det2, regd1, regd2, min);
	close(mae);
	close(det1);
	close(det2);
end.

{FALTA EL EJERCICIO B, ME DIO PAJA :D}
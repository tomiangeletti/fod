{A partir de información sobre la alfabetización en la Argentina, se desea actualizar un archivo maestro
que contiene los siguientes datos: nombre de la provincia, cantidad de personas alfabetizadas y total de
encuestados.

Para ello, se dispone de dos archivos detalle, provenientes de distintas agencias de censo. Cada uno de
estos archivos contiene: nombre de la provincia, código de localidad, cantidad de personas alfabetizadas
y cantidad de encuestados.

Se solicita desarrollar los módulos necesarios para actualizar el archivo maestro a partir de la
información contenida en ambos archivos detalle.

Nota: Todos los archivos están ordenados por nombre de provincia. En los archivos detalle pueden
existir cero, uno o más registros por cada provincia.}

program pr2ej3;
const
	VALOR_ALTO = 'ZZZZZ';
type
	prov_mae = record
		nombre : string[30];
		cant_alf: integer;
		encuestados: integer;
	end;
	
	prov_det = record
		nombre: string[30];
		codigo: string;
		cant_alf: integer;
		encuestados: integer;
	end;
	
	arc_mae: file of prov_mae;
	arc_det: file of prov_det;
var
	det1, det2: arc_det;
	mae: arc_mae;
	regm: prov_mae;
	min, regd1, regd2: prov_det;
	prov_act: prov_mae;

procedure leer(var archivo: arc_det; var dato: prov_det);
begin
	if (not(EOF(archivo))) then
		read(archivo,dato)
	else
		dato.nombre := VALOR_ALTO;
end;

procedure minimo(var det1, det2: arc_det; var r1, r2, min: prov_det);
begin
	if (r1.nombre < r2.nombre) then
	begin
		min := r1;
		leer(det1,r1);
	end
	else begin
		min := r2;
		leer(det2,r2);
	end;
end;

{PROGRAMA PRINCIPAL}
begin
	assign (mae, 'maestro');
	assign (det1, 'detalle1');
	assign (det2, 'detalle2');
	reset(mae);
	reset(det1);
	reset(det2);
	leer (det1, regd1); {porque en minimo no se lee el primer registro entonces iria basura.}
	leer (det2, regd2);
	minimo(det1, det2, regd1, regd2, min);
	read(mae,regm); {para tener el primer registro del maestro}
	while (min.nombre <> VALOR_ALTO) do
	begin
		prov_act.nombre := min.nombre;
		prov_act.cant_alf := 0;
		prov_act.encuestados := 0;
		
		while (prov_act.nombre = min.nombre) do
		begin
			prov_act.cant_alf := prov_act.cant_alf + min.cant_alf;
			prov_act.encuestados := prov_act.encuestados + min.encuestados;
			minimo(det1, det2, regd1, regd2, min);
		end;
		{buscar la provincia en el maestro}
		while (regm.nombre <> prov_act.nombre) do
		begin
			read(mae,regm);
		end;
		regm.cant_alf := regm.cant_alf + prov_act.cant_alf;
		regm.encuestados := regm.encuestados + prov_act.encuestados;
		seek(mae, filepos(mae) - 1);
		write(mae,regm);
	end;
	close(mae);
	close(det1);
	close(det2);
end.

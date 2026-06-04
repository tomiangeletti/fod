{Se dispone de un archivo maestro con información de los alumnos de la Facultad de Informática. Cada
registro del archivo maestro contiene: código de alumno, apellido, nombre, cantidad de cursadas
aprobadas y cantidad de materias con final aprobado. El archivo maestro está ordenado por código de
alumno.

Además, se dispone de dos archivos detalle con información sobre el desempeño académico de los
alumnos: un archivo de cursadas y un archivo de exámenes finales.

El archivo de cursadas contiene información sobre las materias cursadas por los alumnos. Cada registro
incluye: código de alumno, código de materia, año de cursada y resultado (solo interesa determinar si la
cursada fue aprobada o desaprobada).

Por su parte, el archivo de exámenes finales contiene información sobre los exámenes rendidos. Cada
registro incluye: código de alumno, código de materia, fecha del examen y nota obtenida.

Ambos archivos detalle están ordenados por código de alumno y código de materia, y pueden contener
cero, uno o más registros por alumno.

Un alumno puede cursar una misma materia varias veces, así como también rendir el examen final en
múltiples ocasiones.

Se solicita desarrollar un programa que actualice el archivo maestro, modificando la cantidad de cursadas
aprobadas y la cantidad de materias con final aprobado, a partir de la información contenida en los archivos
detalle.

Las reglas de actualización son las siguientes:
● Si un alumno aprueba una cursada, se incrementa en uno la cantidad de cursadas aprobadas.
● Si un alumno aprueba un examen final (nota mayor o igual a 4), se incrementa en uno la cantidad de
materias con final aprobado.

Notas:
● Los archivos deben procesarse en un único recorrido.
● No es necesario verificar inconsistencias en la información de los archivos detalle. En particular, se
garantiza que un alumno no puede aprobar más de una vez la cursada de una misma materia. De
manera análoga, tampoco puede aprobar más de una vez el examen final de una misma materia.}

program pr2ej7;
const
	VALOR_ALTO = '9999999';
type
	dato_mae = record
		cod_alumno: string;
		apellido: string[20];
		nombre: string[20];
		cur_apr: integer;
		fin_apr: integer;
	end;
	
	cursadas_reg = record
		cod_alumno: string;
		cod_materia: string;
		anio: string;
		resultado: boolean;
	end;
	
	finales_reg = record
		cod_alumno: string;
		cod_materia: string;
		fecha: string;
		nota: integer;
	end;
	
	maestro: file of dato_mae;
	cursadas_arc: file of cursadas_reg;
	finales_arc: file of finales_reg;
	
var
	mae: maestro;
	regm: dato_mae;
	cursadas: cursadas_arc;
	finales: finales_arc;
	reg_c: cursadas_reg;
	reg_f: finales_reg;
	
procedure leerCursada(var arch: cursadas_arc; var dato: cursadas_reg);
begin
    if not EOF(arch) then
        read(arch, dato)
    else
        dato.cod_alumno := VALOR_ALTO;
end;

procedure leerFinal(var arch: finales_arc; var dato: finales_reg);
begin
    if not EOF(arch) then
        read(arch, dato)
    else
        dato.cod_alumno := VALOR_ALTO;
end;

procedure actualizarMaestro(var mae: maestro; var finales: finales_arc; var cursadas: cursadas_arc; var reg_c: cursadas_reg; var  reg_f: finales_reg; var regm: dato_mae);
begin
	reset(mae);
	reset(cursadas);
	reset(finales);
	leerCursada(cursadas,reg_c);
	leerFinal(finales,reg_f);
	
	while (not(EOF(mae))) do
	begin
		read(mae,regm);
		while (regm.cod_alumno = reg_c.cod_alumno) do
		begin
			if (reg_c.resultado) then
				regm.cur_apr := regm.cur_apr + 1;
			leerCursada(cursadas,reg_c);
		end;
		while (regm.cod_alumno = reg_f.cod_alumno) do
		begin
			if (reg_f.nota >= 4) then
				regm.fin_apr := regm.fin_apr + 1;
			leerFinal(finales,reg_f);
		end;
		seek(mae, filepos(mae) - 1);
		write(mae,regm);
	end;
end;

{PROGRAMA PRINCIPAL}
begin
	assign(mae, 'maestro');
	assign(finales, 'finales');
	assign(cursadas, 'cursadas');
	actualizarMaestro(mae, finales, cursadas, reg_c, reg_f, regm);
	close(mae);
	close(finales);
	close(cursadas);
end.
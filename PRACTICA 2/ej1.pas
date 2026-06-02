{Una empresa posee un archivo que contiene información sobre los ingresos percibidos por diferentes
empleados en concepto de comisión. De cada empleado se conoce: código de empleado, nombre y
monto de la comisión.
La información del archivo se encuentra ordenada por código de empleado, y cada empleado puede
aparecer más de una vez en el archivo de comisiones.
Se solicita realizar un procedimiento que reciba el archivo anteriormente descrito y lo compacte. Como
resultado, deberá generar un nuevo archivo en el cual cada empleado aparezca una única vez, con el
valor total acumulado de sus comisiones.
Nota: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser recorrido una única
vez.}

program p2ej1;
const
	CANT_EMPLEADOS = 999;
	VALOR_ALTO = 'ZZZ';
type
	empleado = record
		codigo : string;
		nombre : string[30];
		comision : real;
	end;
	empleados = file of empleado;
	nuevo = file of empleado;

var
	archivo : empleados;
	arch_nue : nuevo;
	
procedure leer(var archivo: empleados; var dato: empleado);
begin
	if (not(EOF(archivo))) then
		read(archivo,dato)
	else
		dato.nombre := VALOR_ALTO;
end;

procedure procesar(var archivo: empleados; var arch_nue: nuevo);
var
	e_act: empleado;
	e_nuevo: empleado;
	cod: string;
begin
	leer(archivo,e_act);
	while (e_act.nombre <> VALOR_ALTO) do
	begin
		cod := e_act.codigo;
		e_nuevo.comision := 0;
		e_nuevo.nombre := e_act.nombre;
		e_nuevo.codigo := cod;
		while (e_act.codigo = cod) do
		begin
			e_nuevo.comision := e_nuevo.comision + e_act.comision;
			leer(archivo,e_act);
		end;
		write(arch_nue,e_nuevo);
	end;
end;

{PROGRAMA PRINCIPAL}
begin
	assign(archivo, 'archivo_original');
	assign(arch_nue, 'archivo_nuevo');
	reset(archivo);
	rewrite(arch_nue);
	procesar(archivo,arch_nue);
	close(archivo);
	close(arch_nue);
end.
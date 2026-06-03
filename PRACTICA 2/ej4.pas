{Se cuenta con un archivo maestro de productos de una cadena de venta de alimentos congelados. De
cada producto se almacena la siguiente información: código de producto, nombre, descripción, stock
disponible, stock mínimo y precio.

Diariamente se recibe un archivo detalle por cada una de las 30 sucursales de la cadena. Cada archivo
detalle contiene: código de producto y cantidad vendida.
Se solicita desarrollar un procedimiento que reciba los 30 archivos detalle y actualice el stock del archivo
maestro.

Además, deberá generarse un archivo de texto que informe, para aquellos productos cuyo stock
disponible se encuentre por debajo del stock mínimo, los siguientes datos: nombre del producto,
descripción, stock disponible y precio.

Analizar alternativas para la generación de dicho informe: realizarlo en el mismo procedimiento de
actualización o en un procedimiento separado, indicando las ventajas y desventajas de cada opción.

Nota: Todos los archivos se encuentran ordenados por código de producto. En cada archivo detalle
puede haber cero, uno o más registros para un mismo producto.}

program pr2ej4;
const
	VALOR_ALTO = '9999999999';
type
	producto = record
		codigo: string;
		nombre: string[30];
		descripcion: string;
		stock: integer;
		stock_min: integer;
		precio: real;
	end;
	
	producto_det = record
		codigo: string;
		cant_vendida: integer;
	end;
	
	detalle: file of producto_det;
	maestro: file of producto;
	
	vector_arc = array[1..30] of detalle;
	vector_reg = array[1..30] of producto_det;
var
	mae: maestro;
	v_arc: vector_arc;
	v_reg: vector_reg;
	min: producto_det;
	txt: Text;
	regm: producto;

procedure leer(var archivo: detalle; var dato: producto_det);
begin
	if (not(EOF(archivo))) then
		read(archivo,dato)
	else
		dato.codigo := VALOR_ALTO;
end;

procedure minimo(var v_arc: vector_arc; var v_reg: vector_reg; var min: producto_det);
var
	i, posMin: integer;
begin
	{min deberia venir con un valor alto por defecto para poder hacer bien la comparacion}
	min.codigo := VALOR_ALTO;
	for (i := 1 to 30) do
	begin
		if (v_reg[i].codigo < min.codigo) then begin
			min := v_reg[i];
			posMin := i;
		end;
	end;
	leer(v_arc[posMin],v_reg[posMin]);
end;

procedure leerPrimerRegistro(var v_arc: vector_arc; var v_reg: vector_reg);
var
	i: integer;
begin
	for (i := 1 to 30) do
	begin
		reset(v_arc[i]);
		leer(v_arc[i], v_reg[i]);
	end;
end;

procedure actualizar(var mae: maestro, var v_arc: vector_arc; var v_reg: vector_reg; var min: producto_det);
var
	tot: integer;
	codActual: string;
begin
	reset(mae);
	leerPrimerRegistro(v_arc, v_reg);
	read(mae,regm);
	minimo(v_arc, v_reg, min);
	
	while (min.codigo <> VALOR_ALTO) do
	begin
		codActual := min.codigo;
		tot := 0;
		while (min.codigo = codActual) do
		begin
			tot := tot + min.cant_vendida;
			minimo(v_arc, v_reg, min);
		end;
		while (regm.codigo <> codActual) do
		begin
			read(mae,regm);
		end;
		regm.stock := regm.stock - tot;
		seek(mae, filepos(mae) - 1);
		write(mae,regm);
		if (regm.stock < regm.stock_min) then
			writeln(txt, 'Nombre:', regm.nombre, 'Descripcion', regm.descripcion, 'Precio', regm.precio, 'Stock', regm.stock);
	end;
end;

procedure cerrarArchivos(var v_arc: vector_arc);
var
	i: integer;
begin
	for (i := 1 to 30) do
	begin
		close(v_arc[i]);
	end;
end;

{PROGRAMA PRINCIPAL}
begin
	actualizar(mae, v_arc, v_reg, min);
	cerrarArchivos(v_arc);
end.
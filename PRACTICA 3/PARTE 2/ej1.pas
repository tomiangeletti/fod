{El encargado de ventas de un negocio de productos de limpieza desea administrar el stock de los
productos que vende. 
Para ello, genera un archivo maestro donde figuran todos los productos que
comercializa. 
De cada producto se maneja la siguiente información: código de producto, nombre
comercial, precio de venta, stock actual y stock mínimo. 

Diariamente se genera un archivo detalle donde se registran todas las ventas de productos realizadas. 
De cada venta se registran: código de producto y cantidad de unidades vendidas. 
Resuelve los siguientes puntos:
a. Se pide realizar un procedimiento que actualice el archivo maestro con el archivo detalle,
teniendo en cuenta que:

i. Los archivos no están ordenados por ningún criterio.

ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo
detalle.

b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que cada registro
del archivo maestro puede ser actualizado por 0 o 1 registro del archivo detalle?}

program pr3ej1;
type
	producto = record
		codigo: string[20];
		nombre: string[30];
		precio: real;
		stock: integer;
		stock_min: integer;
	end;
	
	venta = record
		codigo: string[20];
		uni_vendidas: integer;
	end;
	
	maestro: file of producto;
	detalle: file of venta;
	
var
	mae : maestro;
	det : detalle;
	regd : venta;
	regm : producto;

procedure actualizarMaestro(var mae: maestro; var det: detalle; var regd : venta; var regm : producto);
begin
	reset(det);
	read(det,regd);
	while (not(EOF(det))) do
	begin
		reset(mae); {hay que reiniciar por cada registro del detalle el maestro para poder buscar bien dentro de ese archivo}
		read(mae,regm);		
		while (regm.codigo <> regd.codigo) and (not(EOF(mae))) do {pongo la condicion pero ASUMIMOS que el codigo SEGURO ESTA, por eso no verifico despues por que
		corta el while}
		begin
			read(mae,regm);
		end;
		regm.stock := regm.stock - regd.uni_vendidas;
		seek(mae, filepos(mae) - 1);
		write(mae,regm);
		read(det,regd);
	end;
	close(mae);
	close(det);
end;

{PROGRAMA PRINCIPAL}
begin
	assign(mae, 'maestro');
	assign(det, 'detalle');
	actualizarMaestro(mae, det, regd, regm);
end.

	
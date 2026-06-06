{Definir un programa que genere un archivo con registros de longitud fija con información de
productos de un comercio. 
Los datos se ingresan por teclado y de cada producto se almacena:
código de producto, nombre, descripción, precio y stock disponible. 
Implementar un procedimiento que, a partir del archivo de datos generado, realice la baja lógica de todos
aquellos productos cuyo stock disponible sea igual a 0.

La baja lógica debe indicarse marcando el registro con un carácter especial que se sitúa como
prefijo en algún campo de tipo string a su elección. 
Por ejemplo, se puede anteponer el carácter @
al nombre del producto: ‘@Arroz Gallo 1K’.}

program pr3ej2;
const
	VALOR_ALTO = '999999999999999';
type
	producto = record
		codigo: string[20];
		nombre: string[30];
		descripcion: string[100];
		precio: real;
		stock: integer;
	end;
	
	archivo : file of producto;

var
	arc : archivo;
	reg : producto;
	
procedure generarArchivo(var arch: archivo);
var
    p: producto;
begin
	assign(arch, 'productos');
    rewrite(arch); 
    writeln('Ingrese codigo de producto (0 para finalizar):');
    readln(p.codigo);
    while (p.codigo <> '0') do begin
        writeln('Nombre:'); readln(p.nombre);
        writeln('Descripcion:'); readln(p.descripcion);
        writeln('Precio:'); readln(p.precio);
        writeln('Stock:'); readln(p.stock);
        
        write(arch, p); 
        
        writeln('Ingrese codigo de producto (0 para finalizar):');
        readln(p.codigo);
    end;
end;

procedure leer(var arc : archivo; var dato : producto);
begin
	if (not(EOF(arc))) then
		read(arc,dato)
	else
		dato.codigo := VALOR_ALTO;
end;

procedure procesarArchivo(var arc : archivo; var reg : producto);
begin
	leer(arc, reg);
	while (reg.codigo <> VALOR_ALTO) do
	begin
		if reg.stock = 0 then
		begin
			reg.nombre := '@' + reg.nombre;
			seek(arc, filepos(arc) - 1);
			write(arc, reg);
		end;
		leer(arc, reg);
	end;
	close(arc);
end;

{PROGRAMA PRINCIPAL}
begin
	generarArchivo(arc);
	procesarArchivo(arc,reg);
end.
{El encargado de ventas de un negocio de productos de limpieza desea administrar el stock de los productos
que comercializa. Para ello, dispone de un archivo maestro en el que se registran todos los productos.
De cada producto se almacena la siguiente información: código de producto, nombre comercial, precio de venta,
stock actual y stock mínimo.
Diariamente se genera un archivo detalle donde se registran todas las ventas realizadas. De cada venta se
almacena: código de producto y cantidad de unidades vendidas.
Se solicita desarrollar un programa que permita:
a) Actualizar el archivo maestro a partir del archivo detalle, teniendo en cuenta que:
● Ambos archivos están ordenados por código de producto.

● Cada registro del archivo maestro puede ser actualizado por cero, uno o más registros del archivo
detalle.

● El archivo detalle sólo contiene registros cuyos códigos existen en el archivo maestro.

b) Generar un archivo de texto llamado “stock_minimo.txt” que contenga aquellos productos cuyo stock actual se
encuentre por debajo del stock mínimo permitido.}

program p2ej2;

const
    VALOR_ALTO = 'ZZZZ';

type
    producto = record
        codigo: string[4];
        nombre: string[20];
        precio: real;
        stock_act: integer;
        stock_min: integer;
    end;

    venta = record
        codigo: string[4];
        cant_unidades : integer;
    end;

    mae = file of producto;
    det = file of venta;

var
    maestro : mae;
    detalle : det;
    txt : Text;

procedure leer(var detalle: det; var regd: venta);
begin
    if not EOF(detalle) then
        read(detalle, regd)
    else
        regd.codigo := VALOR_ALTO;
end;

procedure procesar_archivo(var maestro: mae; var detalle: det; var txt: Text);
var
    regm: producto;
    regd: venta;
    cod_actual: string[4];
    tot: integer;
begin
    leer(detalle, regd);

    while (regd.codigo <> VALOR_ALTO) do
    begin
        cod_actual := regd.codigo;
        tot := 0;

        { acumulo todas las ventas del mismo producto }
        while (regd.codigo = cod_actual) do
        begin
            tot := tot + regd.cant_unidades;
            leer(detalle, regd);
        end;

        { busco el producto en el maestro }
        read(maestro, regm);
        while (regm.codigo <> cod_actual) do
            read(maestro, regm);

        { actualizo stock }
        regm.stock_act := regm.stock_act - tot;

        if (regm.stock_act < regm.stock_min) then
            writeln(txt,
                    regm.codigo, ' ',
                    regm.nombre, ' ',
                    regm.stock_act, ' ',
                    regm.stock_min);

        { reescribo el registro actualizado }
        seek(maestro, filepos(maestro) - 1);
        write(maestro, regm);
    end;
end;

{ PROGRAMA PRINCIPAL }
begin
    assign(maestro, 'maestro.dat');
    assign(detalle, 'detalle.dat');
    assign(txt, 'stock_minimo.txt');

    reset(maestro);
    reset(detalle);
    rewrite(txt);

    procesar_archivo(maestro, detalle, txt);

    close(maestro);
    close(detalle);
    close(txt);
end.

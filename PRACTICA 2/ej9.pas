{Se cuenta con un archivo que posee información de las ventas que realiza una empresa a los diferentes
clientes. 
Se necesita obtener un reporte con las ventas organizadas por cliente. Para ello, se deberá
informar por pantalla: los datos personales del cliente, el total mensual (mes por mes cuánto compró) y
finalmente el monto total comprado en el año por el cliente. 
Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido por la empresa.

El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año, mes, día y
monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.

Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron compras. No es
necesario que informe tales meses en el reporte.}

program pr2ej9;
const
	VALOR_ALTO = '999999999999999';
type
	cli = record
		codigo: string;
		nombre: string;
		apellido: string;
	end;
	
	dato_mae = record
		cliente: cli;
		anio: string;
		mes: string;
		dia: string;
		monto: real;
	end;
	
	maestro: file of dato_mae;

var
	mae: maestro;
	regm: dato_mae;

procedure leer(var archivo : maestro; var dato : dato_mae);
begin
	if (not(EOF(archivo))) then
		read(archivo,dato)
	else
		dato.cliente.codigo := VALOR_ALTO;
end;

procedure imprimirDatosPersonales(c : cli);
begin
	writeln('=============================================');
	writeln('Codigo de cliente:', c.codigo);
	writeln('Nombre: ', c.nombre);
	writeln('Apellido: ', c.apellido);
	writeln('=============================================');
end;

procedure reportar(var mae: maestro; var regm : dato_mae);
var
    codActual, mesActual, anioActual: string;
    totalEmpresa, totalAnio, totMes: real;
begin
    reset(mae);
    leer(mae, regm);
    totalEmpresa := 0;
    while (regm.cliente.codigo <> VALOR_ALTO) do
    begin
        codActual := regm.cliente.codigo;
        imprimirDatosPersonales(regm.cliente);
        while (regm.cliente.codigo = codActual) do
        begin
            anioActual := regm.anio;
            totalAnio := 0;
            writeln('Año: ', anioActual);
            while (regm.cliente.codigo = codActual) and (regm.anio = anioActual) do
            begin
                mesActual := regm.mes;
                totMes := 0;
                while (regm.cliente.codigo = codActual) and (regm.anio = anioActual) and (regm.mes = mesActual) do
                begin
                    totMes := totMes + regm.monto;
                    leer(mae, regm);
                end;
                writeln('  Mes: ', mesActual, ' - Total comprado: ', totMes:0:2);
                totalAnio := totalAnio + totMes;
            end;
            writeln('Total año ', anioActual, ': ', totalAnio:0:2);
            totalEmpresa := totalEmpresa + totalAnio;
        end;
        writeln('-----------------------------------');
    end;
    writeln('Monto total obtenido por la empresa: ',
            totalEmpresa:0:2);
    close(mae);
end;

{PROGRAMA PRINCIPAL}
begin
	assign(mae, 'maestro');
	reportar(mae, regm);
end.
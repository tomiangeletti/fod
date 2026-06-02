program pr1ej2fod;
type
    archivo = file of integer;

procedure procesarArchivo(a : archivo);
var
    aux, dato, cantMenor : integer;
    nom : string;
    prom : real;
begin
    aux := 0;
    cant := 0;
    cantMayor := 0;
    while not EOF(a) do
    begin
        read(a,dato);
        aux := aux + dato;
        if (dato < 15000) then begin
            cantMenor := cantMenor + 1
        writeln("- " + dato)
    end;
    prom := aux/fileSize(a);
    writeln("La cantidad de nros menores a 15.000 es: ", cantMenor)
    writeln("El promedio del archivo es: ", prom:0:2);
end;
var
    arch : archivo
    nombre : string
    dato : integer
begin
    writeln("Ingrese el nombre del archivo: ");
    writeln('Ingrese un nombre de archivo');
    readln(nombre);
    assign(arch, nombre);
    reset(arch);
    procesarArchivo(a);
    close(arch);
end.
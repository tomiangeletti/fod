program pr1ej1fod;
type
    archivo = file of integer;
var
    arch : archivo
    nom : string
    dato : integer
begin
    writeln("Ingrese el nombre del archivo: ");
    readln(nom);
    assing(arch,nom);
    rewrite(arch);
    writeln("Ingrese un numero: ") readln(dato);
    while dato <> 30000 do
    begin
        write(arch,dato);
        writeln("Ingrese un numero: ") readln(dato);
    end;
    close(arch);
end.
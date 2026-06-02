    {3. Realizar un programa que presente un menú con opciones para:
    a. Crear un archivo de registros no ordenados de empleados y completarlo con
    datos ingresados desde teclado. De cada empleado se registra: número de
    empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
    DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
    b. Abrir el archivo anteriormente generado y
    i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
    determinado, el cual se proporciona desde el teclado.
    ii. Listar en pantalla los empleados de a uno por línea.
    iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.
    NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.}
program pr1ej3fod;
type
    empleado = record
        numero: integer;
        apellido: string[20];
        nombre: string[15];
        edad: integer;
        dni: integer;
    end;
    archivo = file of empleado;
    
procedure leerEmpleado(var e: empleado);
begin
    writeln('Ingrese el apellido del empleado');
    readln(e.apellido);
    if(e.apellido <> 'fin') then
        begin
            writeln('Ingrese el nombre del empleado');
            readln(e.nombre);
            writeln('Ingrese el numero del empleado');
            readln(e.numero);
            writeln('Ingrese la edad del empleado');
            readln(e.edad);
            writeln('Ingrese el DNI del empleado');
            readln(e.dni);
        end;
end;

procedure cargarDatos(var arch : archivo);
var
    e : empleado
begin
    leerEmpleado(e);
    while (e.apellido <> 'fin') do
    begin
        write(arch,e);
        leerEmpleado(e);
    end;
    close(arch);
end;

//-----------------------B I-----------------------
function cumpleCondicion(nombre, apellido, dato : string): boolean;
begin
    cumple := ((nombre = dato) or (apellido = dato));
end;

procedure imprimirEmpleado(e: empleado);
begin
    writeln('Numero=', e.numero, ' Apellido=', e.apellido, ' Nombre=', e.nombre, ' Edad=', e.edad, ' DNI=', e.dni);
end;

procedure listarEmpleadosCond(var arch : archivo);
var
    e : empleado;
    dato : string;
begin
    reset(arch);
    writeln("Ingrese el dato a buscar: "); readln(dato);
    while not EOF(arch) do
    begin
        read(arch,e);
        if cumpleCondicion(e.nombre, e.apellido, dato) then begin
            imprimirEmpleado
    end;
    close(arch);
end;

//-----------------------B II----------------------
procedure imprimirTodos(var arch : archivo);
var
    e : empleado;
begin
    reset(arch);
    while not EOF(arch) do
    begin
        read(arch,e);
        imprimirEmpleado(e);
    end;
    close(arch);
end;

//-----------------------B III---------------------
procedure impimirMayores70(var arch : archivo);
var
    e : empleado;
begin
    reset(arch);
    while not EOF(arch) do
    begin
        read(arch,e);
        if (e.edad > 70) then begin
            imprimirEmpleado(e);
    end;
    close(arch);
end;

procedure menuOpciones(var arch: archivo);
var
    opcion: integer;
begin
    writeln('MENU DE OPCIONES');
    writeln('Opcion 1: Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado');
    writeln('Opcion 2: Listar en pantalla los empleados de a uno por linea');
    writeln('Opcion 3: Listar en pantalla los empleados mayores a 70 anios, proximos a jubilarse');
    writeln('Opcion 4: Salir del menu y terminar la ejecucion del programa');
    readln(opcion);
    while(opcion <> 4) do
        begin
            case opcion of
                1: empleadoApellONombre(arch);
                2: imprimirArchivo(arch);
                3: empleadosMayores70(arch);
            else
                writeln('La opcion ingresada no corresponde a ninguna de las mostradas en el menu de opciones');
            end;
            writeln();
            writeln('MENU DE OPCIONES');
            writeln('Opcion 1: Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado');
            writeln('Opcion 2: Listar en pantalla los empleados de a uno por linea');
            writeln('Opcion 3: Listar en pantalla los empleados mayores a 70 anios, proximos a jubilarse');
            writeln('Opcion 4: Salir del menu y terminar la ejecucion del programa');
            readln(opcion);
        end;
end;

var
    arch : archivo;
    nombre : string;
begin
    writeln("Escriba el nombre del archivo: ") readln(nombre);
    assign(arch,nombre);
    rewrite(arch);
    cargarDatos(arch);
    menuOpciones(arch);
end.
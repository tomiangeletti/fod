program parcial;
const
	VALOR_ALTO = 999999999;
type
	registro = record
		codigo_art: integer;
		nombre: string;
		anio: integer;
		codigo_evento: integer;
		nombre_evento: string;
		likes: integer;
		dislikes: integer;
		puntaje: real;
	end;
	
	archivo : file of registro

var
	arc : archivo;
	reg : registro;

procedure leer(var arc : archivo; var dato : registro);
begin
	if (not(EOF(arc))) then
		read(arc, dato)
	else
		dato.anio := VALOR_ALTO;
end;

procedure reportar(var arc : archivo);
var
	anioAct, codEvAct, codArtAct, likesTot, dislikesTot, presentaciones, presentacionesTot, likesMin, dislikesMin : integer;
	puntajeTot, puntajeMin : real;
	nomMin, nombre : string;
begin
	reset(arc)
	leer(arc, reg);
	writeln('Resumen de menor influencia por evento.')
	while (reg.anio <> VALOR_ALTO) do
	begin
		anioAct := reg.anio;
		writeln('Año: ', anioAct);
		while (anioAct = reg.anio) do
		begin
			presentaciones := 0;
			codEvAct := reg.codigo_evento;
			writeln('Evento: ', reg.nombre_evento);
			while (anioAct = reg.anio) and (codEvAct = reg.codigo_evento) do
			begin
				codArtAct := reg.codigo_art;
				likesTot := 0;
				dislikesTot := 0;
				puntajeTot := 0;
				writeln('Artista: ', reg.nombre);
				while (anioAct = reg.anio) and (codEvAct = reg.codigo_evento) and (codArtAct = reg.codigo_art) do
				begin
					likesTot := likesTot + reg.likes;
					dislikesTot := dislikesTot + reg.dislikes;
					puntajeTot := puntajeTot + reg.puntaje;
					nombre := reg.nombre;
					presentaciones := presentaciones + 1;
					leer(arc, reg);
				end;
				writeln('Likes totales: ', likesTot);
				writeln('Dislikes totales: ', dislikesTot);
				writeln('Diferencia: ', likesTot - dislikesTot);
				writeln('Puntaje total: ', puntajeTot);
				if (puntajeTot < puntajeMin) then
					nomMin := nombre
				else if (puntajeTot = puntajeMin) then
				begin
					if (dislikes > dislikesMin) then
					nomMin := nombre;
				else if (dislikes = dislikesMin) then
					nomMin := nombre; {por empate}
				end;
			end;
			writeln('El artista menos influyente fue: ', nomMin);
		end;
		writeln('Presentaciones: ', presentaciones)
	end;
end;
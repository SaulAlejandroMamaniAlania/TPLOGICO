mira(juan,himym).
mira(juan,futurama).
mira(juan,got).
mira(nico,starWars).
mira(maiu,starWars).
mira(maiu,onePiece).
mira(maiu,got).
mira(nico,got).
mira(gaston,hoc).
mira(pedro,got).
esPopular(got).
esPopular(hoc).
esPopular(starWars).
planeaVer(juan,got).
planeaVer(aye,got).
planeaVer(gaston,himym).
episodios(got,12,3).
episodios(got,10,2).
episodios(himym,23,1).
episodios(drHouse,16,8).


paso(futurama, 2, 3, muerte(seymourDiera)).
paso(starWars, 10, 9, muerte(emperor)).
paso(starWars, 1, 2, relacion(parentesco, anakin, rey)).
paso(starWars, 3, 2, relacion(parentesco, vader, luke)).
paso(himym, 1, 1, relacion(amorosa, ted, robin)).
paso(himym, 4, 3, relacion(amorosa, swarley, robin)).
paso(got, 4, 5, relacion(amistad, tyrion, dragon)).

paso(got,3,2,plowTwist([suenio,sinPiernas])).
paso(got,3,12,plowTwist([fuego,boda])).
paso(supercampeones,9,9,plowTwist([suenio,coma,sinPiernas])).
paso(hoc,3,12,plowTwist([coma,pastillas])).

leDijo(gaston, maiu, got, relacion(amistad, tyrion, dragon)).
leDijo(nico, maiu, starWars, relacion(parentesco, vader, luke)).
leDijo(nico, juan, got, muerte(tyrion)). 
leDijo(aye, juan, got, relacion(amistad, tyrion, john)).
leDijo(aye, maiu, got, relacion(amistad, tyrion, john)).
leDijo(aye, gaston, got, relacion(amistad, tyrion, dragon)).
/*Añadido */
leDijo(nico, juan, futurama, muerte(seymourDiera)).
leDijo(pedro, aye, got, relacion(amistad, tyrion, dragon)).
leDijo(pedro,nico,got,relacion(parentesco, tyrion,dragon)).

/*Se pueden hacer consultas individuales pero respetando el orden,si no no lo toma,existenciales tambien
por ser hechos,tambien son iversibles*/

esSpoiler(Spoiler,Serie):-
paso(Serie,_,_,Spoiler).

miraOPlaneaVer(Persona):-
mira(Persona,Serie).

miraOPlaneaVer(Persona):-
planeaVer(Persona,Serie).

leSpoileo(Persona1,Persona2,Serie):-
mira(Persona2,Serie),
leDijo(Persona1,Persona2,Serie,Spoiler),
esSpoiler(Spoiler,Serie),
Persona1\=Persona2.

leSpoileo(Persona1,Persona2,Serie):-
planeaVer(Persona2,Serie),
leDijo(Persona1,Persona2,Serie,Spoiler),
esSpoiler(Spoiler,Serie),
Persona1\=Persona2.

televidenteResponsable(Persona):-
planeaVer(Persona,_),
not(leSpoileo(Persona,_,_)).


televidenteResponsable(Persona):-
mira(Persona,_),
not(leSpoileo(Persona,_,_)).


vieneZafando(Persona,Serie):-
mira(Persona,Serie),
esPopular(Serie),
not(leSpoileo(_,Persona,Serie)).

vieneZafando(Persona,Serie):-
planeaVer(Persona,Serie),
esPopular(Serie),
not(leSpoileo(_,Persona,Serie)).

vieneZafando(Persona,Serie):-
mira(Persona,Serie),
forall(paso(Serie,Temporada,_,_),esFuerte(Serie,Temporada)),
not(leSpoileo(_,Persona,Serie)).

vieneZafando(Persona,Serie):-
planeaVer(Persona,Serie),
forall(paso(Serie,Temporada,_,_),esFuerte(Serie,Temporada)),
not(leSpoileo(_,Persona,Serie)).

esFuerte(Serie,Temporada):-
paso(Serie,Temporada,_,relacion(amorosa, P1, P2)).

esFuerte(Serie,Temporada):-
paso(Serie,Temporada,_,relacion(parentesco, P1, P2)).

esFuerte(Serie,Temporada):-
paso(Serie,Temporada,_,muerte(_)).


/*
------------------------------
TP LOGICO PARTE2
--------------------------------
*/

malaGente(Persona):-
leDijo(Persona,_,_,_),
forall(leDijo(Persona,OtraPersona,_,_),leSpoileo(Persona,OtraPersona,_)).

malaGente(Persona):-
leSpoileo(Persona,_,Serie),
not(mira(Persona,Serie)).




palabras(Palabras):-paso(_,_,_,plowTwist(Palabras)).

palabrasEnComun(MisPalabras,Palabras):-
palabras(Palabras),
intersection(MisPalabras,Palabras,EnComun),
EnComun\=[],
Palabras\=MisPalabras.

esCliche(plowTwist(MisPalabras)):-
paso(_,_,_,plowTwist(MisPalabras)),
palabras(Palabras),
forall(palabras(Palabras),palabrasEnComun(MisPalabras,Palabras)).


esFinalTemporada(Serie,MiTemporada):-
paso(Serie,MiTemporada,_,_),
forall(paso(Serie,Temporada,_,_),MiTemporada>=Temporada).


fuerte(PlowTwist):-
paso(Serie,Temporada,_,PlowTwist),
not(esCliche(PlowTwist)),
esFinalTemporada(Serie,Temporada).

fuerte(relacion(amorosa, P1, P2)):-
paso(_,_,_,relacion(amorosa, P1, P2)).

fuerte(relacion(parentesco, P1, P2)):-
paso(_,_,_,relacion(parentesco, P1, P2)).

fuerte(muerte(Personaje)):-
paso(_,_,_,muerte(Personaje)).


popular(got).
popular(starWars).
popular(hoc).

popularidad(Serie):-
queTanPopular(Serie,Popularidad),
queTanPopular(starWars,OtraPopularidad),
Popularidad>=OtraPopularidad.



cantidadMiran(Serie,Cantidad):-
mira(_,Serie),
findall(Persona,mira(Persona,Serie),Personas),
length(Personas,Cantidad).

conversaciones(Serie,Cantidad):-
mira(_,Serie),
findall(Serie,leDijo(_,_,Serie,_),Series),
length(Series,Cantidad).

queTanPopular(Serie,Popularidad):-
cantidadMiran(Serie,Cant1),
conversaciones(Serie,Cant2),
Popularidad is Cant1*Cant2.

amigo(nico, maiu).
amigo(maiu, gaston).
amigo(maiu, juan).
amigo(juan, aye).

fullSpoil(Persona1,Persona2):-
leSpoileo(Persona1,Persona2,_),
Persona1\=Persona2.

fullSpoil(Persona1,Otro):-
amigo(AmigoDeOtro,Otro),
fullSpoil(Persona1,AmigoDeOtro),
Persona1\=Otro,
AmigoDeOtro\=Otro.




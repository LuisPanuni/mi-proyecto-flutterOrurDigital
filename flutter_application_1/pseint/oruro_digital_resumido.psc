Algoritmo OruroDigital_Resumido
	Definir opcion, reportes, problemas Como Entero
	Definir categoria, descripcion, ubicacion, foto Como Cadena
	
	reportes <- 0
	problemas <- 0
	
	Repetir
		Escribir "ORURO DIGITAL"
		Escribir "1. Nuevo reporte"
		Escribir "2. Ver mapa y problemas"
		Escribir "3. Salir"
		Leer opcion
		
		Segun opcion Hacer
			1:
				Escribir "Categorias: Bache, Basura, Luminaria, Calle, Alcantarillado, Senalizacion, Transporte"
				Escribir "Ingrese categoria:"
				Leer categoria
				Escribir "Ingrese descripcion:"
				Leer descripcion
				Escribir "Ingrese ubicacion:"
				Leer ubicacion
				Escribir "Foto opcional:"
				Leer foto
				
				Escribir "Validando reporte..."
				Escribir "Guardando en la base de datos..."
				reportes <- reportes + 1
				Escribir "Reporte enviado correctamente"
				
				Escribir "Procesando reportes:"
				Escribir "- Agrupar reportes similares"
				Escribir "- Contar reportes"
				Escribir "- Calcular antiguedad"
				Escribir "- Evaluar cercania"
				Escribir "- Calcular prioridad"
				
				problemas <- problemas + 1
				Escribir "Mapa y prioridades actualizadas"
				
			2:
				Escribir "Mostrando mapa inteligente..."
				Escribir "Problemas registrados: ", problemas
				Escribir "Reportes registrados: ", reportes
				Escribir "Listando problemas por prioridad..."
				
			3:
				Escribir "Saliendo de Oruro Digital..."
				
			De Otro Modo:
				Escribir "Opcion invalida"
		FinSegun
		
	Hasta Que opcion = 3
FinAlgoritmo

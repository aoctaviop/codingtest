# Prueba Técnica iOS

## Capas de la aplicación

- #### Vistas
Abarca cada una de las vistas requeridas para mostrar la información al usuario.
- #### Negocios
Incluye los modelos utilizados para el manejo de los datos.
- #### Persistencia
Cotempla las clases necesarias para almacenar los datos de manera local.
- #### Red
Incluye las clases encargadas de hacer las llamadas a cada endpoint requerido del API.

## Responsabilidad de las clases
Agrupados por carpeta:
### Third-party
- **Storage**: utilizado para manejar el almacenamiento local de los modelos de datos.
### ViewControllers
- **MoviesViewController**: usada para mostrar una lista de películas, permite búsqueda loca.
- **DetailViewController**: usada para desplegar el detalle de una película.
- **CategoriesViewController**: incluye un tab bar con 3 categorías de películas.
- **OnlineSearchViewController**: permite al usuario realizar búsqueda de películas online.
### Resources
- **languages.json**: include una lista de países, es usada para desplegar el idioma en la vista de detalle de una película.
### Entities
-  **Genre, Movie, Language, Video**: modelos de datos, extienden de Encodable y Decodable para permitir su serialización.
### Utils
- **Constants**: incluye constantes utilizadas en diferentes partes de la aplicación.
- **PersistenceManager**: clase utilizada para almacener y recuperar la información.
### Cells
- **MovieCell, LabelCell, InfoCell, PosterCell, VideoCell**: celdas utilizadas por los UICollectionView y UITableView usados en la aplicación.
### Networking
- **Decoders**: incluye métodos para codificar los datos provenientes del API en los modelos de datos usados en la aplicación.
- **APIManager**: incluye los llamados a los diferentes endpoints del API utilizados en la aplicación.
- **NetworkState**: clase utilizada para determinar si el dispositivo tiene una conexión a internet válida.
## Preguntas
#### 1.	En qué consiste el principio de responsabilidad única? Cuál es su propósito?
Este principio consiste en que cada clase tenga una responsabilidad específica, encapsulando su comportamiento. El propósito es contribuir en que el código de la aplicación sea de fácil de entender, de mantener y de escalar. 

#### 2.	Qué características tiene, según su opinión, un “buen” código o código limpio
Me parece que lo más importante es crear un código que sea fácil de leer y de entender, y por ende, que sea fácil de mantener. Para lograr esto es clave definir una correcta estructura para el proyecto, seguir la estructura léxica y las buenas prácticas recomendadas para el lenguaje de programación que se esté utilizando.

 ```markdown
 # TaskManager

 ![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)
 ![Platforms](https://img.shields.io/badge/Platforms-iOS%2013.0+-lightgrey.svg)
 ![License](https://img.shields.io/badge/License-MIT-blue.svg)

 TaskManager es una biblioteca Swift que proporciona una forma sencilla y eficiente de manejar tareas asíncronas con indicadores de progreso.

 ## Características

 - ✅ Gestión sencilla de tareas asíncronas
 - 🔄 Indicadores de progreso personalizables
 - ⚡️ Soporte completo para async/await
 - 🎯 Cancelación de tareas previas
 - 📱 Compatible con iOS 13+
 - 🔒 Thread-safe

 ## Instalación

 ### Swift Package Manager

 Puedes instalar TaskManager a través de Swift Package Manager añadiendo la siguiente dependencia a tu `Package.swift`:

 ```swift
 dependencies: [
     .package(url: "https://github.com/DanielGomezEspin/TaskManager.git", from: "1.0.0")
 ]
 ```

 O directamente desde Xcode:
 1. File → Add Packages...
 2. Introduce la URL: `https://github.com/DanielGomezEspin/TaskManager.git`
 3. Selecciona la versión que desees usar

 ## Uso

 ### Ejemplo básico

 ```swift
 import TaskManager

 // Iniciar una tarea simple
 await TaskManager.shared.start(mensaje: "Cargando...") { mensaje, progress in
     // Tu código asíncrono aquí
     progress.update(0.5)
     // Más código...
 }
 ```

 ### Con cancelación de tareas previas

 ```swift
 await TaskManager.shared.start(
     mensaje: "Procesando...",
     cancelPrevious: true
 ) { mensaje, progress in
     // La tarea anterior se cancelará automáticamente
     progress.update(0.3)
     // Continúa el proceso...
 }
 ```

 ### Tarea indefinida

 ```swift
 await TaskManager.shared.start(
     mensaje: "Sincronizando...",
     isUndefined: true
 ) { mensaje, progress in
     // No mostrará porcentaje, solo actividad
 }
 ```

 ## Documentación

 Para más información sobre cómo usar TaskManager, consulta nuestra [documentación detallada](docs/README.md).

 ## Requisitos

 - iOS 13.0+
 - Swift 5.0+
 - Xcode 13.0+

 ## Contribuir

 Las contribuciones son bienvenidas. Por favor, lee primero nuestras [guías de contribución](CONTRIBUTING.md).

 1. Fork el repositorio
 2. Crea tu rama de características (`git checkout -b feature/AmazingFeature`)
 3. Haz commit de tus cambios (`git commit -m 'Add some AmazingFeature'`)
 4. Push a la rama (`git push origin feature/AmazingFeature`)
 5. Abre un Pull Request

 ## Licencia

 Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

 ## Autor

 - Daniel Gómez Espín ([@DanielGomezEspin](https://github.com/DanielGomezEspin))

 ## Agradecimientos

 - A todos los contribuidores que ayudan a mejorar este proyecto
 - A la comunidad Swift por su continuo apoyo
 ```

 Este README.md:
 1. Incluye badges para dar información rápida sobre el proyecto
 2. Proporciona una descripción clara del proyecto
 3. Lista las características principales
 4. Incluye instrucciones de instalación
 5. Muestra ejemplos de código básicos
 6. Proporciona información sobre requisitos y cómo contribuir
 7. Incluye secciones para licencia y autor
 8. Está estructurado de manera clara y profesional


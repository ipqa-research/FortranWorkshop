# FortranWorkshop
Workshop sobre uso de Fortran y librerías del Instituto.

En este Workshop se verán conceptos medios-avanzados de Fortran, 
principalmente el uso de módulos, detalles de argumentos de procedimientos
y como trabajar con tipos derivados. 

## Qué vamos a ver
El workshop se divide en tres posibles días donde se verán distintas cosas. 
En todos los casos se espera que cada usuario siga las partes desde su computadora.
Todo el "teórico" y las actividades se presentan en los archivos "diaX.md" en este
repositorio. Donde pueden seguirse durante la clase y copiar y pegar código.

La ejecución de código se hará mediante el gestor de paquetes `fpm`. Cada mini-programa que
hagamos se ejecturá con el comando:

```bash
fpm run nombre_programa
```

### [Día 1: Pongamonos al día y alineados con Fortran](dia1.md)
- Repaso de cosas básicas de Fortran
- Conceptos un poco más avanzados/"nuevos"
- Debuggeo de código

### [Dia2: Presentación de librería centralizada para cálculos con ecuaciones de estado.](dia2.md)
- Bases de utilización
- Elementos fundamentales (ArModel/GeModel/EquilibriumState)
- Especificación de modelo a utilizar
- Cálculos de propiedades residuales
- Cálculos de equilibrios de fases

### Dia3: Uso más avanzado
- Cómo consultar la documentación para estar al día
- Listado de modelos presentes y en desarrollo
- Definición de un modelo nuevo propio
- Ajuste de parámetros de un sistema binario

## Usar este Workshop desde un entorno online
El contenido de este Workshop puede ejecutarse de manera online sin necesidad de instalar nada, 
utilizando la funcionalidad de GitHub "CodeSpaces". Para poder tener un entorno de trabajo propio
es necesario (estando logeado a nuestra cuenta personal de GitHub):

- Relizar un fork de este repositorio: Un fork es como una desviación del estado actual de este repositorio, pero en la cuenta personal de cada uno.

Para realizar el fork solamente necesitamos tocar en "fork" en la zona superior derecha de este repositorio:

![image](https://github.com/ipqa-research/FortranWorkshop/assets/24468661/c3ad71ba-f0f5-4b3b-8f6e-e7e3b3f82047)

Esto redirigirá a otra página con un evidente botón verde que hay que tocar para realizar el fork. El fork
quedará siempre disponible con el link: github.com/<tu_cuenta>/FortranWorkshop

- Inicializar el CodeSpace desde el fork.

Un CodeSpace es un entorno online `vscode`, que ya dejé seteado con todo lo necesario para trabajar con Fortran en general. Y con
los recursos particulares de este Workshop.

Para inicializar el CodeSpace, desde el fork tocamos en el otro evidente botón verde "code" y de ahí el otro evidente botón verde
"Create CodeSpace on main".
![image](https://github.com/ipqa-research/FortranWorkshop/assets/24468661/3f7c84a6-0a65-4d8b-8dea-b92c363c79ad)

El primer tirón puede tardar un tiempo (hasta 15min) en setearse por primera vez, así que estaría bueno que quienes usen esta
herramienta lo hagan con tiempo antes. En la última etapa de instalación se ve lo siguiente:

![image](https://github.com/ipqa-research/FortranWorkshop/assets/24468661/84dd6462-1a77-44ca-aa4e-db5ef38545a0)


Tras lo cual pueden tirar el comando

```
fpm run
```

en la terminal y si tras una ejecución el programa saluda:

![image](https://github.com/ipqa-research/FortranWorkshop/assets/24468661/5c5955c6-f653-4919-a88c-4422ac8dba99)

Significa que probablemente está todo ok.


## Que asumo que ya se sabe
Lo que ya se vio en el [seminario de tooling de Fortran](https://github.com/ipqa-research/curso-linux/blob/main/fortran/tooling/README.md)


## Bibliografía
- [FortranTips](https://zmoon.github.io/FortranTipBrowser/tips/026.html)
- [Repositorio de distintos códigos Fortran disponibles](https://github.com/Beliavsky/Fortran-code-on-GitHub)
- [Web de Fortran-lang](https://fortran-lang.org/learn/)
- [FORTRAN FOR SCIENTISTS & ENGINEERS - Chapman](https://books.google.com.ar/books?id=OQhBMQAACAAJ)
- [Modern Fortran](https://livebook.manning.com/book/modern-fortran/chapter-4/v-12/)
- [Modern Fortran Explained](https://global.oup.com/academic/product/modern-fortran-explained-9780198876588?q=Fortran%202023&lang=en&cc=de)
- https://github.com/Fortran-FOSS-Programmers/Best_Practices

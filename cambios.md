Cambios hechos en la rama Bryan/Add/Makefile-test-modularization

## 1. Modularizacion
- Declaración de `functions.h`, `UnionFind.h` y `vec_maps.h` en `/include` con la declaración..
- Implementación de los `.cpp` en `/src` con las funciones y la clase.

En esta parte se cambiaron algunos nombres de funciones, métodos y variables para estandarizarlo. 

## 2. Makefile
- Creación de los `.o` en `/build` a partir de las fuentes en `/src`.
- Ejecución de los `.o` para crear `program.x`.
- Limpieza de los ejecutables en `\build`.




### Notas
pequeña guía para *markdown*
`code` ingresando [aqui]((https://www.example.com))

| Syntax | Description |
| ----------- | ----------- |
| Header | Title |
| Paragraph | Text |

```
  "firstName": "John",
  "lastName": "Smith",
  "age": 25
```

hola

    asd

>asd



Here's a sentence with a footnote. [^1]

~~The world is flat.~~

[^1]: This is the footnote.

- [x] Write the press release
- [ ] Update the website
- [ ] Contact the media

I need to highlight these ==very important words==.

H~2~O
X^2^ asd

![Tux, the Linux mascot](/assets/images/tux.png)


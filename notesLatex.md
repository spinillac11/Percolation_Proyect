# Notas para usar Latex Workshop
Instalarlo primero como extensión de VScode. Esta herramienta requiere tener instalado el paquete `texlive`.

## Instalación portátil de texlive
Nos ubicamos en home/user/ y hacemos

    mkdir -p texlive
    cd texlive
    wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
    tar -xzf install-tl-unx.tar.gz
    cd install-tl-*

Instalamos solo lo esencial, portátil y en ~/texlive/2025, para lo cual creamos un archivo `texlive-minimal.profile` con el siguiente contenido

    selected_scheme scheme-small
    TEXDIR ~/texlive/2025
    TEXMFCONFIG ~/.texlive2025/texmf-config
    TEXMFVAR ~/.texlive2025/texmf-var
    TEXMFHOME ~/texmf
    TEXMFLOCAL ~/texlive/texmf-local
    TEXMFSYSCONFIG ~/texlive/2025/texmf-config
    TEXMFSYSVAR ~/texlive/2025/texmf-var
    binary_x86_64-linux 1
    instopt_letter 0
    instopt_portable 0
    tlpdbopt_autobackup 0
    tlpdbopt_backupdir tlpkg/backups
    tlpdbopt_create_formats 1
    tlpdbopt_install_docfiles 0
    tlpdbopt_install_srcfiles 0

Ahora ejecutamos 

    ./install-tl --profile=texlive-minimal.profile
    

Añadimos al PATH, con `nano ~/.bashrc` copiamos, pegamos y guardamos (`Ctrl + O`, `Enter`, `Ctrl + X`) cambiando :

    export PATH=/home/banaya/texlive/2025/bin/x86_64-linux:$PATH
    export MANPATH=/home/banaya/texlive/2025/texmf-dist/doc/man:$MANPATH
    export INFOPATH=/home/banaya/texlive/2025/texmf-dist/doc/info:$INFOPATH

Cargamos la configuración

    source ~/.bashrc

Reinicamos la consola y verificamos que esté instalado correctamente

    which pdflatex
    which tlmgr

## Configuración Latex Workshop
Instalamos la extensión y abrimos la paleta de comandos con `Ctrl + Shift + P` y ejecutamos `Preferences: Open Workspace Settings (JSON)`. En el `.json` guardamos lo siguiente (cambiando adecuadamente el *username*):
```
{
  "latex-workshop.latex.tools": [
    {
      "name": "pdflatex",
      "command": "/home/banaya/texlive/2025/bin/x86_64-linux/pdflatex",
      "args": [
        "-interaction=nonstopmode",
        "-synctex=1",
        "-output-directory=out",
        "%DOC%"
      ]
    }
  ],
  "latex-workshop.latex.recipes": [
    {
      "name": "pdflatex → out/",
      "tools": ["pdflatex"]
    }
  ],
  "latex-workshop.latex.autoBuild.run": "onSave",
  "latex-workshop.view.pdf.viewer": "tab",
  "latex-workshop.latex.outDir": "./out",
  "latex-workshop.latex.clean.fileTypes": [
    "*.aux",
    "*.log",
    "*.out",
    "*.toc",
    "*.synctex.gz"
  ]
}
```
teniendo cuidado de fusionarlo correctamente en caso de tener más cosas en el archivo.

De esta forma ya queda integrada la extensión y el documento puede visualizarse al guardar. En el makefile se agregó al target `report` que también compila y crea la figura correctamente.


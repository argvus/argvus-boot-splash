---
title: Pantalla de Inicio de ARGVUS
description: Tema de Plymouth y guía de instalación para el entorno de escritorio ARGVUS
---

# Pantalla de inicio de ARGVUS

La pantalla de inicio de Argvus es un tema [Plymouth](https://www.freedesktop.org/wiki/Software/Plymouth/) para el ecosistema de escritorio Argvus. Es lo que ves entre encender la máquina y el momento en que comienza tu sesión gráfica.

## Documentación

Esta documentación está organizada en dos secciones principales:

### Guía del Usuario
Guías de instalación y uso para usuarios finales y administradores del sistema.

| Guía | Contenidos |
| --- | --- |
| [Instalación](/docs/argvus-boot-splash/installation/) | Requisitos, las tres opciones de instalación, qué hacen los hooks del paquete |
| [Uso](/docs/argvus-boot-splash/usage/) | Verificar la instalación, vista previa sin reiniciar, cambiar o revertir temas, hoja de trucos de comandos |
| [UKI y pantalla de inicio de systemd-boot](/docs/argvus-boot-splash/uki-splash/) | Usando `argvus-uki-splash.bmp` en un flujo de arranque UKI |
| [Desinstalación](/docs/argvus-boot-splash/uninstallation/) | Eliminar el paquete y restaurar el tema anterior |
| [Solución de problemas](/docs/argvus-boot-splash/troubleshooting/) | Síntomas comunes y sus causas |
| [Referencia](/docs/argvus-boot-splash/reference/) | Archivos instalados, metadatos del paquete, valores de color |

### [Guía del Desarrollador](/docs/argvus-boot-splash/developer-guide/)
Documentación técnica para contribuyentes y mantenedores.

- [Arquitectura](/docs/argvus-boot-splash/developer-guide/theme/) — Descriptor de Plymouth, modelo de renderizado y personalización
- [Empaquetado](/docs/argvus-boot-splash/developer-guide/packaging/) — Canal de compilación y recetas de paquetes
- [CI y Lanzamientos](/docs/argvus-boot-splash/developer-guide/ci-releases/) — Validación, pruebas y flujo de trabajo de lanzamiento

## Inicio Rápido

Para sistemas basados en Arch:

```sh
sudo pacman -S argvus-boot-splash   # or: sudo pacman -U ./argvus-boot-splash-<version>-1-any.pkg.tar.zst
```
El instalador establece el tema como predeterminado y regenera tu initramfs automáticamente.

---

- **Repositorio:** [github.com/argvus/argvus-boot-splash](https://github.com/argvus/argvus-boot-splash)
- **Licencia:** GPL-3.0-only
- **Reportes de errores:** [GitHub Issues](https://github.com/argvus/argvus-boot-splash/issues)

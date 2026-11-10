---
title: Referencia
description: Archivos instalados, metadatos del paquete y valores de color.
---

# Referencia

Referencia técnica sobre lo que instala el paquete y cuáles valores utiliza.

## Qué obtienes

| Componente | Descripción |
| --- | --- |
| Logo de Argvus | Marca centrada, dibujada sobre el logotipo de texto |
| Logotipo de texto | Texto `ARGVUS` debajo del logo |
| Barra de progreso | Barra delgada cuya anchura refleja el progreso de arranque de Plymouth |
| Diálogo de contraseña | Solicitud LUKS con un campo de entrada enmascarado (`•` viñetas) |
| Aparición gradual | La pantalla de inicio aparece gradualmente en ~1 segundo cuando Plymouth comienza |
| Bitmap UKI | `argvus-uki-splash.bmp` para arranques basados en UKI / systemd-boot |

El nombre del paquete es `argvus-boot-splash` y reemplaza al paquete anterior
`argvus-plymouth` si lo tenías instalado.

## Archivos instalados

Bajo `/usr/share/plymouth/themes/argvus/`:

| Archivo | Tamaño | Propósito |
| --- | --- | --- |
| `argvus.plymouth` | — | descriptor del tema (nombre, descripción, módulo) |
| `argvus.script` | — | el script del tema (lenguaje de scripting propio de Plymouth) |
| `argvus-logo.png` | 256x256 | logotipo, RGBA |
| `argvus-text.png` | 400x53 | marca de palabra, RGBA |
| `progress-bar.png` | 400x4 | parte rellenada de la barra de progreso |
| `progress-bar-track.png` | 400x4 | pista no rellena |
| `entry-box.png` | 400x48 | campo de entrada de contraseña |
| `entry-line.png` | 300x2 | regla/subrayado del campo de contraseña |
| `bullet.png` | 12x12 | carácter enmascarado |
| `logo-glow.png` | 260x300 | arte del resplandor del logotipo |
| `argvus-uki-splash.bmp` | 400x400, 32 bits | bitmap de inicio de UKI/systemd-boot |

Más la licencia en `/usr/share/licenses/argvus-boot-splash/LICENSE`.

## Metadatos del paquete

| Campo | Valor |
| --- | --- |
| Nombre | `argvus-boot-splash` |
| Arquitectura | `any` |
| Depende | `plymouth` |
| Dependencias opcionales | `mkinitcpio`, `dracut` |
| Conflictos / reemplaza | `argvus-plymouth` |
| Licencia | GPL-3.0-only |

## Colores

| Elemento | Color |
| --- | --- |
| Fondo | `#111316` |
| Acento (logo, marca, relleno de progreso) | `#3590BD` |
| Barra de progreso | `#262933` |
| Texto de solicitud de contraseña | gris-azulado claro (`#B8C4CE`) |

El tema utiliza un fondo oscuro sólido en cualquier resolución, por lo que nunca cambia automáticamente entre variantes claras y oscuras.

## Obtener ayuda

- Reporta errores y solicita funciones en el rastreador de problemas del proyecto.
- Problemas de seguridad: sigue [SECURITY.md](https://github.com/argvus/.github/blob/main/SECURITY.md) — no abras un problema público por vulnerabilidades.
- Código, compilaciones y versiones: la raíz del repositorio ([README](https://github.com/argvus/argvus-boot-splash/blob/main/README.md)).
- Contribuir: [CONTRIBUTING.md](https://github.com/argvus/.github/blob/main/CONTRIBUTING.md).
- Licencia: [GPL-3.0-only](https://github.com/argvus/argvus-boot-splash/blob/main/LICENSE).

## Próximos pasos

- [Installation](/docs/argvus-boot-splash/installation/)
- [Usage](/docs/argvus-boot-splash/usage/)
- [Troubleshooting](/docs/argvus-boot-splash/troubleshooting/)

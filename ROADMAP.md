# Atlas Kernel Roadmap

Para lograr los objetivos de Atlas de forma sostenible, implementaremos el siguiente enfoque progresivo:

## Phase 0: Atlas Foundation (Current Focus)
- Establecer la infraestructura de compilación y el árbol de configuración (`configs/`).
- Crear scripts de construcción reproducible (`scripts/build.sh`).
- Definir el branding/versionado (lograr que `uname -r` reporte `6.12.x-atlas`).
- **Objetivo**: Producir el primer kernel Atlas arrancable sin modificar opciones base de la configuración.

## Phase 1: Legacy Cleanup (Platform Simplification)
- Eliminar soporte a subsistemas obsoletos, hardware arcaico y sistemas de archivos en desuso.
- **Objetivos**:
  - Eliminar protocolos de red muertos (`HAMRADIO`, `ISDN`, `ATALK`, `IPX`).
  - Eliminar hardware legacy que ya no existe en PCs modernos (`PCMCIA`, `PARPORT`).
  - Eliminar sistemas de archivos deprecados (`REISERFS`, `JFS`).
- **Excepciones por Compatibilidad Profesional**: Se mantendrá soporte para `FIREWIRE`, `XFS` y `NFS`.
- Esto reduce la complejidad sin romper la compatibilidad moderna, favoreciendo la mantenibilidad.

## Phase 2: Desktop Experience Optimization
- **Evaluar** planificadores de CPU (aprovechando EEVDF en Linux 6.12), modelos de *preemption*, gestión de memoria y políticas de energía.
- El objetivo es investigar mejoras en la capacidad de respuesta del escritorio, siempre priorizando la estabilidad y reconociendo el gran nivel de optimización que ya provee upstream/Debian.

## Phase 3: Modernization & Security
- Evaluar el recorte de familias de procesadores extremadamente antiguas dentro de la arquitectura x86_64.
- Implementar características de seguridad (*hardening*) manteniendo intacta la compatibilidad con el espacio de usuario (*userspace*).

# Atlas Kernel Principles

El desarrollo del kernel Atlas para Austral OS se rige por cuatro principios fundamentales. Ante cualquier duda técnica sobre la configuración, parcheo, o la inclusión de una nueva funcionalidad, la decisión debe evaluarse estrictamente contra estos pilares:

## 1. Stability before performance
La fiabilidad del sistema es primordial. Un entorno de escritorio no puede permitirse bloqueos inesperados, corrupciones de memoria o fallos en el *userspace* debido a parches experimentales en el kernel o configuraciones extremas. Preferimos un sistema ligeramente más conservador si esto garantiza *uptime* y previsibilidad.

## 2. Simplicity before customization
No buscamos ofrecer docenas de ramas, planificadores o *tweaks* infinitos para que el usuario elija. Atlas provee una configuración única, cuidadosamente curada y óptima por defecto para el entorno de Austral OS. Menos complejidad significa menos errores.

## 3. Compatibility before optimization
Aunque eliminemos soporte para hardware muy antiguo, no sacrificaremos características críticas que mantienen a Linux universal (como la compatibilidad con sistemas de archivos profesionales o interfaces modernas estándar) por ganancias marginales de rendimiento. La retrocompatibilidad en *userspace* es inviolable.

## 4. Long-term maintainability
¿Esto hace a Atlas más mantenible? Esta es la pregunta clave antes de integrar cualquier cambio. Si un cambio requiere rebases constantes, introduce dependencias frágiles, o se aleja demasiado de la base de Debian/Linux, probablemente no merece la pena.

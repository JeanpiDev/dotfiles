---
name: resumen-commits
description: >-
  Genera el resumen de trabajo / de commits de Jean para pegar en Notion. Úsalo cuando pida
  "resumen", "resumen de commits", "el título y las tareas", "el aproximado", "las tareas de
  los commits" o un resumen "en formato Notion". Ofrece DOS formatos y SIEMPRE pregunta cuál:
  TABLA (Tarea | Tiempo (h) | Fecha | Descripción — su registro de trabajo/auditoría) o
  BULLETS (resumen técnico con hashes + branch). Todo en español, entregado en el chat.
---

# Resumen de trabajo / commits (formato Notion)

Jean pega estos resúmenes en su Notion. Hay **dos formatos**; **siempre pregúntale cuál quiere**
antes de generar (salvo que él ya lo diga: "en tabla" / "en bullets"). Todo va **en español** y
**dentro del chat** (texto para copiar), nunca creando una base de datos en Notion.

## 1. Reunir el alcance

1. Mira los commits relevantes con `git log` (por defecto, los de la rama actual que no están en
   `main`/`dev`; si el rango es ambiguo, confírmalo con Jean en una línea).
2. Revisa los diffs/subjects lo necesario para agrupar el trabajo por **tema**, no por commit.

## 2. Preguntar el formato

Pregunta breve: **¿TABLA (registro de trabajo) o BULLETS (técnico)?** Guía de desempate: si menciona
**"tareas" + "tiempo/aproximado"** o **"formato Notion"** → por defecto **TABLA**. Si pide un
**"resumen de commits"** puramente técnico con hashes → **BULLETS**.

## 3a. Formato TABLA (registro de trabajo / auditoría)

Es el formato de su tabla de seguimiento. Estructura exacta:

1. **Título en negrita** arriba: una línea que cubra el eje del trabajo (estilo título de PR, español).
2. **Tabla** con columnas en este orden: `Tarea` | `Tiempo (h)` | `Fecha` | `Descripción`.
   - `Tarea`: nombre del tema **en negrita**.
   - `Tiempo (h)`: **estimación aproximada en horas** (la estimas tú por el alcance/commits; ver heurística abajo).
   - `Fecha`: formato `30 jun 2026` (usa la fecha de los commits o la del trabajo).
   - `Descripción`: **extensa**, con TODOS los identificadores (`archivo`, `función`, rutas, flags,
     endpoints, modelos) en `inline code`.
3. **Agrupar a alto nivel**: ~4-5 filas temáticas, **NO una fila por commit**.
4. Cerrar con **Total aproximado: ~X h**.

**Heurística de horas** (aproximado, no exacto): pondera por tamaño del cambio y complejidad
—feature nueva/servicio ≈ 2-5 h, endpoint/módulo ≈ 1-3 h, fix/ajuste ≈ 0.5-1.5 h, docs/config ≈ 0.5-1 h—
y redondea a medias horas. Es "el aproximado"; Jean lo ajusta si hace falta.

**NO hacer:** NO crear base de datos en Notion (solo si lo pide explícito); NO entregar bullets de texto
plano cuando pidió tabla; NO incluir una fila de "limpieza/ajustes" salvo que la pida (intégralo en otras filas).

## 3b. Formato BULLETS (resumen técnico)

1. **Título en negrita** (español), una línea que cubra el eje del trabajo. Inclúyelo siempre.
2. **Bullets planos** (lista única, sin sub-secciones). Cada bullet:
   `**Término clave**: explicación de 1 línea con \`identificadores\` en code → resultado.`
   El término clave es el "qué" (área/hallazgo/componente); la explicación SÍ lleva el detalle
   técnico (archivos, funciones, rutas, flags) en `inline code`.
3. **Cierre con commits**: último bullet lista los hashes + subjects y la branch.

### Ejemplo (BULLETS)

> **Descargas rotas en el historial de reportes**
>
> - **Rewrite comodín de Next.js**: el `rewrite` `/api/*` se evaluaba como `afterFiles` y secuestraba los handlers `/api/files/report|transcript/[id]` → 404. Acotado a `/api/v1/*` en `next.config.js`.
> - **Botones rotos**: `reportes.py` valida que el archivo exista (`_file_available`) antes de exponer la URL.
> - **Commits** (branch `feat/sonix-transcription-scraper`): `086b5cb` fix(downloads), `4236485` fix(history).

## Reglas transversales

- Español siempre; identificadores en `inline code` en ambos formatos.
- Entregar el resultado **en el chat** para copiar/pegar; no tocar Notion salvo que lo pida.
- Si Jean no especifica el rango de commits ni el formato, pregúntale ambos en una sola interacción corta.

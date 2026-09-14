# dotfiles

Configuración personal de mi escritorio **Omarchy** (Arch Linux + Hyprland).

Este repositorio guarda **solo lo que es mío**. Omarchy trae sus propios valores
por defecto y los reinstala en cada actualización; duplicarlos aquí solo
generaría ruido y conflictos. Lo que verás son sobreescrituras concretas, cada
una con un motivo detrás.

---

## Qué hay dentro

### Hyprland — `home/.config/hypr/`

Ficheros **Lua**. Desde Omarchy 4.0 el compositor usa `configProvider: lua`; los
antiguos `.conf` ya no se leen.

| Fichero | Para qué |
|---|---|
| `input.lua` | **AltGr en el Ctrl derecho** (`lv3:switch`) |
| `bindings.lua` | `PRINT` captura incluyendo el borde de la ventana |
| `looknfeel.lua` | Sin animación al congelar pantalla para capturas |
| `hyprland.lua`, `monitors.lua` | Punto de entrada y monitores |

**Por qué el AltGr:** el teclado (ATTACK SHARK R82 HE, formato 75%) no tiene Alt
derecho. Sin AltGr, el layout `latam` no puede escribir `@ \ | [ ] { } ~ €` —
imprescindibles para programar. `lv3:switch` convierte el Ctrl derecho en el
modificador de tercer nivel; el Ctrl izquierdo conserva todos sus atajos.

**Por qué el borde en las capturas:** el script de Omarchy toma la geometría de
`hyprctl clients` (`.at` y `.size`), que es la del *contenido* y deja fuera el
borde de 2 px y la sombra de 16 px. El envoltorio añade 20 px de margen —dentro
de los 24 px de hueco, así que no invade la ventana vecina— pero **solo cuando la
selección coincide exactamente con una ventana**, para no alterar los recortes
hechos a mano.

### Omarchy — `home/.config/omarchy/`

| Fichero | Para qué |
|---|---|
| `shell.json` | Barra (Quickshell) y tiempos de inactividad: 5 min salvapantallas, 10 min bloqueo |
| `hooks/post-update.d/mis-preferencias.hook` | Reaplica preferencias tras cada `omarchy update` |

**El hook existe porque las actualizaciones pisan la configuración.** Reinstalan
paquetes, reactivan servicios y reescriben `shell.json` con los valores por
defecto. El hook vuelve a dejarlo como debe, y está diseñado para **apartarse
solo**: desactiva Bluetooth, WiFi o CUPS únicamente si comprueba que no hay
hardware o impresora detrás. Si algún día conecto un dongle, deja de intervenir.

### Scripts — `home/.local/bin/`

| Script | Qué hace |
|---|---|
| `backup-home` | Copias de `/home` con restic: backup, rotación, verificación y **prueba de restauración real** |
| `omarchy-screenshot-padded` | Capturas con margen, para que salga el borde redondeado |

### Otros

- `voxtype/config.toml` — dictado por voz en español. Modelo **multilingüe**
  (`small`): los modelos con sufijo `.en` son solo inglés y devuelven ruido al
  pedirles español. Incluye un diccionario de correcciones para términos
  técnicos, con reglas **solo de errores observados**: una regla inventada
  corrompe transcripciones que ya eran correctas.
- `alacritty/alacritty.toml` — fuente y tamaño.
- `aether/settings.json` — generador de temas a partir del fondo de pantalla.
- `.claude/skills/` — skills propias de Claude Code: `find-docs`,
  `project-documenter` y `resumen-commits`.

---

## Instalación

```bash
git clone https://github.com/JeanpiDev/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --dry-run   # ver qué haría, sin tocar nada
./install.sh             # aplicar
```

Cada fichero bajo `home/` se enlaza simbólicamente a su ruta equivalente en
`$HOME`. Si ya existe un fichero real, se guarda una copia `.bak.<fecha>` antes
de reemplazarlo. El script es **idempotente**: ejecutarlo dos veces no hace daño.

Al ser enlaces, editar el fichero en `~/.config` es editar el del repositorio.
No hay que acordarse de copiar nada.

> [!NOTE]
> `restic/excludes.txt` contiene **rutas absolutas** con mi nombre de usuario
> (`/home/jeanpi/...`). Restic no expande variables en los ficheros de exclusión,
> así que en otra máquina hay que ajustarlas a mano. Si no se hace, las
> exclusiones dejan de coincidir **en silencio** y el backup crece sin avisar.

---

## Lo que NO está aquí, a propósito

> [!WARNING]
> **Ningún secreto vive en este repositorio, y ninguno debe llegar nunca.**
> Git no olvida: un secreto commiteado sigue en el historial aunque se borre
> después. Por eso el `.gitignore` existía **antes** del primer commit.

Excluidos de forma explícita:

| Fichero | Motivo |
|---|---|
| `.config/restic/password` | **Clave de cifrado del backup.** Quien la tenga, puede descifrar las copias |
| `.config/restic/restic.env` | Contiene (o contendrá) las credenciales de Backblaze B2 |

Para restaurar en una máquina nueva, `restic.env.example` documenta la
estructura sin valores reales. La clave de cifrado se recupera del gestor de
contraseñas — **si se pierde, el backup es ilegible para siempre.**

También quedan fuera, por no ser míos:

- `tmux.conf`, `starship.toml`, `lazygit/config.yml` — idénticos a los de Omarchy
- `btop.conf` — su diferencia era un cambio de versión, no una personalización
- `hypr/*.conf` — muertos desde la 4.0
- `.local/bin/{claude,gh,codex,…}` — generados por `mise`

---

## Sistema de referencia

| | |
|---|---|
| SO | Arch Linux + [Omarchy](https://omarchy.org/) 4.0 |
| Compositor | Hyprland (configuración Lua) |
| Shell del escritorio | Quickshell (sustituyó a waybar + walker) |
| Terminal | Alacritty + tmux |
| Teclado | ATTACK SHARK R82 HE, layout `latam` |

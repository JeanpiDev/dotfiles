# Backup de /home con restic

## Ficheros

| Ruta | Qué es |
|---|---|
| `~/.config/restic/restic.env` | Destino y credenciales (modo 0600) |
| `~/.config/restic/password` | Clave de cifrado del repositorio (modo 0600) |
| `~/.config/restic/excludes.txt` | Qué NO se respalda |
| `~/.local/bin/backup-home` | Script principal |
| `~/.config/systemd/user/backup-home.{service,timer}` | Automatización diaria |

## Uso diario

```bash
backup-home backup        # backup + rotación (lo hace el timer solo)
backup-home snapshots     # listar copias disponibles
backup-home check         # verificar integridad del repositorio
backup-home restore-test  # comprobar que una restauración real funciona
```

El timer corre **todos los días a las 14:00** (con `Persistent=true`: si el equipo
estaba apagado, se ejecuta al encender). Estado: `systemctl --user list-timers`.

Retención: 7 diarias, 4 semanales, 6 mensuales.

## Restaurar de verdad

```bash
set -a; source ~/.config/restic/restic.env; set +a

restic snapshots                                    # elegir ID
restic restore <ID> --target /ruta/destino          # todo
restic restore latest --target /tmp/rec --include ~/.config/hypr   # solo una parte
restic mount /mnt/backup                            # explorar como sistema de ficheros
```

## Migrar a Backblaze B2

1. Crear cuenta en backblaze.com y un bucket **privado**.
2. Crear una Application Key limitada a ese bucket → da `keyID` y `applicationKey`.
3. Editar `restic.env`: comentar la línea `RESTIC_REPOSITORY` local y descomentar
   las tres de B2, rellenando bucket, `keyID` y `applicationKey`.
4. `set -a; source ~/.config/restic/restic.env; set +a && restic init`
5. `backup-home backup` y luego `backup-home restore-test`.

El repositorio local se puede borrar después, o mantener como copia rápida.

## AVISOS

- **La clave de `password` es irrecuperable.** Si se pierde, el backup entero es
  ilegible para siempre. Debe estar guardada en Bitwarden.
- **Nunca poner el repositorio dentro de `/home`** sin excluirlo en `excludes.txt`:
  restic se respaldaría a sí mismo y los ficheros temporales fallarían al leerse.
- `restic backup` devuelve **código 3** cuando el snapshot se creó pero algún
  fichero no se pudo leer. Es un aviso, no un fallo; el script ya lo contempla.

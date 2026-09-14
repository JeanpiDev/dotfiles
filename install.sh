#!/usr/bin/env bash
#
# Enlaza los ficheros de este repositorio dentro de $HOME.
#
# Cada fichero bajo home/ se enlaza a la ruta equivalente en $HOME, conservando
# la estructura. Si ya existe un fichero real ahí, se guarda una copia con
# sufijo .bak.<fecha> antes de reemplazarlo. Es idempotente: ejecutarlo dos
# veces no hace daño.
#
#   ./install.sh            aplica los enlaces
#   ./install.sh --dry-run  solo muestra qué haría

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$REPO/home"
DRY=false
[[ ${1:-} == "--dry-run" ]] && DRY=true

enlazados=0; omitidos=0; respaldados=0

while IFS= read -r -d '' file; do
  rel="${file#"$SRC"/}"
  dest="$HOME/$rel"

  # Ya apunta aquí: nada que hacer.
  if [[ -L $dest && "$(readlink -f "$dest")" == "$(readlink -f "$file")" ]]; then
    omitidos=$((omitidos + 1))
    continue
  fi

  if $DRY; then
    [[ -e $dest ]] && echo "  reemplazaría  ~/$rel" || echo "  enlazaría     ~/$rel"
    enlazados=$((enlazados + 1))
    continue
  fi

  mkdir -p "$(dirname "$dest")"

  # Respalda cualquier fichero real que estorbe (los enlaces viejos se pisan).
  if [[ -e $dest && ! -L $dest ]]; then
    cp -a "$dest" "$dest.bak.$(date +%s)"
    respaldados=$((respaldados + 1))
  fi

  ln -sfn "$file" "$dest"
  enlazados=$((enlazados + 1))
done < <(find "$SRC" -type f -print0)

if $DRY; then
  echo
  echo "Simulación: $enlazados por enlazar, $omitidos ya correctos."
  exit 0
fi

echo "Enlazados: $enlazados   Ya correctos: $omitidos   Respaldados: $respaldados"
echo
echo "Recuerda lo que NO está en el repositorio y hay que crear a mano:"
echo "  ~/.config/restic/restic.env   (copia restic.env.example y rellena)"
echo "  ~/.config/restic/password     (clave de cifrado, chmod 600)"

#!/usr/bin/env bash
# checar-privacidade.sh — procura dados reais da máquina onde as saídas foram geradas nas
# páginas e em TODO o histórico do git do Guia TypeScript.
#
# Os valores reais NÃO ficam escritos aqui (senão o próprio script os
# levaria para o histórico): são lidos na hora, da máquina onde ele roda:
#   - o nome do computador (hostname) e o usuário (whoami);
#   - a pasta pessoal real (/home/<usuário>) e a pasta-mãe do projeto;
# Lista extra opcional, FORA do repo: ../.proibido-ts.txt (ou PROIBIDO=caminho).
# Padrões genéricos embutidos: IPv4 (exceto 127.*, 0.0.0.0 e os
# ilustrativos 192.168.0.*), MAC, GUID e qualquer /home/<nome> que não seja ana.
# "re:" = expressão regular (grep -P), sem diferenciar maiúsculas.
# "atual:" = confere só os arquivos atuais (não o histórico), diferenciando maiúsculas.
set -u
cd "$(dirname "$0")/.."
LISTA="${PROIBIDO:-../.proibido-ts.txt}"
USUARIO="$(whoami)"
MAQUINA="$(hostname)"
MAE="$(cd ../.. && pwd)"          # pasta onde ficam os projetos de trabalho

padroes=()
padroes+=("$MAQUINA")
padroes+=("/home/$USUARIO")
padroes+=("re:(?<![\\w-])\\Q$USUARIO\\E@")
padroes+=("re:@\\Q$USUARIO\\E(?![\\w-])")
[ "$MAE" != "/" ] && padroes+=("$MAE")
padroes+=("re:/home/(?!ana\\b)[a-z_][a-z0-9_-]*")
padroes+=("re:(?<![\\d.])(?!127\\.|0\\.0\\.0\\.0(?![\\d.])|192\\.168\\.0\\.)(?:25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]?\\d)\\.(\\d{1,3}\\.){2}\\d{1,3}(?![\\d.])")
padroes+=("re:\\b(?!02[:-])([0-9a-f]{2}[:-]){5}[0-9a-f]{2}\\b")
padroes+=("re:\\b[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\\b")

if [ -f "$LISTA" ]; then
  echo "Usando lista $LISTA (além dos padrões embutidos)."
  while IFS= read -r linha || [ -n "$linha" ]; do
    [[ -z "$linha" || "$linha" == \#* ]] && continue
    padroes+=("$linha")
  done < "$LISTA"
fi

falhou=0
for pad0 in "${padroes[@]}"; do
  atual=0; ci=(-i)
  if [[ "$pad0" == atual:* ]]; then atual=1; ci=(); pad0="${pad0#atual:}"; fi
  if [[ "$pad0" == re:* ]]; then pad="${pad0#re:}"; opt=(-P "${ci[@]}"); else pad="$pad0"; opt=(-F "${ci[@]}"); fi
  achou=$(git ls-files -co --exclude-standard | grep -E '\.(html|js|md|css|txt|json|ts|sh)$|(^|/)\.gitignore$' | xargs -r grep -n -H 2>/dev/null "${opt[@]}" -e "$pad" -- 2>/dev/null | head -5)
  if [ $atual = 1 ]; then hist=0; else hist=$(git log --all -p 2>/dev/null | grep -c "${opt[@]}" -e "$pad"); fi
  if [ -n "$achou" ] || [ "$hist" != "0" ]; then
    falhou=1; echo "FALHA: $pad (histórico: $hist)"; [ -n "$achou" ] && echo "$achou"
  fi
done
# autor/committer dos commits
ruins=$(git log --all --format='%an <%ae>|%cn <%ce>' 2>/dev/null | tr '|' '\n' | sort -u | grep -v '^Wallysondevs <wallysondevs@users.noreply.github.com>$')
if [ -n "$ruins" ]; then falhou=1; echo "FALHA: commits com outro autor/committer:"; echo "$ruins"; fi
[ $falhou = 0 ] && echo "OK: nenhuma string proibida nas páginas nem no histórico."
exit $falhou

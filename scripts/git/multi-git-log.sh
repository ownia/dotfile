#!/bin/bash
set -u

LIMIT=100

while getopts ":n:h" opt; do
  case "$opt" in
    n) LIMIT="$OPTARG" ;;
    h)
      echo "Usage: $0 [-n count]"
      exit 0
      ;;
    *) exit 1 ;;
  esac
done

collect_logs() {
  for d in */; do
    [[ -d "$d/.git" ]] || continue
    repo=$(basename "$d")

    git -C "$d" rev-parse --verify HEAD >/dev/null 2>&1 || continue

    git -C "$d" log \
        --max-count="$LIMIT" \
        --pretty=format:"%ci|$repo|%h|%an|%s"
  done
}

logs=$(collect_logs)

highlighted=$(echo "$logs" \
    | sort -r \
    | awk -F'|' '{
        printf "\033[36m%s\033[0m | "   \
               "\033[33m%-16s\033[0m | " \
               "\033[32m%s\033[0m | "   \
               "\033[35m%-12s\033[0m | %s\n", \
               $1, $2, $3, $4, $5
    }')

if [[ -t 1 ]] && command -v fzf >/dev/null 2>&1; then
    selected=$(echo "$highlighted" | fzf \
        --ansi \
        --reverse \
        --height 100% \
        --bind "j:down,k:up,g:first,G:last,ctrl-d:half-page-down,ctrl-u:half-page-up")

    if [[ -n "$selected" ]]; then
        repo=$(echo "$selected" | awk -F'|' '{print $2}' | xargs)
        commit=$(echo "$selected" | awk -F'|' '{print $3}' | xargs)

        git -C "$repo" show "$commit"
    fi
else
    echo "$highlighted" | less -R
fi

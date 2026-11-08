#!/bin/sh
# 편집기에서 내보낸 JSON으로 data.json을 바꾸고 GitHub에 올립니다.
set -e
cd "$(dirname "$0")"
SRC="${1:-$(ls -t "$HOME"/Downloads/전력배치_*.json 2>/dev/null | head -1)}"
[ -n "$SRC" ] && [ -f "$SRC" ] || { echo "내보낸 JSON 파일을 찾지 못했습니다."; exit 1; }
node -e 'const d=JSON.parse(require("fs").readFileSync(process.argv[1],"utf8"));if(!Array.isArray(d.items||d))throw new Error("items 없음")' "$SRC"
cp "$SRC" data.json
git add data.json
if git diff --cached --quiet; then echo "바뀐 내용이 없습니다."; exit 0; fi
git commit -m "데이터 갱신: $(basename "$SRC")"
git push
echo "올렸습니다. 1~2분 뒤 페이지에 반영됩니다."

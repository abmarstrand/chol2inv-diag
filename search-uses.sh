for q in '"diag(chol2inv" org:cran' 'chol2inv diag repo:wch/r-source'; do
  printf '\n### %s\n' "$q"
  gh api -X GET /search/code -f q="$q" -f per_page=100 \
    --jq '.items[] | [.repository.full_name, .path, .html_url] | @tsv'
done
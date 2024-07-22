overleaf_repo := "https://git@git.overleaf.com/668273f5d14067a22517615c"

clone-overleaf:
  git clone {{overleaf_repo}} overleaf

update-overleaf: sync-overleaf
  cd overleaf; git add .; git commit -am "update"; git push

sync-overleaf:
  #!/usr/bin/env bash
  set -eo pipefail
  # tlmgr install bibexport
  touch files/bibexport.bib
  quarto render --profile man --to pdf
  bibexport -o files/bibexport.bib --nosave article.aux   
  rsync _manuscript/_tex/ overleaf/ -r
  temp_file=$(mktemp)
  awk '/\\begin\{document\}/ {flag=1; next} /\\end\{document\}/ {flag=0} flag' overleaf/article.tex | awk '!/\\maketitle/' > $temp_file
  mv $temp_file overleaf/article.tex
  rsync article_files overleaf -r
  just clean-man

[private]
clean-man:
  -rm article.{aux,bbl,blg,log,tex}
  -rm -rf article_files
  -rm trackchanges.sty *.cls
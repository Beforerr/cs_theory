overleaf_repo := "https://git@git.overleaf.com/668273f5d14067a22517615c"

clone-overleaf:
  git clone {{overleaf_repo}} overleaf

update-overleaf: sync-overleaf
  cd overleaf; git add .; git commit -am "update"; git push

sync-overleaf: tex_render tex_keep_document

tex_render to="pdf":
  #!/usr/bin/env bash
  touch files/bibexport.bib
  quarto render --profile man --to {{to}}
  just tex_export_bib
  rsync _manuscript/_tex/ overleaf/ -r
  rsync article_files overleaf -r
  just clean-man

tex_export_bib:
  #!/usr/bin/env bash
  command -v bibexport >/dev/null || tlmgr install bibexport
  bibexport -o files/bibexport.bib --nosave article.aux

tex_keep_document:
  #!/usr/bin/env bash
  temp_file=$(mktemp)
  awk '/\\begin\{document\}/ {flag=1; next} /\\end\{document\}/ {flag=0} flag' overleaf/article.tex | awk '!/\\maketitle/' > $temp_file
  mv $temp_file overleaf/article.tex

[private]
clean-man:
  -rm article.{aux,bbl,blg,log,tex}
  -rm trackchanges.sty *.cls
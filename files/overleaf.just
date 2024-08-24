overleaf_repo := "https://git@git.overleaf.com/668273f5d14067a22517615c"

clone_overleaf:
  git clone {{overleaf_repo}} overleaf

update_overleaf: sync_overleaf
  cd overleaf; git add .; git commit -am "update"; git push

sync_overleaf: tex_render tex_keep_document tex_export_bib tex_clean

tex_render to="pdf":
  #!/usr/bin/env bash
  touch files/bibexport.bib
  quarto render --profile man --to {{to}}
  rsync _manuscript/_tex/ overleaf/ -rcL
  rsync article_files overleaf -a --size-only

[private]
tex_export_bib:
  #!/usr/bin/env bash
  command -v bibexport >/dev/null || tlmgr install bibexport
  bibexport -o files/bibexport.bib --nosave article.aux

[private]
tex_keep_document:
  #!/usr/bin/env bash
  temp_file=$(mktemp)
  awk '/\\begin\{document\}/ {flag=1; next} /\\end\{document\}/ {flag=0} flag' overleaf/article.tex | awk '!/\\maketitle/' > $temp_file
  mv $temp_file overleaf/article.tex

[private]
tex_clean:
  -rm article.{aux,bbl,blg,log,tex}
  -rm trackchanges.sty *.cls
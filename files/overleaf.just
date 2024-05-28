overleaf_repo := ""

clone-overleaf:
  git clone {{overleaf_repo}} overleaf

update-overleaf: sync-overleaf
  cd overleaf; git add .; git commit -am "update"; git push

sync-overleaf:
  # tlmgr install bibexport
  touch files/bibexport.bib
  quarto render --profile man --to agu-pdf
  bibexport -o files/bibexport.bib --nosave article.aux   
  rsync _manuscript/_tex/ overleaf/ -r
  just clean-man

[private]
clean-man:
  rm article.{log,bbl,blg,aux} trackchanges.sty *.cls
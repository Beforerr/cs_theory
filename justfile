import 'files/quarto.just'

default:
  just --list

ensure_env:
  rsync --update --recursive ~/projects/share/quarto/ ./

pptx:
  quarto render index.qmd --to pptx
  cp _site/index.pptx presentations/
  open presentations/index.pptx
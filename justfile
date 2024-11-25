import 'files/quarto.just'
import 'files/overleaf.just'

default:
  just --list

ensure-env: clone-overleaf
  rsync --update --recursive ~/projects/share/quarto/ ./
  pixi install

pptx:
  quarto render index.qmd --to pptx
  cp _site/index.pptx presentations/
  open presentations/index.pptx

poster path="presentations/AGU24.qmd":
  Rscript -e 'pagedown::chrome_print("{{path}}")'
  rm {{without_extension(path)}}.html

aas-process:
  sed -i '' 's/\\includegraphics/\\plotone/g' overleaf/article.tex
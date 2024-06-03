import 'files/quarto.just'

default:
  just --list

ensure_env:
  rsync --update --recursive ~/projects/share/quarto/ ./
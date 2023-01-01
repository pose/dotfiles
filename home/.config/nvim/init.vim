set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc

" Only load if Plug has already been installed
if ! empty(globpath(&rtp, 'autoload/plug.vim'))
  lua require("pose")
endif

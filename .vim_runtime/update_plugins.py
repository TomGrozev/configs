# This simple update script was taken from https://github.com/amix/vimrc.
# It works well so yay opensource!!!

try:
    import concurrent.futures as futures
except ImportError:
    try:
        import futures
    except ImportError:
        futures = None

import subprocess
import shutil

from os import path

# Disabled plugins
# mayansmoke https://github.com/vim-scripts/mayansmoke
# open_file_under_cursor.vim https://github.com/amix/open_file_under_cursor.vim
# vim-bundle-mako https://github.com/sophacles/vim-bundle-mako
# vim-coffee-script https://github.com/kchmck/vim-coffee-script
# vim-colors-solarized https://github.com/altercation/vim-colors-solarized
# vim-less https://github.com/groenewege/vim-less
# vim-pyte https://github.com/therubymug/vim-pyte
# goyo.vim https://github.com/junegunn/goyo.vim
# vim-zenroom2 https://github.com/amix/vim-zenroom2
# gruvbox https://github.com/morhetz/gruvbox
# vim-pug https://github.com/digitaltoad/vim-pug
# rust.vim https://github.com/rust-lang/rust.vim
# vim-gist https://github.com/mattn/vim-gist
# vim-ruby https://github.com/vim-ruby/vim-ruby
# vim-visual-multi https://github.com/mg979/vim-visual-multi

# --- Globals ----------------------------------------------
PLUGINS = """
emmet-vim https://github.com/mattn/emmet-vim
nerdtree https://github.com/scrooloose/nerdtree
vim-devicons https://github.com/ryanoasis/vim-devicons
vim-gitgutter https://github.com/airblade/vim-gitgutter
vim-fugitive https://github.com/tpope/vim-fugitive
vim-elixir https://github.com/elixir-editors/vim-elixir
ale https://github.com/w0rp/ale
vim-surround https://github.com/tpope/vim-surround
vim-multiple-cursors https://github.com/terryma/vim-multiple-cursors
lightline.vim https://github.com/itchyny/lightline.vim
nord-vim https://github.com/arcticicestudio/nord-vim
ctrlp.vim https://github.com/ctrlpvim/ctrlp.vim
ack.vim https://github.com/mileszs/ack.vim
auto-pairs https://github.com/jiangmiao/auto-pairs
vim-yankstack https://github.com/maxbrunsfeld/vim-yankstack
bufexplorer https://github.com/jlanzarotta/bufexplorer
nginx.vim https://github.com/chr4/nginx.vim
sslsecure.vim https://github.com/chr4/sslsecure.vim
vim-indent-object https://github.com/michaeljsmith/vim-indent-object
vim-snipmate https://github.com/garbas/vim-snipmate
vim-snippets https://github.com/honza/vim-snippets
vim-expand-region https://github.com/terryma/vim-expand-region
vim-repeat https://github.com/tpope/vim-repeat
vim-commentary https://github.com/tpope/vim-commentary
vim-flake8 https://github.com/nvie/vim-flake8
vim-abolish https://github.com/tpope/tpope-vim-abolish
vim-markdown https://github.com/plasticboy/vim-markdown
typescript-vim https://github.com/leafgarland/typescript-vim
vim-javascript https://github.com/pangloss/vim-javascript
vim-python-pep8-indent https://github.com/Vimjas/vim-python-pep8-indent
YouCompleteMe https://github.com/ycm-core/YouCompleteMe
vim-easymotion https://github.com/easymotion/vim-easymotion
vim-json https://github.com/elzr/vim-json
vim-endwise https://github.com/tpope/vim-endwise
indentLine https://github.com/Yggdroot/indentLine
tagbar https://github.com/majutsushi/tagbar
tlib https://github.com/vim-scripts/tlib
vim-addon-mw-utils https://github.com/MarcWeber/vim-addon-mw-utils
""".strip()

SOURCE_DIR = path.join(path.dirname(__file__), "plugins")

def download_extract_replace(plugin_name, github_url, source_dir):
    # remove the current plugin and replace it with the extracted
    plugin_dest_path = path.join(source_dir, plugin_name)

    try:
        shutil.rmtree(plugin_dest_path)
    except OSError:
        pass

    # clone repos
    subs = subprocess.Popen(["git", "clone", "--recurse-submodules", "-j8", "--quiet", github_url, plugin_dest_path])
    subs.wait()

    print("updated {0}".format(plugin_name))


def update(plugin):
    name, github_url = plugin.split(" ")
    download_extract_replace(name, github_url, SOURCE_DIR)


if __name__ == "__main__":
    try:
        if futures:
            with futures.ThreadPoolExecutor(16) as executor:
                executor.map(update, PLUGINS.splitlines())
        else:
            [update(x) for x in PLUGINS.splitlines()]
    finally:
        print("All plugins updated :)")

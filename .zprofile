PROMPT_EOL_MARK=''
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# eval "$(oh-my-posh init zsh --config /opt/homebrew/opt/oh-my-posh/share/oh-my-posh/themes/slimfat.omp.json)"
# eval "$(oh-my-posh init zsh --config /opt/homebrew/opt/oh-my-posh/share/oh-my-posh/themes/clean-detailed.omp.json)"
eval "$(oh-my-posh init zsh --config ~/clean-detailed.omp.json)"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home"
export ANDROID_HOME=$HOME/Library/Android/sdk
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export ANDROID_AVD_HOME=$HOME/.Android/avd
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/cmdline-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"

export PATH="$PATH:$HOME/flutter/bin"
export CHROME_EXECUTABLE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"

export PATH="$PATH":"$HOME/.pub-cache/bin"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

export GOBIN=$(go env GOPATH)/bin
export PATH=$PATH:$GOBIN

# export PATH=$PATH:$HOME/.local/share/bob/nvim-bin
export PATH=$PATH:/opt/homebrew/bin/nvim

alias nvim-kick="NVIM_APPNAME=kickstart nvim"

function nvims() {
  items=("default" "kickstart")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

bindkey -s ^a "nvims\n"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/adrianvincentaguilar/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/adrianvincentaguilar/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/adrianvincentaguilar/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/adrianvincentaguilar/google-cloud-sdk/completion.zsh.inc'; fi

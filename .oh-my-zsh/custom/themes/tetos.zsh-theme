# vim:ft=zsh ts=2 sw=2 sts=2

# TetOS theme
# heavily modified agnoster's theme, stripped basically everything
# agnoster's Theme - https://gist.github.com/3712874

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
CURRENT_FG=${CURRENT_FG:-'black'}
CURRENT_DEFAULT_FG=${CURRENT_DEFAULT_FG:-'default'}


### Theme Configuration Initialization

# Current working directory
: ${DIR_FG:=#f3f7f0}
: ${DIR_BG:=#19323c}

# user@host
: ${CONTEXT_FG:=#f3f7f0}
: ${CONTEXT_BG:=#f2545b}

# Status symbols
: ${STATUS_RETVAL_FG:=red}
: ${STATUS_ROOT_FG:=yellow}
: ${STATUS_JOB_FG:=cyan}
: ${STATUS_FG:=#f3f7f0}
: ${STATUS_BG:=#8c5e58}

## Non-Color settings - set to 'true' to enable
# Show the actual numeric return value rather than a cross symbol.
: ${STATUS_RETVAL_NUMERIC:=false}


# Special Powerline characters

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  # NOTE: This segment separator character is correct.  In 2012, Powerline changed
  # the code points they use for their special characters. This is the new code point.
  # If this is not working for you, you probably have an old version of the
  # Powerline-patched fonts installed. Download and install the new version.
  # Do not submit PRs to change this unless you have reviewed the Powerline code point
  # history and have new information.
  # This is defined using a Unicode escape sequence so it is unambiguously readable, regardless of
  # what font the user is viewing this source code in. Do not replace the
  # escape sequence with a single literal character.
  # Do not change this! Do not make it '\u2b80'; that is the old, wrong code point.
  SEGMENT_SEPARATOR=$'\ue0b0'
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  if [[ "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment "$CONTEXT_BG" "$CONTEXT_FG" "%(!.%{%F{$STATUS_ROOT_FG}%}.)%n%F{#FFAAAA}@%f%m"
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment "$DIR_BG" "$DIR_FG" '%~'
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local -a symbols

  if [[ $STATUS_RETVAL_NUMERIC == 'true' ]]; then
    [[ $RETVAL -ne 0 ]] && symbols+="%{%F{$STATUS_RETVAL_FG}%}$RETVAL"
  else
    [[ $RETVAL -ne 0 ]] && symbols+="%{%F{$STATUS_RETVAL_FG}%}✘"
  fi
  [[ $UID -eq 0 ]] && symbols+="%{%F{$STATUS_ROOT_FG}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{$STATUS_JOB_FG}%}⚙"
  if [[ -z "$symbols" ]]; then
    symbols+=" "
  fi

  prompt_segment "$STATUS_BG" "$STATUS_FG" "$symbols"
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_context
  prompt_dir
  prompt_end
}

PROMPT='$(build_prompt) '

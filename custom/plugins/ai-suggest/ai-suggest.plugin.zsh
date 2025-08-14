# =========================
# Ollama AI Shell Helpers
# =========================

# Config (override per session if you like)
export OLLAMA_HOST="${OLLAMA_HOST:-http://127.0.0.1:11434}"
export OLLAMA_MODEL="${OLLAMA_MODEL:-gpt-oss}"
export OLLAMA_SYSTEM_PROMPT="${OLLAMA_SYSTEM_PROMPT:-You are a command-line assistant. Output only the next shell command. No explanations.}"

# Requirements check
_ai_require() {
  for bin in curl jq; do
    command -v "$bin" >/dev/null 2>&1 || { echo "Missing $bin"; return 1; }
  done
  return 0
}

# Set the active model at runtime: ai-model <name>
ai-model() {
  if [[ -z "$1" ]]; then
    echo "Usage: ai-model <model>"
    echo "Current: $OLLAMA_MODEL"
    return 1
  fi
  export OLLAMA_MODEL="$1"
  echo "AI model set to: $OLLAMA_MODEL"
}

# Optional: set or show host quickly
ai-host() {
  if [[ -z "$1" ]]; then
    echo "Current OLLAMA_HOST: $OLLAMA_HOST"
    return 0
  fi
  export OLLAMA_HOST="$1"
  echo "OLLAMA_HOST set to: $OLLAMA_HOST"
}

# Completion for ai-model from `ollama list`
_ai_model_complete() {
  local -a models
  models=(${(f)"$(ollama list 2>/dev/null | awk 'NR>1 {print $1}')"})
  compadd -- $models
}
compdef _ai_model_complete ai-model

# Internal: build payload with a given temperature
_ai_build_payload() {
  local prompt="$1"
  local temperature="$2"  # request-only
  jq -n \
    --arg model "$OLLAMA_MODEL" \
    --arg sys "$OLLAMA_SYSTEM_PROMPT" \
    --arg user "$prompt" \
    --argjson temp "$temperature" \
    '{
      model: $model,
      prompt: ($sys + "\n\nUser: " + $user),
      options: { temperature: $temp },
      stream: false
    }'
}

# Suggest the next command (low temp for deterministic completion)
_ai_suggest_impl() {
  _ai_require || return
  local prompt="$BUFFER"
  local payload resp suggestion

  payload=$(_ai_build_payload "$prompt" "0.2") || return
  resp=$(curl -sS "$OLLAMA_HOST/api/generate" -d "$payload") || return
  suggestion=$(printf "%s" "$resp" | jq -r '.response' | tr -d '\r')

  if [[ "$suggestion" == "$prompt"* ]]; then
    local delta="${suggestion#$prompt}"
    if [[ -n "$delta" ]]; then
      LBUFFER+="$delta"
    else
      BUFFER="$suggestion"
    fi
  else
    BUFFER="$suggestion"
  fi
  CURSOR=$#BUFFER
}

# Optional: a more exploratory suggestion (higher temp)
_ai_suggest_creative_impl() {
  _ai_require || return
  local prompt="$BUFFER"
  local payload resp suggestion

  payload=$(_ai_build_payload "$prompt" "0.8") || return
  resp=$(curl -sS "$OLLAMA_HOST/api/generate" -d "$payload") || return
  suggestion=$(printf "%s" "$resp" | jq -r '.response' | tr -d '\r')

  BUFFER="$suggestion"
  CURSOR=$#BUFFER
}

# Explain the current command in one short line
_ai_explain_impl() {
  _ai_require || return
  local prompt="$BUFFER" payload resp
  payload=$(jq -n \
    --arg model "$OLLAMA_MODEL" \
    --arg sys "Explain in one short sentence what this command does." \
    --arg user "$prompt" \
    '{model:$model,prompt:($sys + "\n\nCommand: " + $user),stream:false}') || return
  resp=$(curl -sS "$OLLAMA_HOST/api/generate" -d "$payload") || return
  printf "\n# %s\n" "$(printf "%s" "$resp" | jq -r '.response' | tr -d '\r')"
  zle reset-prompt
}

# ZLE widgets and keybindings
zle -N ai-suggest _ai_suggest_impl
zle -N ai-suggest-creative _ai_suggest_creative_impl
zle -N ai-explain _ai_explain_impl

# Keys:
#   Ctrl+G            deterministic completion (temp 0.2)
#   Ctrl+Shift+G      creative completion (temp 0.8)  [may vary by terminal]
#   Ctrl+E            print a one-line explanation
bindkey '^g' ai-suggest
bindkey '^[G' ai-suggest-creative
bindkey '^e' ai-explain

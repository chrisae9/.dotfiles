if [[ -n $commands[aws-vault] ]]; then
  alias av='aws-vault'
else
    return 1
fi


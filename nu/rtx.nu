export-env {
  $env.RTX_SHELL = "nu"
  
  $env.config = ($env.config | upsert hooks {
      pre_prompt: ($env.config.hooks.pre_prompt ++
      [{
      condition: {|| "RTX_SHELL" in $env }
      code: {|| rtx_hook }
      }])
      env_change: {
          PWD: ($env.config.hooks.env_change.PWD ++
          [{
          condition: {|| "RTX_SHELL" in $env }
          code: {|| rtx_hook }
          }])
      }
  })
}
  
def "parse vars" [] {
  $in | lines | parse "{op},{name},{value}"
}
  
def --wrapped mise [command?: string, --help, ...rest: string] {
  let commands = ["shell", "deactivate"]
  
  if ($command == null) {
    ^"~/.cargo/bin/mise"
  } else if ($command == "activate") {
    $env.RTX_SHELL = "nu"
  } else if ($command in $commands) {
    ^"~/.cargo/bin/mise" $command ...$rest
    | parse vars
    | update-env
  } else {
    ^"~/.cargo/bin/mise" $command ...$rest
  }
}
  
def --env "update-env" [] {
  for $var in $in {
    if $var.op == "set" {
      load-env {($var.name): $var.value}
    } else if $var.op == "hide" {
      hide-env $var.name
    }
  }
}
  
def --env rtx_hook [] {
  ^"~/.cargo/bin/mise" hook-env -s nu
    | parse vars
    | update-env
}


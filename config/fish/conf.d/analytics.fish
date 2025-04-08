# Shameful this needs to be set.
#
# The queestion should be:
#   "Would anyone intentionally enable tracking?"

set --universal --export DO_NOT_TRACK 1
set --universal --export NO_TELEMETRY 1
set --universal --export ANALYTICS_OPT_OUT 1
set --universal --export TELEMETRY_DISABLED 1
set --universal --export DISABLE_ANALYTICS 1

# These is more specific shaming
set --universal --export VLLM_NO_USAGE_STATS 1
set --universal --export VLLM_DO_NOT_TRACK 1
set --universal --export VLLM_USAGE_SOURCE development

set --universal --export DOTNET_CLI_TELEMETRY_OPTOUT 1
set --universal --export GATSBY_TELEMETRY_DISABLED 1
set --universal --export NEXT_TELEMETRY_DISABLED 1
set --universal --export STRIPE_CLI_TELEMETRY_OPTOUT 1
set --universal --export PLAYWRIGHT_SKIP_BROWSER_USAGE_STATS 1
set --universal --export SAM_CLI_TELEMETRY 0
set --universal --export AZURE_CORE_COLLECT_TELEMETRY 0
set --universal --export HYPOTHESIS_PROFILE no_telemetry
set --universal --export STNOUPGRADE 1 
set --universal --export POWERSHELL_TELEMETRY_OPTOUT 1
set --universal --export VCPKG_DISABLE_METRICS 1
set --universal --export CARGO_REGISTRY_TOKEN ""
set --universal --export HOMEBREW_NO_ANALYTICS 1
set --universal --export ELECTRON_NO_ATTACH_CONSOLE 1
set --universal --export HF_HUB_DISABLE_TELEMETRY 1
set --universal --export TRACELOOP_TELEMETRY FALSE

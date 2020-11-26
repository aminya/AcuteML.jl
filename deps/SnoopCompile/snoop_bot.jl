using CompileBot

botconfig = BotConfig(
  "AcuteML";
  yml_path = "SnoopCompile.yml"        # parse `os` and `version` from `SnoopCompile.yml`
)

snoop_bot(
  botconfig,
  "$(@__DIR__)/example_script.jl",
)

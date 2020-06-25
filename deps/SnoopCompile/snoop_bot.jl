using SnoopCompileBot

botconfig = BotConfig(
  "AcuteML",
  yml_path="SnoopCompile.jl"
)

snoop_bot(
  botconfig,
  "$(@__DIR__)/example_script.jl",
)

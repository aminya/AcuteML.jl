using SnoopCompile

botconfig = BotConfig(
  "AcuteML",
  yml_path="SnoopCompile.yml"
)

snoop_bot(
  botconfig,
  "$(@__DIR__)/example_script.jl",
)

using CompileBot

botconfig = BotConfig(
  "AcuteML";
  yml_path = "SnoopCompile.yml"        # parse `os` and `version` from `SnoopCompile.yml`
)

println("Benchmarking the inference time of `using AcuteML`")
snoop_bench(
  botconfig,
  :(using AcuteML),
)


println("Benchmarking the inference time of `using AcuteML` and runtests")
snoop_bench(
  botconfig,
  "$(@__DIR__)/example_script.jl",
)

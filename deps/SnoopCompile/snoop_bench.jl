using SnoopCompile

botconfig = BotConfig(
  "AcuteML";
  os = ["linux", "windows", "macos"],
  version = [v"1.4.2", v"1.3.1"],
  blacklist = [],
  exhaustive = false,
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

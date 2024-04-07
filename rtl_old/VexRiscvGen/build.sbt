ThisBuild / scalaVersion := "2.11.12"

val spinalVersion = "1.10.1"

libraryDependencies ++= Seq(
  "com.github.spinalhdl" %% "vexriscv" % "2.0.0",
  "com.github.spinalhdl" % "spinalhdl-core_2.11" % spinalVersion,
  "com.github.spinalhdl" % "spinalhdl-lib_2.11" % spinalVersion,
  compilerPlugin("com.github.spinalhdl" % "spinalhdl-idsl-plugin_2.11" % spinalVersion),
)


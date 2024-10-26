ThisBuild / scalaVersion := "2.12.18"
ThisBuild / libraryDependencySchemes += "org.scala-lang.modules" %% "scala-xml" % VersionScheme.Always

//ThisBuild / scalaVersion := "2.11.12"

//val spinalVersion = "1.10.2a"
val spinalVersion = "dev"
val spinalHdlPath = new File("VexiiRiscv/ext/SpinalHDL").getAbsolutePath

lazy val endeavour = project
  .in(file("."))
  .settings(
    scalacOptions += s"-Xplugin:${new File(spinalHdlPath + s"/idslplugin/target/scala-2.12/spinalhdl-idsl-plugin_2.12-$spinalVersion.jar")}",
    scalacOptions += s"-Xplugin-require:idsl-plugin",
    scalacOptions += "-language:reflectiveCalls",
    name := "Endeavour"
    /*libraryDependencies ++= Seq(
      //"com.github.spinalhdl" %% "vexriscv" % "2.0.0",
      "com.github.spinalhdl" % "spinalhdl-core_2.11" % spinalVersion,
      "com.github.spinalhdl" % "spinalhdl-lib_2.11" % spinalVersion,
      compilerPlugin("com.github.spinalhdl" % "spinalhdl-idsl-plugin_2.11" % spinalVersion),
    )*/
    //Compile / unmanagedSourceDirectories += baseDirectory.value / "ext/rvls/bindings/jni",
    //Compile / unmanagedSourceDirectories += baseDirectory.value / "ext/rvls/bindings/spinal"
  )
  .dependsOn(VexiiRiscv /*, spinalHdlCore, spinalHdlLib, spinalHdlIdslPlugin, spinalHdlSim*/)
  //.dependsOn(spinalHdlCore, spinalHdlLib, spinalHdlIdslPlugin)

//lazy val VexiiRiscvGit = ProjectRef(uri("https://github.com/SpinalHDL/VexiiRiscv.git#dev"), "ret")
lazy val VexiiRiscv = ProjectRef(new File("VexiiRiscv"), "ret")
/*lazy val spinalHdlCore = ProjectRef(file(spinalHdlPath), "core")
lazy val spinalHdlLib = ProjectRef(file(spinalHdlPath), "lib")
lazy val spinalHdlIdslPlugin = ProjectRef(file(spinalHdlPath), "idslplugin")
lazy val spinalHdlSim = ProjectRef(file(spinalHdlPath), "sim")*/

//fork := true

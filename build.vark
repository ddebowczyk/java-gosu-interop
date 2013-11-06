uses org.apache.tools.ant.types.FileSet
uses java.lang.System

var version = "0.1"

var apiName = "jginterop-api-${version}"
var providerName = "jginterop-provider-${version}"
var consumerName = "jginterop-consumer-${version}"

var apiDir = "java-api"
var providerDir = "gosu-provider"
var consumerDir = "java-consumer"

var distDir = "dist"
var gosuHome = file("c:\\dev\\gosu-0.10.2")

var mainClassName = "sample.consumer.ServiceConsumer"

///////////////////////////////////////////////////////////////////////////

// create dist directory
Ant.mkdir(
  :dir = file("${distDir}")
)

// setup classpath
var clspath = classpath()
  .withFileset(gosuHome.file("lib").fileset())
  .withFileset(file(distDir).fileset())

///////////////////////////////////////////////////////////////////////////

// Compiling module: api
@Target
function compileApi() {
  javac(
    apiDir
  )
}

// Building module JAR: api
@Target
@Depends("compileApi")
function jarApi() {
  jar(
    "${apiDir}/classes",
    apiName
  )
}

// Building module JAR: provider
@Target
function jarProvider() {
  jar(
    "${providerDir}/src",
    providerName
  )
}

// Compiling module: consumer
@Target
@Depends({"jarApi","jarProvider"})
function compileConsumer() {
  javac(
    consumerDir
  )
}

// Building module JAR: consumer
@Target
@Depends({"compileConsumer"})
function jarConsumer() {
  jar(
    "${consumerDir}/classes",
    consumerName
  )
}

// Building distribution files
@Target
@Depends({"jarConsumer"})
function dist() {
}

// Running sample Java service consumer
@Target
@Depends("dist")
function run() {
  Ant.java (
    :classpath = clspath,
    :classname = mainClassName,
    :fork=true,
    :failonerror=true
  )
}

// Cleaning build directories
@Target
function clean() {
  Ant.delete(
    :dir = file(distDir)
  )
  Ant.delete(
    :dir = file("${apiDir}/classes")
  )
  Ant.delete(
    :dir = file("${consumerDir}/classes")
  )
}

///////////////////////////////////////////////////////////////////////////

function jar(srcDir : String, jarName : String) {
  print("Building JAR from ${srcDir} to ${jarName}")
  
  Ant.jar(
    :destfile = file("${distDir}/${jarName}.jar"),
    :basedir = file(srcDir)
  )
}

function javac(baseDir : String) {
  print("Compiling module ${baseDir} with classpath ${clspath}")

  var srcDir = path(file("${baseDir}/src"))
    
  Ant.mkdir(
    :dir = file("${baseDir}/classes")
  )
  var clsDir = file("${baseDir}/classes")
  
  Ant.javac(
    :srcdir = srcDir,
    :destdir = clsDir,
    :classpath = clspath,
    :includeantruntime = false
  )
}

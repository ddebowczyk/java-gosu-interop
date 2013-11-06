package sample.provider

uses sample.api.ServiceApi

class ServiceProvider implements ServiceApi {
  construct() {
  }

  override function execute() : String {
    return "Hello from Gosu service"
  }
}

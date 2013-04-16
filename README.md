## Blade

A very simple router implementation for the slash language.

### Usage:

First step:

```ruby
<%

use Blade::Router;

class MyApp {
  def init {
    Blade::Router.new;
      .route("/hello/:who", self:hello)
      .exec(Request)
    ;
  }

  def hello(who = 'world) {
    print("hello #{who}");
  }
}
```

Second step: *???*

## Blade

A very simple router implementation for the slash language.

### Usage:

First step:

```ruby
<%
use Blade::Router;

class MyApp {
  def do_the_dew(name = 'world) {
    print("hello #{name}");
  }
}

Blade::Router.new(λ r {
  r.get("/hello/:name").where('name, %r{\w+});
}).exec(Request);
```

Second step: *???*

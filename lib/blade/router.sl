<%

class Blade {
  class BadArgumentError extends Error {}
  class Route {
    def self.reader(vs...) {
      define_method(v, \{ get_instance_variable(v) });
    }

    reader('verb);
    reader('path);
    reader('callable);

    def init(verb, path, callable) {
      [@verb, @path, @callable] = [verb, path, callable];

      # stores filters for path arguments.
      # @example:
      #   r.get("/:id", x).where('foo, %r{\d{,3}});
      @argument_filters = {};
    }

    def where(argument, filter) {
      @argument_filters[argument] ||= [];
      @argument_filters[argument].push(filter);
      self;
    }
  }

  class Router {

    HTTP_GET  = 'GET;
    HTTP_POST = 'POST;

    # @example:
    # Blade::Router.new(\r { r.get("/foo", App:foo_action) });
    def init(lamb) {
      unless lamb.responds_to('call_with_self) {
        throw BadArgumentError.new("Router#init expects a callable");
      }

      @routes = [];
      lamb.call_with_self(self, self);
    }

    def get(path, lamb) {
     route = Route.new(HTTP_GET, path, lamb);
     @routes.push(route);
     route;
    }

    def exec(request) {}
  }
}

Blade::Router.new(\r {
  r.get("/hello/:dude", \{}).where('dude, %r{\w+});
}).exec(Request);

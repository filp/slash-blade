<%

class Blade {
  class BadArgumentError extends Error {}

  class Route {
    ARGUMENT_REGEX = %r{:([\w]+)\+?};

    def self.reader(v) {
      define_method(v, \{ get_instance_variable(v) });
    }

    reader('verb);
    reader('path);
    reader('callable);

    def init(verb, path, callable) {
      [@verb, @path, @callable, @path_re] = [verb, path, callable, nil];

      # stores filters for path arguments.
      # @example:
      #   r.get("/:id", x).where('foo, %r{\d{,3}});
      @argument_filters = {};
    }

    def match(verb, request_path) {
      # verb must match to begin with:
      return false unless verb == @verb;

      @path_re ||= self.get_arguments_regex(@path);
      print(@path_re);
    }

    def where(argument, filter) {
      @argument_filters[argument] ||= [];
      @argument_filters[argument].push(filter);
      self;
    }

    def self.get_arguments_regex(path) {
      ARGUMENT_REGEX.match(path);
    }
  }

  class Router {

    HTTP_GET    = 'GET;
    HTTP_POST   = 'POST;
    HTTP_PUT    = 'PUT;
    HTTP_DELETE = 'DELETE;
    HTTP_PATCH  = 'PATCH;

    # @example:
    # Blade::Router.new(\r { r.get("/foo", App:foo_action) });
    def init(lamb) {
      unless lamb.responds_to('call_with_self) {
        throw BadArgumentError.new("Router#init expects a callable");
      }

      @routes = [];
      lamb.call_with_self(self, self);
    };

    # define the methods for the different http verbs that we accept:
    [HTTP_GET, HTTP_POST, HTTP_PUT, HTTP_DELETE, HTTP_PATCH].each(\verb {
      self.define_method(verb.lower, \(path, lamb) {
        match([verb], path, lamb);
      });
    });

    def match(verbs, path, lamb) {
      route = Route.new(verbs, path, lamb);
      @routes.push(route);
      route;
    }

    def exec(request) {
      verb = Request.method;
      uri  = Request.env['REQUEST_URI];
      for route in @routes {
        route.match(verb, uri);
      }
    }
  }
}

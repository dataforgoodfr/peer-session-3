from http.server import BaseHTTPRequestHandler
from peer_session.db import DB

class UpServer(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/up":
            self.do_up()
            return

        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(b"Hello, world!")

    def do_up(self):
      database = DB()
      try:
          time_ms = database.healthcheck()
          self.send_response(200)
          self.send_header("Content-type", "json")
          self.end_headers()
          self.wfile.write(bytes(f'{{"up": true, "time": "{time_ms}ms"}}', "utf-8"))
      except Exception:
          self.send_response(500)
          self.send_header("Content-type", "json")
          self.end_headers()
          self.wfile.write(bytes('{"up": false, "time": 0}', "utf-8"))

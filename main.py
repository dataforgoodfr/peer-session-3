import os
import logging
from http.server import HTTPServer
from peer_session_3 import upserver

# Set up logger
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

host_name = "0.0.0.0"
server_port = 8081


logger.debug("Got the following environment variables:")
logger.debug(f"DATABASE_HOST: {os.environ.get('DATABASE_HOST')}")
logger.debug(f"DATABASE_PORT: {os.environ.get('DATABASE_PORT')}")
logger.debug(f"POSTGRES_DB: {os.environ.get('POSTGRES_DB')}")
logger.debug(f"POSTGRES_USER: {os.environ.get('POSTGRES_USER')}")
logger.debug(f"POSTGRES_PASSWORD: {os.environ.get('POSTGRES_PASSWORD')}")

if __name__ == "__main__":
    logger.info("Starting the Webserver")
    web_server = HTTPServer((host_name, server_port), upserver.UpServer)
    logger.info(f"Server listening http://{host_name}:{server_port}")
    try:
        web_server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        web_server.server_close()
        print("Server stopped.")

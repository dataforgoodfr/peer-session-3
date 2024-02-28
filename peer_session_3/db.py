import logging
import os
import time
import psycopg2

class DB:
  def __init__(self):
    self.connection = None
    self.configure()
    self.connect()

  def configure(self):
    """Configure the connection to the database."""
    self.database_host = os.environ.get("DATABASE_HOST")
    self.database_port = int(os.environ.get("DATABASE_PORT"))
    self.database_name = os.environ.get("DATABASE_NAME")
    self.database_user = os.environ.get("DATABASE_USER")
    self.database_password = os.environ.get("DATABASE_PASSWORD")

    logging.debug(f"Connecting to host {self.database_host}")
    logging.debug(f"port : {self.database_port}")
    logging.debug(f"database : {self.database_name}")
    logging.debug(f"user : {self.database_user}")

  def connect(self):
    """Connect to the database."""
    try:
      self.connection = psycopg2.connect(
        host=self.database_host,
        port=self.database_port,
        database=self.database_name,
        user=self.database_user,
        password=self.database_password
      )
    except Exception as e:
      logging.error(f"Error connecting to database: {e}")
      raise

  def healthcheck(self) -> float:
    """Make sure the Postgresql database is reachable."""
    start_time = time.perf_counter()
    self.connection.cursor().execute("SELECT 1")
    end_time = time.perf_counter()

    elapsed_time = round((end_time - start_time) * 1000, 3)
    return elapsed_time

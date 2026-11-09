import threading

import pytest
from werkzeug.serving import make_server

from app import create_app


@pytest.fixture
def server_url():
    application = create_app()
    server = make_server("127.0.0.1", 0, application, threaded=True)
    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()
    try:
        yield f"http://127.0.0.1:{server.server_port}"
    finally:
        server.shutdown()

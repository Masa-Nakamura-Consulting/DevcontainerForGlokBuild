"""A ToDo app that swaps only the list with HTMX. State lives in an in-process list."""

from __future__ import annotations

import itertools
import threading
from dataclasses import dataclass

from flask import Flask, render_template, request

_ids = itertools.count(1)
_lock = threading.Lock()


@dataclass
class Todo:
    id: int
    title: str
    done: bool = False


def create_app() -> Flask:
    app = Flask(__name__)
    app.todos: list[Todo] = []

    def render_list():
        return render_template("partials/todo_list.html", todos=app.todos)

    @app.get("/")
    def index():
        return render_template("index.html", todos=app.todos)

    @app.post("/todos")
    def add_todo():
        title = (request.form.get("title") or "").strip()
        with _lock:
            if title:
                app.todos.append(Todo(id=next(_ids), title=title))
        return render_list()

    @app.post("/todos/<int:todo_id>/toggle")
    def toggle_todo(todo_id: int):
        with _lock:
            for todo in app.todos:
                if todo.id == todo_id:
                    todo.done = not todo.done
                    break
        return render_list()

    @app.delete("/todos/<int:todo_id>")
    def delete_todo(todo_id: int):
        with _lock:
            app.todos[:] = [todo for todo in app.todos if todo.id != todo_id]
        return render_list()

    return app


app = create_app()


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=True)

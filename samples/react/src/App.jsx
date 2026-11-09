import { useState } from 'react'

export default function App() {
  const [title, setTitle] = useState('')
  const [todos, setTodos] = useState([])

  function addTodo(event) {
    event.preventDefault()
    const next = title.trim()
    if (!next) return
    setTodos((items) => [
      ...items,
      { id: crypto.randomUUID(), title: next, done: false },
    ])
    setTitle('')
  }

  function toggleTodo(id) {
    setTodos((items) =>
      items.map((item) =>
        item.id === id ? { ...item, done: !item.done } : item,
      ),
    )
  }

  function deleteTodo(id) {
    setTodos((items) => items.filter((item) => item.id !== id))
  }

  return (
    <main>
      <h1>ToDo</h1>
      <form className="add" onSubmit={addTodo}>
        <input
          name="title"
          required
          maxLength={200}
          placeholder="What needs doing?"
          aria-label="Task"
          value={title}
          onChange={(event) => setTitle(event.target.value)}
        />
        <button type="submit">Add</button>
      </form>
      <ul id="todo-list">
        {todos.length === 0 ? (
          <li className="empty">Nothing here yet</li>
        ) : (
          todos.map((todo) => (
            <li key={todo.id} className={todo.done ? 'done' : undefined}>
              <button
                type="button"
                className="title"
                onClick={() => toggleTodo(todo.id)}
              >
                {todo.title}
              </button>
              <button type="button" onClick={() => deleteTodo(todo.id)}>
                Delete
              </button>
            </li>
          ))
        )}
      </ul>
    </main>
  )
}

import { useEffect, useState } from 'react'
import { supabase } from './lib/supabase'

function App() {
  const [todos, setTodos] = useState(null)
  const [error, setError] = useState(null)

  useEffect(() => {
    supabase
      .from('todos')
      .select()
      .then(({ data, error }) => {
        if (error) setError(error.message)
        else setTodos(data)
      })
  }, [])

  return (
    <div style={{ fontFamily: 'system-ui', padding: '2rem' }}>
      <h1>React + Supabase Starter</h1>
      <p>Le projet fonctionne correctement.</p>

      <h2>Todos</h2>
      {error && <p style={{ color: 'crimson' }}>Error: {error}</p>}
      {!error && todos === null && <p>Loading…</p>}
      {!error && todos && todos.length === 0 && <p>No todos yet.</p>}
      {!error && todos && todos.length > 0 && (
        <ul>
          {todos.map((todo) => (
            <li key={todo.id}>{todo.name}</li>
          ))}
        </ul>
      )}
    </div>
  )
}

export default App

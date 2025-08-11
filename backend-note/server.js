const express = require("express");
const app = express();
const port = 3000;

// Middleware to parse JSON
app.use(express.json());

// In-memory notes storage
let notes = [];
let idCounter = 1;

/**
 * CREATE a new note
 * POST /notes
 * Body: { title: string, content: string }
 */
app.post("/notes", (req, res) => {
  const { title, content } = req.body;
  if (!title || !content) {
    return res.status(400).json({ error: "Title and content are required" });
  }
  const newNote = { id: idCounter++, title, content, createdAt: new Date() };
  notes.push(newNote);
  res.status(201).json(newNote);
});

/**
 * READ all notes
 * GET /notes
 */
app.get("/notes", (req, res) => {
  res.json(notes);
});

/**
 * READ a single note by ID
 * GET /notes/:id
 */
app.get("/notes/:id", (req, res) => {
  const note = notes.find(n => n.id === parseInt(req.params.id));
  if (!note) return res.status(404).json({ error: "Note not found" });
  res.json(note);
});

/**
 * UPDATE a note by ID
 * PUT /notes/:id
 */
app.put("/notes/:id", (req, res) => {
  const note = notes.find(n => n.id === parseInt(req.params.id));
  if (!note) return res.status(404).json({ error: "Note not found" });

  const { title, content } = req.body;
  if (title) note.title = title;
  if (content) note.content = content;
  note.updatedAt = new Date();

  res.json(note);
});

/**
 * DELETE a note by ID
 * DELETE /notes/:id
 */
app.delete("/notes/:id", (req, res) => {
  const index = notes.findIndex(n => n.id === parseInt(req.params.id));
  if (index === -1) return res.status(404).json({ error: "Note not found" });

  const deletedNote = notes.splice(index, 1);
  res.json(deletedNote[0]);
});

// healthz route
app.get('/notes/healthz', (req, res) => {
  res.status(200).json({ status: 'ok' });
});

// Start the server
app.listen(port, "0.0.0.0", () => {
  console.log(`Note-taking API running at http://0.0.0.0:${port}`);
});

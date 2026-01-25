# Quickstart Guide

Welcome! This guide shows you how to create characters, scenes, and generate images using simple commands.

---

## Creating Your First Character

Use the `/copilot.create` command to create a character:

```text
/copilot.create a character named max, a friendly golden retriever
```

**What happens**:

1. A workspace file opens for you to review and customize
2. Edit the file, save it, then reply `continue`
3. Your character is created in `content/entities/characters/max.md`

**Character created!** Now you can use max in scenes.

---

## Creating a Scene

Create a scene that uses your character:

```text
/copilot.create a scene with max running in the park at sunrise
```

**What happens**:

1. Workspace file opens showing the scene details
2. Edit if needed, save, reply `continue`
3. Scene created in `content/entities/scenes/max-golden-morning.md`

**Scene ready!** Now you can generate images from it.

---

## Generating Images

Generate an image from your scene:

```text
/copilot.create an image from the max-golden-morning scene
```

**What happens**:

1. Agent reads your scene and referenced characters
2. Constructs a detailed image prompt
3. Generates image: `content/images/max-golden-morning-260125-143022-01.png`

**Image generated!** Find it in `content/images/`.

### Generate Multiple Variations

Want different versions?

```text
/copilot.create 3 more variations of the max-golden-morning scene
```

Creates: `...-02.png`, `...-03.png`, `...-04.png`

---

## Complete Example Workflow

Let's create a full example from scratch:

### 1. Create Character

```text
/copilot.create a character named luna, a wise old cat with silver fur
```

Result: `content/entities/characters/luna.md`

### 2. Create Scene

```text
/copilot.create a scene with luna sitting on a windowsill watching the rain
```

Result: `content/entities/scenes/luna-rainy-window.md`

### 3. Generate Image

```text
/copilot.create an image from the luna-rainy-window scene
```

Result: `content/images/luna-rainy-window-260125-143230-01.png`

### 4. Generate Variations

```text
/copilot.create 3 more variations of the luna-rainy-window scene
```

Result: 3 more images with variation numbers 02, 03, 04

---

## Finding Your Generated Images

**Browse images**:

1. Open VS Code Explorer
2. Navigate to `content/images/`
3. Click any `.png` file to preview

**Search for specific scene**:

```bash
ls -1 content/images/*luna-rainy-window*.png
```

---

## Tips

### Naming Your Entities

- Use lowercase with hyphens: `golden-retriever`, `sunset-park`
- Be descriptive: `brave-hero`, `ancient-library`
- Keep it simple: `max`, `luna`, `forest-scene`

### Creating Better Scenes

- Describe the mood: "peaceful", "dramatic", "mysterious"
- Include setting details: "at sunset", "in the rain", "underwater"
- Reference your characters by name

### Working with Images

- Images are saved to `content/images/`
- Each image gets a unique timestamp and variation number
- DVC tracks images (you don't commit the actual PNG files)

---

## Troubleshooting

**Image didn't generate?**

Check the operation log:

```bash
ls -1t logs/*.log | head -1 | xargs cat
```

**Can't find an image?**

Search by scene name:

```bash
find content/images -name "*<scene-name>*.png"
```

**Want to regenerate?**

Just run the create command again - new variation number will be used.

---

## What's Created

When you use `/copilot.create`, files are organized like this:

```
content/entities/characters/     # Your characters
content/entities/scenes/          # Your scenes
content/images/                   # Generated images
logs/                             # Operation logs
```

Each image also gets:

- `.dvc` file - for version control
- `-metadata.yaml` file - generation details

---

## Next Steps

Now that you know the basics:

1. **Create more characters** with different species and personalities
2. **Create scenes** combining multiple characters
3. **Generate images** and compare variations
4. **Experiment** with different moods and settings

Have fun creating!

# SAT Vocabulary Image Generation Guide

## Overview
This guide contains prompts for generating 372 flashcard images to help remember SAT vocabulary words through visual associations.

## Files Generated

### 1. `image_generation_prompts.txt` (208 KB)
- **Format**: Human-readable text file
- **Purpose**: Easy review of all prompts
- **Structure**: 
  ```
  Word N: [word]
  Filename: [word].jpg
  Prompt: [full prompt text]
  ```

### 2. `image_prompts.csv` (165 KB)
- **Format**: CSV with columns: word, filename, prompt
- **Purpose**: Machine-readable for batch processing
- **Use case**: Import into scripts or batch image generation tools

### 3. `image_prompts_preview.txt`
- **Format**: Preview showing first 3 and last 4 words
- **Purpose**: Quick review of prompt structure

## Prompt Template

Each prompt follows this structure:

```
Generate a cartoon image to help remember the word "[WORD]" related to this sentence: 
"[EXAMPLE_SENTENCE]" -- The image should NOT include the word "[WORD]" or the 
sentence text (as it will be used as a flashcard). The image should be interesting 
and memorable, helping to recall the word in the context of the example sentence. 
Size: 1080x1920.
```

## Key Requirements

### Image Specifications
- **Format**: JPG
- **Size**: 1080x1920 (portrait orientation for mobile flashcards)
- **Style**: Cartoon/illustrative (memorable and engaging)

### Content Guidelines
- ❌ **Do NOT include**: The vocabulary word itself
- ❌ **Do NOT include**: The example sentence text
- ✅ **Do include**: Visual representation of the concept
- ✅ **Do include**: Context from the example sentence
- ✅ **Goal**: Create visual memory trigger for the word

## Example Prompts

### Example 1: "abrupt"
**Sentence**: "On painter William H. Johnson's return to the United States in 1938 after a decade in Europe, his style underwent an abrupt transformation."

**Visual concept**: Show a painter's canvas suddenly changing from one style to another (e.g., from realistic European style to bold American modernist style) - emphasizing the sudden, sharp change.

### Example 2: "abstract"
**Sentence**: "The philosopher's treatise delved into the highly abstract concepts of existential dread and the nature of being..."

**Visual concept**: Show thought bubbles with intangible, conceptual symbols (infinity signs, question marks, ethereal shapes) rather than concrete objects.

### Example 3: "ubiquitous"
**Sentence**: "Smartphones have become ubiquitous in modern society, present in nearly every aspect of daily life."

**Visual concept**: Show the same object appearing everywhere in a scene - in every person's hand, on every surface, filling the entire frame.

## Usage Workflow

### Option A: Manual Generation (Review Each)
1. Open `image_generation_prompts.txt`
2. Copy each prompt
3. Paste into image generation tool (e.g., DALL-E, Midjourney, Stable Diffusion)
4. Save generated image with the specified filename

### Option B: Batch Processing
1. Load `image_prompts.csv` into your script
2. Loop through each row
3. Send prompt to image generation API
4. Save response with corresponding filename

### Option C: Selective Generation
1. Filter `image_prompts.csv` by words you want to generate
2. Process subset of prompts
3. Track completed words

## File Naming Convention

All images follow this pattern:
- Single word: `word.jpg` (e.g., `abrupt.jpg`)
- Multi-word: `word_with_underscores.jpg` (e.g., `accustomed_to.jpg`)
- With slash: `word_with_underscore.jpg` (e.g., `prevail_over.jpg`)

## Statistics

- **Total words**: 372
- **Total prompts**: 372
- **Estimated generation time**: 
  - Manual (1 min/image): ~6.2 hours
  - API batch (10/min): ~37 minutes
- **Storage estimate**: 
  - Per image (~500KB): ~186 MB total
  - Per image (~200KB): ~74 MB total

## Quality Checklist

For each generated image, verify:
- ☐ No text appears in the image (especially not the word itself)
- ☐ Image clearly relates to the example sentence context
- ☐ Visual is memorable and distinctive
- ☐ Size is exactly 1080x1920
- ☐ File saved with correct name (word.jpg)
- ☐ Image quality is clear and sharp

## Next Steps

1. **Review**: Check `image_prompts_preview.txt` to verify prompt quality
2. **Adjust**: Modify prompts if needed for better visual concepts
3. **Generate**: Use your preferred image generation method
4. **Organize**: Create `images/` directory for generated files
5. **Integrate**: Link images to flashcard app/system

## Notes

- Some short example sentences may need more creative interpretation
- Abstract concepts may be harder to visualize - consider metaphorical representations
- Technical/scientific terms may benefit from diagram-style illustrations
- Consider generating multiple variations for difficult words

---

**Last Updated**: December 9, 2025
**Total Words**: 372 SAT vocabulary words with 100% SAT context coverage

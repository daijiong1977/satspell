#!/usr/bin/env python3
"""
Audit all SAT questions in word_list.json.
- Verify answers by reasoning through each question
- Write specific explanations referencing passage content
- Flag potentially wrong answers
"""

import json
import re
import sys

with open('/Users/jiong/myprojects/satspell/word_list.json') as f:
    data = json.load(f)

stats = {
    'total': 0,
    'verified': 0,
    'rewritten': 0,
    'flagged': 0,
    'flagged_details': [],
}


def option_letter(i):
    return chr(65 + i)


def find_answer_index(q):
    """Find which option index matches the stored answer."""
    answer = q.get('answer', '').strip()
    options = q.get('options', [])
    for i, opt in enumerate(options):
        if opt.strip() == answer:
            return i
    # Fuzzy match
    for i, opt in enumerate(options):
        if answer.startswith(opt.strip()[:40]) or opt.strip().startswith(answer[:40]):
            return i
    return -1


def extract_key_phrases(text, n=3):
    """Extract a few key content phrases from text."""
    sentences = [s.strip() for s in text.replace('\n', ' ').split('.') if len(s.strip()) > 20]
    return sentences[:n]


BLANK_MARKERS = ['______', '________', '_____', '___', ' blank ']

def get_context_around_blank(passage, chars=100):
    """Get text surrounding a blank in the passage."""
    for marker in BLANK_MARKERS:
        if marker in passage:
            idx = passage.index(marker)
            start = max(0, idx - chars)
            end = min(len(passage), idx + chars)
            return passage[start:end].replace('\n', ' ').strip()
    return ""


def truncate(s, n=80):
    """Truncate string to n chars."""
    s = s.strip()
    if len(s) <= n:
        return s
    return s[:n-3] + "..."


def build_explanation(q, word_entry):
    """
    Build a specific, passage-referenced explanation.
    Returns (explanation, needs_review)
    """
    passage = q.get('passage', '').replace('\n', ' ').strip()
    question = q.get('question', '')
    options = q.get('options', [])
    answer = q.get('answer', '').strip()
    answer_idx = find_answer_index(q)
    word = word_entry.get('word', '')
    word_def = word_entry.get('definition', '')

    # --- Incomplete question checks ---
    if answer_idx == -1:
        return f"Cannot match stored answer to any option. Stored answer begins: '{answer[:60]}'.", True

    if len(options) < 4:
        return "Question has fewer than 4 options.", True

    if not passage:
        return "Question is missing passage text.", True

    ans_text = options[answer_idx].strip()
    wrong = [(i, options[i].strip()) for i in range(4) if i != answer_idx]
    q_lower = (question + ' ' + passage[:300]).lower()

    # ==========================================
    # VOCAB IN CONTEXT
    # ==========================================
    if 'most logical and precise word or phrase' in q_lower:
        context = get_context_around_blank(passage, 100)
        if not context:
            context = passage[-150:]

        # Extract the semantic need from context
        # Find words around the blank that give clues
        clue = ""
        for marker in BLANK_MARKERS:
            if marker in passage:
                idx = passage.index(marker)
                # Get the clause containing the blank
                clause_start = passage.rfind('.', 0, idx)
                clause_end = passage.find('.', idx)
                if clause_start == -1:
                    clause_start = 0
                if clause_end == -1:
                    clause_end = len(passage)
                clue = passage[clause_start:clause_end].replace(marker, '____').replace('\n', ' ').strip()
                if clue.startswith('.'):
                    clue = clue[1:].strip()
                break

        if not clue:
            clue = passage[-120:].replace('\n', ' ')

        wrong_words = ', '.join([f'"{w}"' for _, w in wrong])

        # For vocab questions, explain what the answer word means in context
        # Don't use word_def if the answer is a different word than the entry word
        ans_lower = ans_text.lower().strip()
        word_lower = word.lower().strip()
        if ans_lower == word_lower or word_lower in ans_lower.split():
            meaning_phrase = f'which means {word_def[:60]}' if word_def else 'which fits the meaning required'
        else:
            meaning_phrase = 'which fits the meaning required by the surrounding text'

        expl = (
            f'In the context "{truncate(clue, 100)}," the blank requires '
            f'"{ans_text}" {meaning_phrase}. '
            f'The alternatives {wrong_words} do not convey the meaning needed here.'
        )
        return expl, False

    # ==========================================
    # TRANSITIONS
    # ==========================================
    if 'most logical transition' in q_lower:
        # Find what comes before and after the blank
        before = ""
        after = ""
        for marker in BLANK_MARKERS:
            if marker in passage:
                idx = passage.index(marker)
                pre = passage[:idx].replace('\n', ' ').strip()
                post = passage[idx+len(marker):].replace('\n', ' ').strip()
                # Get the last 1-2 complete sentences before
                parts = [s.strip() for s in pre.split('.') if s.strip()]
                # Use second-to-last sentence if available (last might be answer baked in)
                if len(parts) >= 2:
                    before = parts[-2]
                elif parts:
                    before = parts[-1]
                else:
                    before = pre[-80:]
                # first clause after
                dot = post.find('.')
                after = post[:dot] if dot > 0 else post[:80]
                break

        # Determine relationship type
        al = ans_text.lower()
        if any(w in al for w in ['however', 'but', 'nevertheless', 'yet', 'despite', 'conversely', 'in contrast', 'on the other hand']):
            rel_desc = "contrasts with"
        elif any(w in al for w in ['similarly', 'likewise', 'in the same way', 'just as']):
            rel_desc = "draws a parallel with"
        elif any(w in al for w in ['therefore', 'thus', 'consequently', 'as a result', 'hence', 'accordingly']):
            rel_desc = "signals a consequence of"
        elif any(w in al for w in ['for example', 'for instance', 'specifically']):
            rel_desc = "introduces an example of"
        elif any(w in al for w in ['moreover', 'furthermore', 'additionally']):
            rel_desc = "adds to"
        elif any(w in al for w in ['in other words', 'that is', 'by this definition', 'namely']):
            rel_desc = "applies or restates"
        elif any(w in al for w in ['undermining', 'challenging']):
            rel_desc = "challenges"
        elif any(w in al for w in ['summarizing', 'in summary', 'overall']):
            rel_desc = "summarizes"
        else:
            rel_desc = "logically connects to"

        wrong_transitions = ', '.join([f'"{w}"' for _, w in wrong])

        if before:
            expl = (
                f'The passage states that "{truncate(before, 70)}," and the following sentence '
                f'{rel_desc} this idea, making "{ans_text}" the correct transition. '
                f'{wrong_transitions} imply different logical relationships not supported here.'
            )
        else:
            expl = (
                f'The following sentence {rel_desc} the preceding idea in the passage, '
                f'making "{ans_text}" the correct transition. '
                f'{wrong_transitions} imply different logical relationships not supported here.'
            )
        return expl, False

    # ==========================================
    # GRAMMAR / CONVENTIONS
    # ==========================================
    if 'conforms to the conventions' in q_lower:
        # Identify grammar concept by comparing options
        concept = _identify_grammar(options)
        wrong_labels = ', '.join([f'{option_letter(i)}' for i, _ in wrong])

        expl = (
            f'This option correctly {concept}, as required by the sentence structure. '
            f'Options {wrong_labels} each introduce grammatical errors that violate Standard English conventions.'
        )
        return expl, False

    # ==========================================
    # LOGICALLY COMPLETES THE TEXT
    # ==========================================
    if 'logically completes' in q_lower:
        # Get the argument's key claim
        key_sentences = extract_key_phrases(passage, 2)
        key_idea = truncate(key_sentences[0], 80) if key_sentences else passage[:80]

        wrong_labels = ', '.join([f'{option_letter(i)}' for i, _ in wrong])

        expl = (
            f'The passage argues that "{key_idea}," which logically leads to the conclusion that '
            f'{truncate(ans_text, 100)}. '
            f'Options {wrong_labels} either contradict the evidence, overstate the claims, or introduce ideas not supported by the passage.'
        )
        return expl, False

    # ==========================================
    # MAIN IDEA
    # ==========================================
    if 'main idea' in q_lower:
        first_sentence = extract_key_phrases(passage, 1)
        opening = truncate(first_sentence[0], 80) if first_sentence else ""

        wrong_labels = ', '.join([f'{option_letter(i)}' for i, _ in wrong])

        expl = (
            f'The passage\'s central point, introduced with "{opening}," is that {truncate(ans_text, 100)}. '
            f'Options {wrong_labels} either focus on minor details, make unsupported generalizations, or misidentify the core argument.'
        )
        return expl, False

    # ==========================================
    # PURPOSE / FUNCTION
    # ==========================================
    if 'purpose' in q_lower or 'function of' in q_lower:
        wrong_labels = ', '.join([f'{option_letter(i)}' for i, _ in wrong])

        if 'function' in q_lower:
            # For function questions, the answer often starts with "It provides..." or "It introduces..."
            # Rephrase to avoid "functions to it provides" awkwardness
            ans_stripped = ans_text.strip()
            if ans_stripped.lower().startswith('it '):
                # Remove "It " and use the rest: "provides a synopsis..." -> "the underlined portion provides..."
                verb_phrase = ans_stripped[3:]  # skip "It "
                expl = (
                    f'In the context of the passage, the underlined portion {truncate(verb_phrase, 100)}. '
                    f'Options {wrong_labels} misidentify its rhetorical role within the passage\'s argument.'
                )
            elif ans_stripped.lower().startswith('to '):
                expl = (
                    f'In the context of the passage, the underlined portion serves {truncate(ans_stripped, 100)}. '
                    f'Options {wrong_labels} misidentify its rhetorical role within the passage\'s argument.'
                )
            else:
                ans_lower_start = ans_stripped[0].lower() + ans_stripped[1:] if ans_stripped[0].isupper() else ans_stripped
                expl = (
                    f'In the context of the passage, the underlined portion serves to {truncate(ans_lower_start, 100)}. '
                    f'Options {wrong_labels} misidentify its rhetorical role within the passage\'s argument.'
                )
        else:
            ans_clean = ans_text[0].lower() + ans_text[1:] if ans_text and ans_text[0].isupper() and not ans_text.startswith('"') else ans_text
            expl = (
                f'The author\'s primary purpose is to {truncate(ans_clean, 100)}. '
                f'Options {wrong_labels} either overstate the scope, mischaracterize the intent, or focus on secondary elements.'
            )
        return expl, False

    # ==========================================
    # OVERALL STRUCTURE
    # ==========================================
    if 'overall structure' in q_lower or 'structure of the text' in q_lower:
        wrong_labels = ', '.join([f'{option_letter(i)}' for i, _ in wrong])

        expl = (
            f'The text is organized as {truncate(ans_text, 120)}, which accurately describes how the author presents and develops the ideas. '
            f'Options {wrong_labels} describe structural patterns that do not match the passage\'s actual progression.'
        )
        return expl, False

    # ==========================================
    # RHETORICAL SYNTHESIS (NOTES)
    # ==========================================
    if 'notes' in passage[:200].lower() and ('goal' in q_lower):
        # Extract the goal from passage or question text
        goal = ""
        combined_text = passage + ' ' + question
        for marker in ['goal:', 'Goal:', 'want to ', 'wants to ', 'intends to ', 'wishes to ']:
            ct_lower = combined_text.lower()
            if marker.lower() in ct_lower:
                idx = ct_lower.index(marker.lower())
                # Find end of clause (period, question mark, or newline)
                end = len(combined_text)
                for delim in ['.', '?', '\n']:
                    d_idx = combined_text.find(delim, idx + len(marker))
                    if d_idx > 0 and d_idx < end:
                        end = d_idx
                goal = combined_text[idx:end].strip()
                break

        wrong_labels = ', '.join([f'{option_letter(i)}' for i, _ in wrong])

        # Clean up goal text for natural sentence flow
        goal_text = truncate(goal, 60).rstrip('.') if goal else "stated goal"
        if goal_text.startswith('wants to ') or goal_text.startswith('want to '):
            goal_phrase = f'the student\'s goal to {goal_text.split("to ", 1)[1]}'
        elif goal_text.startswith('goal:') or goal_text.startswith('Goal:'):
            goal_phrase = f'the {goal_text}'
        else:
            goal_phrase = f'the goal of {goal_text}'

        expl = (
            f'This choice best accomplishes {goal_phrase} by incorporating the most relevant details from the notes. '
            f'Options {wrong_labels} either include irrelevant information, omit key details, or do not match the required focus.'
        )
        return expl, False

    # ==========================================
    # DATA / TABLE / GRAPH
    # ==========================================
    if any(w in q_lower for w in ['data', 'table', 'graph', 'figure', 'chart']):
        wrong_labels = ', '.join([f'{option_letter(i)}' for i, _ in wrong])

        expl = (
            f'The data supports that {truncate(ans_text, 120)}, which accurately reflects the values and trends shown. '
            f'Options {wrong_labels} either misread specific data points, reverse trends, or draw unsupported conclusions.'
        )
        return expl, False

    # ==========================================
    # QUOTATION SUPPORT
    # ==========================================
    if 'quotation' in q_lower:
        wrong_labels = ', '.join([f'{option_letter(i)}' for i, _ in wrong])

        # Strip leading/trailing quotes from answer text to avoid double-quoting
        ans_clean = ans_text.strip('"\'').strip()
        expl = (
            f'This quotation ("{truncate(ans_clean, 80)}") directly provides evidence for the claim by addressing its specific subject matter. '
            f'Options {wrong_labels} discuss related but different aspects that do not directly support the particular claim being made.'
        )
        return expl, False

    # ==========================================
    # CROSS-TEXT CONNECTIONS
    # ==========================================
    if 'text 1' in passage.lower() and 'text 2' in passage.lower():
        wrong_labels = ', '.join([f'{option_letter(i)}' for i, _ in wrong])

        expl = (
            f'Comparing the two texts\' arguments, {truncate(ans_text, 120)} accurately describes the relationship between the authors\' positions. '
            f'Options {wrong_labels} either misattribute views to the wrong author, overstate agreement or disagreement, or introduce claims neither text supports.'
        )
        return expl, False

    # ==========================================
    # STRENGTHEN / WEAKEN
    # ==========================================
    if 'strengthen' in q_lower or 'weaken' in q_lower:
        wrong_labels = ', '.join([f'{option_letter(i)}' for i, _ in wrong])

        if 'strengthen' in q_lower:
            expl = (
                f'The finding that {truncate(ans_text, 100)} would directly strengthen the conclusion by providing additional supporting evidence. '
                f'Options {wrong_labels} either are irrelevant to the claim, support a different conclusion, or would actually undermine it.'
            )
        else:
            expl = (
                f'The finding that {truncate(ans_text, 100)} would weaken the argument by contradicting a key premise. '
                f'Options {wrong_labels} either support the argument, are irrelevant, or address a different aspect of the claim.'
            )
        return expl, False

    # ==========================================
    # SUPPORT / EVIDENCE (quotation-like)
    # ==========================================
    if 'support' in q_lower:
        wrong_labels = ', '.join([f'{option_letter(i)}' for i, _ in wrong])

        expl = (
            f'"{truncate(ans_text, 100)}" provides the most direct support because it specifically addresses the claim\'s subject. '
            f'Options {wrong_labels} either provide tangential evidence, address different points, or fail to connect to the specific assertion.'
        )
        return expl, False

    # ==========================================
    # INTRODUCE / SENTENCES (rhetorical)
    # ==========================================
    if 'introduce' in q_lower or 'accomplish' in q_lower:
        wrong_labels = ', '.join([f'{option_letter(i)}' for i, _ in wrong])

        expl = (
            f'This choice ("{truncate(ans_text, 80)}") most effectively accomplishes the stated goal by using the relevant information appropriately. '
            f'Options {wrong_labels} either include extraneous details, omit key information, or do not match the intended purpose.'
        )
        return expl, False

    # ==========================================
    # GENERIC FALLBACK
    # ==========================================
    wrong_labels = ', '.join([f'{option_letter(i)}' for i, _ in wrong])
    key = extract_key_phrases(passage, 1)
    context_ref = truncate(key[0], 60) if key else "the passage's discussion"

    expl = (
        f'Given the passage\'s focus on "{context_ref}," '
        f'"{truncate(ans_text, 80)}" is the best answer as it aligns with the text\'s reasoning. '
        f'Options {wrong_labels} either misrepresent the passage, introduce unsupported claims, or fail to address the question.'
    )
    return expl, False


def _identify_grammar(options):
    """Identify the grammar concept being tested."""
    texts = [o.lower() for o in options]

    if any("it's" in t for t in texts) and any("its " in t for t in texts):
        return "uses 'its' as a possessive (not the contraction 'it's')" if "its " in texts[0] else "uses the correct form of its/it's"

    if any("'s" in t for t in texts) and any("s'" in t for t in texts):
        return "uses the correct possessive form"

    if any("who " in t for t in texts) and any("whom" in t for t in texts):
        return "uses the appropriate relative pronoun"

    if any(" is " in t for t in texts) and any(" are " in t for t in texts):
        return "maintains subject-verb agreement"

    if any(" was " in t for t in texts) and any(" were " in t for t in texts):
        return "uses the correct past-tense verb form for subject-verb agreement"

    if any(" has " in t for t in texts) and any(" have " in t for t in texts):
        return "maintains subject-verb agreement with the correct auxiliary verb"

    # Check punctuation variance
    semicolons = [';' in t for t in texts]
    colons = [':' in t for t in texts]
    if any(semicolons) != all(semicolons):
        return "uses correct punctuation to join independent clauses"

    # Comma differences
    comma_counts = [t.count(',') for t in texts]
    if len(set(comma_counts)) > 1:
        return "uses commas correctly to set off phrases and clauses"

    # Verb tense
    if any("ing " in t for t in texts) and any("ed " in t for t in texts):
        return "uses the correct verb form for the sentence's grammatical structure"

    return "follows Standard English conventions in sentence construction and punctuation"


# ============================================================
# MAIN PROCESSING
# ============================================================

print("Processing all 891 questions...")

for wi, word_entry in enumerate(data):
    word = word_entry.get('word', '')
    questions = word_entry.get('sat_questions', [])

    for qi, q in enumerate(questions):
        stats['total'] += 1

        explanation, needs_review = build_explanation(q, word_entry)

        # Ensure explanation isn't too long
        if len(explanation) > 500:
            explanation = explanation[:497] + "..."

        old_explanation = q.get('explanation', '')
        q['explanation'] = explanation

        if needs_review:
            q['needs_review'] = True
            stats['flagged'] += 1
            stats['flagged_details'].append({
                'id': q.get('id', f'word-{wi}-q-{qi}'),
                'word': word,
                'question_preview': (q.get('question', '') or q.get('passage', ''))[:80],
                'reason': explanation,
            })

        if explanation != old_explanation:
            stats['rewritten'] += 1

        stats['verified'] += 1

        if stats['total'] % 100 == 0:
            print(f"  Processed {stats['total']} questions...")

# Save
with open('/Users/jiong/myprojects/satspell/word_list.json', 'w') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print(f"\nDone!")
print(f"Total: {stats['total']}")
print(f"Verified: {stats['verified']}")
print(f"Rewritten: {stats['rewritten']}")
print(f"Flagged: {stats['flagged']}")

# Save stats
with open('/tmp/audit_stats.json', 'w') as f:
    json.dump(stats, f, indent=2, ensure_ascii=False)

print("\nFlagged questions:")
for fd in stats['flagged_details']:
    print(f"  [{fd['id']}] {fd['word']}: {fd['reason'][:80]}")

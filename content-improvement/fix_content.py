#!/usr/bin/env python3
"""
Content improvement script for WordScholar vocabulary app.
Handles all phases of fixes.
"""

import json
import re
import copy
import os

os.chdir('/Users/jiong/myprojects/satspell')

# Load data
with open('word_list.json', 'r') as f:
    word_list = json.load(f)

with open('sat_reading_questions_deduplicated.json', 'r') as f:
    sat_questions = json.load(f)

with open('content-improvement/audit-report.json', 'r') as f:
    audit_report = json.load(f)

# Counters
stats = {
    'blanks_filled_sat_questions': 0,
    'blanks_filled_word_list_passages': 0,
    'blanks_filled_word_list_contexts': 0,
    'questions_removed_sat': 0,
    'questions_removed_word_list': 0,
    'fragment_examples_fixed': 0,
    'definitions_updated': 0,
    'contexts_replaced': 0,
    'explanations_added': 0,
    'needs_review_items': [],
}

# ============================================================
# PHASE 1: Critical Automated Fixes
# ============================================================

# --- 1. Fill blanks in questions ---

def fill_blank(passage, answer):
    """Replace ______ or ___ in passage with the answer."""
    if not answer or not passage:
        return passage, False
    # Replace the blank pattern
    new_passage = re.sub(r'_{3,}', answer, passage, count=1)
    changed = new_passage != passage
    return new_passage, changed

# Fix sat_reading_questions_deduplicated.json
for q in sat_questions:
    passage = q.get('passage', '')
    answer = q.get('answer', '')
    if ('______' in passage or '___' in passage) and answer:
        new_passage, changed = fill_blank(passage, answer)
        if changed:
            q['passage'] = new_passage
            stats['blanks_filled_sat_questions'] += 1

# Fix word_list.json - sat_questions passages and sat_context
for word_entry in word_list:
    # Fix sat_questions passages
    for q in word_entry.get('sat_questions', []):
        passage = q.get('passage', '')
        answer = q.get('answer', '')
        if ('______' in passage or '___' in passage) and answer:
            new_passage, changed = fill_blank(passage, answer)
            if changed:
                q['passage'] = new_passage
                stats['blanks_filled_word_list_passages'] += 1

    # Fix sat_context entries
    new_contexts = []
    for ctx in word_entry.get('sat_context', []):
        if '______' in ctx or '___' in ctx:
            # Try to find answer from related questions
            filled = False
            for q in word_entry.get('sat_questions', []):
                answer = q.get('answer', '')
                passage = q.get('passage', '')
                if answer and (ctx[:50] in passage or passage[:50] in ctx):
                    new_ctx, changed = fill_blank(ctx, answer)
                    if changed:
                        new_contexts.append(new_ctx)
                        stats['blanks_filled_word_list_contexts'] += 1
                        filled = True
                        break
            if not filled:
                # Try matching context to any sat question across all data
                matched = False
                for sq in sat_questions:
                    sp = sq.get('passage', '')
                    sa = sq.get('answer', '')
                    if sa and ctx[:40] in sp:
                        new_ctx, changed = fill_blank(ctx, sa)
                        if changed:
                            new_contexts.append(new_ctx)
                            stats['blanks_filled_word_list_contexts'] += 1
                            matched = True
                            break
                if not matched:
                    # Can't fill this one, keep as is
                    new_contexts.append(ctx)
        else:
            new_contexts.append(ctx)
    word_entry['sat_context'] = new_contexts


# --- 2. Remove unanswerable questions ---

# Remove from sat_reading_questions
original_count = len(sat_questions)
sat_questions = [q for q in sat_questions if q.get('answer')]
stats['questions_removed_sat'] = original_count - len(sat_questions)

# Remove from word_list embedded questions
for word_entry in word_list:
    if 'sat_questions' in word_entry:
        original = len(word_entry['sat_questions'])
        word_entry['sat_questions'] = [q for q in word_entry['sat_questions'] if q.get('answer')]
        stats['questions_removed_word_list'] += original - len(word_entry['sat_questions'])


# --- 3. Fix fragment examples ---

fragment_fixes = {
    'criterion': "The primary criterion for admission to the honors program is a cumulative GPA of 3.5 or higher.",
    'pollinate': "Bees pollinate flowers by transferring pollen from one blossom to another as they collect nectar.",
    'repository': "The university library serves as a repository of rare manuscripts and historical documents dating back to the fifteenth century.",
    'simulated': "The researchers tested the rover's wheels on a simulated Martian terrain to ensure they could handle the rocky landscape.",
    'subtlety': "The subtlety of the artist's brushwork is easy to miss at first glance, but closer inspection reveals delicate gradations of color.",
    'sweep': "The reform movement quickly swept across the country, inspiring protests in dozens of cities.",
    'utilize': "The architect chose to utilize recycled materials in the building's construction, reducing both cost and environmental impact.",
}

for word_entry in word_list:
    w = word_entry['word']
    if w in fragment_fixes:
        word_entry['example'] = fragment_fixes[w]
        stats['fragment_examples_fixed'] += 1


# ============================================================
# PHASE 2: Quality Improvements
# ============================================================

# --- 4. Fix definition/example mismatches ---

for word_entry in word_list:
    if word_entry['word'] == 'abrupt':
        word_entry['definition'] = "sudden and unexpected; also, speaking or acting in a way that seems unfriendly and rude"
        stats['definitions_updated'] += 1
    elif word_entry['word'] == 'sweep':
        word_entry['definition'] = "to move quickly and/or with force; to spread rapidly across a wide area"
        stats['definitions_updated'] += 1


# --- 5. Fix usage contexts where word is missing ---

# Build lookup for word entries
word_lookup = {w['word']: w for w in word_list}

# Get the list of bad contexts from audit report
missing_contexts = audit_report.get('word_missing_from_context', [])

# Group by word
from collections import defaultdict
missing_by_word = defaultdict(list)
for item in missing_contexts:
    missing_by_word[item['word']].append(item['context'])

# Generate replacement contexts for each word
replacement_contexts = {
    'accentuate': [
        "In her speech, the professor used vivid anecdotes to accentuate the importance of environmental conservation, ensuring the audience grasped the urgency of the issue.",
        "The photographer adjusted the lighting to accentuate the sharp angles of the building, creating a dramatic contrast between shadow and stone.",
    ],
    'accustomed to': [
        "Having grown accustomed to the quiet rhythms of rural life, the young writer found the constant noise of the city overwhelming at first.",
        "The diplomat, accustomed to navigating tense negotiations, remained calm even when talks broke down unexpectedly.",
    ],
    'affinity': [
        "The biologist discovered a natural affinity between the two plant species, noting that they thrived when grown in close proximity.",
        "From an early age, she displayed an affinity for mathematics, solving complex problems with an ease that surprised her teachers.",
        "The architect's affinity for minimalist design was evident in every project, from private homes to public libraries.",
    ],
    'alignment': [
        "The new policy was designed to bring the company's practices into alignment with current environmental regulations.",
        "Researchers found that the alignment of the ancient temple's entrance with the winter solstice sunrise was no accident but a deliberate astronomical calculation.",
        "The candidate's views were in close alignment with those of the majority of voters, which helped explain her strong poll numbers.",
    ],
    'ameliorate': [
        "The city council introduced a series of measures to ameliorate the effects of flooding in low-lying neighborhoods, including improved drainage systems and elevated walkways.",
    ],
    'amorphous': [
        "The novelist's latest work defies easy classification; its amorphous structure blends memoir, fiction, and essay in ways that challenge conventional genre boundaries.",
    ],
    'assertion': [
        "The historian's assertion that the treaty was signed under duress was supported by newly discovered letters from the negotiators.",
        "Critics challenged the researcher's assertion, arguing that the data could be interpreted in several different ways.",
    ],
    'circumscribe': [
        "The new zoning laws effectively circumscribe the areas where commercial development is permitted, limiting builders to a narrow corridor along the highway.",
    ],
    'commensurate': [
        "The manager argued that employees' salaries should be commensurate with their experience and the complexity of their responsibilities.",
    ],
    'compelling': [
        "The documentary presented such compelling evidence of the glacier's retreat that even skeptics acknowledged the reality of climate change in the region.",
    ],
    'comprehensive': [
        "The committee released a comprehensive report on public school funding, covering everything from teacher salaries to infrastructure maintenance across all fifty states.",
    ],
    'conceive': [
        "It is difficult to conceive of a world without the internet, yet just a few decades ago, most people had never heard of it.",
    ],
    'concrete': [
        "The professor urged students to support their arguments with concrete examples rather than vague generalizations.",
    ],
    'consensus': [
        "After weeks of debate, the committee finally reached a consensus on the budget proposal, agreeing to allocate additional funds for public transportation.",
    ],
    'consolidate': [
        "The company decided to consolidate its three regional offices into a single headquarters, aiming to reduce overhead costs and improve communication among departments.",
    ],
    'contend': [
        "Several scholars contend that the novel was influenced by the author's childhood experiences in rural Mississippi, though others dispute this reading.",
    ],
    'convey': [
        "Through her use of stark imagery and spare language, the poet manages to convey a profound sense of loss without ever directly naming what has been lost.",
    ],
    'cultivate': [
        "The mentorship program was designed to cultivate leadership skills in young professionals, pairing them with experienced executives for year-long apprenticeships.",
    ],
    'dearth': [
        "The dearth of affordable housing in the city has forced many families to commute long distances from outlying suburbs.",
    ],
    'deference': [
        "Out of deference to the elder members of the council, the young senator waited until they had all spoken before offering her own perspective on the legislation.",
    ],
    'delineate': [
        "The treaty carefully delineates the boundary between the two nations, specifying landmarks and coordinates along the entire border.",
    ],
    'devise': [
        "The engineering team had to devise a new cooling system after the original design proved unable to handle the extreme desert temperatures.",
    ],
    'discern': [
        "With practice, wine enthusiasts can discern subtle differences in flavor between vintages that most casual drinkers would never notice.",
    ],
    'discourse': [
        "The academic discourse surrounding artificial intelligence has shifted dramatically in recent years, moving from theoretical speculation to urgent ethical debate.",
    ],
    'disparity': [
        "The study revealed a significant disparity in health outcomes between wealthier neighborhoods and lower-income communities, even within the same city.",
    ],
    'disposition': [
        "Her cheerful disposition made her a favorite among patients at the clinic; even on the busiest days, she greeted everyone with genuine warmth.",
    ],
    'distinction': [
        "The professor drew a clear distinction between correlation and causation, warning students not to confuse the two in their research papers.",
    ],
    'diverse': [
        "The coral reef supports a remarkably diverse ecosystem, harboring hundreds of species of fish, invertebrates, and marine plants within a single square kilometer.",
    ],
    'domain': [
        "While the question of planetary motion was once considered the domain of philosophers, it is now firmly within the province of astrophysicists.",
    ],
    'domestic': [
        "The rise in domestic manufacturing has been attributed to new trade policies that make importing goods more expensive.",
    ],
    'elaborate': [
        "The architect presented an elaborate plan for the new museum, complete with rooftop gardens, underground galleries, and a glass-walled atrium.",
    ],
    'elicit': [
        "The comedian's deadpan delivery never failed to elicit laughter from even the most reserved members of the audience.",
    ],
    'eloquent': [
        "The senator's eloquent defense of civil liberties moved many listeners to tears and was widely reprinted in newspapers across the country.",
    ],
    'empirical': [
        "The researchers insisted on empirical evidence to support every claim, conducting dozens of controlled experiments before publishing their findings.",
    ],
    'encompass': [
        "The new curriculum is designed to encompass a wide range of subjects, from traditional literature to digital media production.",
    ],
    'endure': [
        "Despite centuries of war and natural disaster, the ancient city's walls have endured, standing as a testament to the skill of their original builders.",
    ],
    'enhance': [
        "The software update was designed to enhance the user experience by reducing load times and adding intuitive navigation features.",
    ],
    'entail': [
        "The restoration of the historic courthouse will entail months of careful work, including the replacement of damaged stonework and the repair of original stained-glass windows.",
    ],
    'evoke': [
        "The painter's use of muted blues and grays was intended to evoke the melancholy atmosphere of a coastal town in winter.",
    ],
    'exert': [
        "Tidal forces exerted by the moon play a significant role in shaping coastal ecosystems, influencing everything from sediment distribution to the behavior of marine organisms.",
    ],
    'explicit': [
        "The contract includes explicit instructions regarding the timeline for deliverables, leaving no room for ambiguity about when each phase must be completed.",
    ],
    'facilitate': [
        "The new bridge was built to facilitate trade between the two regions, reducing travel time from several hours to just thirty minutes.",
    ],
    'fidelity': [
        "The translator's fidelity to the original text was remarkable; every nuance of the author's prose was preserved in the English version.",
    ],
    'fluctuate': [
        "Stock prices tend to fluctuate more dramatically during periods of political uncertainty, as investors react to each new development.",
    ],
    'hierarchy': [
        "In the corporate hierarchy, decisions about long-term strategy are made at the executive level, while day-to-day operations are managed by department heads.",
    ],
    'hypothetical': [
        "The professor posed a hypothetical scenario in which all fossil fuels disappeared overnight, asking students to consider the immediate social and economic consequences.",
    ],
    'illuminate': [
        "The newly discovered letters illuminate aspects of the author's personal life that biographers had previously been forced to guess at.",
    ],
    'impede': [
        "Heavy bureaucratic requirements can impede scientific research by forcing investigators to spend more time on paperwork than on actual experiments.",
    ],
    'implication': [
        "The study's implications for public health policy are significant: if confirmed, the findings could lead to new guidelines on dietary sugar consumption.",
    ],
    'inclined': [
        "Younger voters are inclined to support candidates who prioritize climate policy, according to several recent surveys.",
    ],
    'indigenous': [
        "The museum's new exhibit highlights indigenous art traditions that have been practiced continuously for thousands of years.",
    ],
    'inherent': [
        "There is an inherent tension in democratic governance between the will of the majority and the rights of the individual.",
    ],
    'innovation': [
        "The company's latest innovation in battery technology could extend the range of electric vehicles by nearly fifty percent.",
    ],
    'intangible': [
        "While the economic benefits of the project were easy to quantify, the intangible gains in community morale and civic pride proved equally important.",
    ],
    'integrity': [
        "The journalist's commitment to integrity meant she would never publish a story without verifying every claim through at least two independent sources.",
    ],
    'invoke': [
        "The defense attorney chose to invoke a rarely used precedent from the nineteenth century, arguing that it was directly applicable to the current case.",
    ],
    'irreversible': [
        "Scientists warn that some effects of climate change may be irreversible, meaning that even aggressive intervention cannot restore ecosystems to their original state.",
    ],
    'legitimate': [
        "The auditors confirmed that all of the organization's expenses were legitimate, finding no evidence of fraud or misuse of funds.",
    ],
    'maintain': [
        "Despite mounting criticism, the scientist continued to maintain that her original hypothesis was correct, citing new data from a follow-up study.",
    ],
    'merit': [
        "The scholarship is awarded solely on the basis of merit, with selection committees evaluating candidates on academic achievement and community involvement.",
    ],
    'mitigate': [
        "Engineers installed a series of retaining walls to mitigate the risk of landslides along the newly constructed highway.",
    ],
    'mode': [
        "The artist's preferred mode of expression was watercolor, a medium that allowed for the soft, translucent effects she found impossible to achieve with oils.",
    ],
    'nuance': [
        "A skilled negotiator appreciates the nuance in every proposal, understanding that small differences in wording can have significant legal consequences.",
    ],
    'offset': [
        "The company planted thousands of trees to offset the carbon emissions produced by its manufacturing operations.",
    ],
    'overt': [
        "The politician's overt hostility toward the press made it difficult for journalists to obtain reliable information about policy decisions.",
    ],
    'paradox': [
        "The paradox of thrift suggests that when everyone saves more during a recession, the overall economy may actually contract further.",
    ],
    'patent': [
        "The inventor filed a patent for her new water purification device, hoping to protect the design from being copied by competitors.",
    ],
    'perspective': [
        "Reading literature from different cultures offers students a broader perspective on the human experience, revealing both universal themes and unique traditions.",
    ],
    'plausible': [
        "The detective considered several plausible explanations for the missing evidence before settling on the theory that best fit all the known facts.",
    ],
    'postulate': [
        "The mathematician was the first to postulate that parallel lines could, under certain geometric conditions, eventually converge.",
    ],
    'pragmatic': [
        "The committee took a pragmatic approach to the budget shortfall, cutting non-essential programs rather than raising taxes during an already difficult economic period.",
    ],
    'precursor': [
        "Many historians regard the printing press as a precursor to the modern information age, since it democratized access to knowledge in much the same way the internet does today.",
    ],
    'prevailing': [
        "The prevailing theory among geologists is that the canyon was carved by millions of years of water erosion, though some researchers have proposed alternative explanations.",
    ],
    'profound': [
        "The discovery of antibiotics had a profound impact on medicine, transforming once-deadly infections into easily treatable conditions.",
    ],
    'proliferation': [
        "The proliferation of social media platforms has fundamentally altered how news is consumed, shared, and discussed by the general public.",
    ],
    'pronounced': [
        "The difference in test scores between the two groups was particularly pronounced among students from lower-income households.",
    ],
    'proportion': [
        "A significant proportion of the city's residents rely on public transportation, making bus and rail service essential to the local economy.",
    ],
    'proposition': [
        "The senator introduced a bold proposition to overhaul the nation's infrastructure, proposing a ten-year plan funded by a combination of public and private investment.",
    ],
    'prototype': [
        "The engineers built a working prototype of the solar-powered vehicle and tested it under real-world driving conditions before seeking funding for mass production.",
    ],
    'provocative': [
        "The artist's provocative installation, which featured discarded electronics arranged to resemble a graveyard, sparked intense debate about consumerism and waste.",
    ],
    'reconcile': [
        "Historians have long struggled to reconcile the philosopher's public advocacy for equality with evidence of his private contradictions.",
    ],
    'refine': [
        "The author spent three years refining her manuscript, revising each chapter multiple times to ensure clarity and precision.",
    ],
    'reinforce': [
        "The new findings reinforce earlier studies suggesting that regular physical activity can significantly reduce the risk of cardiovascular disease.",
    ],
    'retain': [
        "Despite the renovations, the building was able to retain many of its original architectural features, including the ornate plasterwork ceiling.",
    ],
    'rigid': [
        "The school's rigid attendance policy left no room for exceptions, even when students had legitimate reasons for their absences.",
    ],
    'robust': [
        "The study's conclusions are supported by a robust dataset spanning three decades and encompassing over fifty thousand participants.",
    ],
    'sparse': [
        "Historical records from the period are sparse, making it difficult for scholars to reconstruct the daily lives of ordinary citizens.",
    ],
    'speculate': [
        "Economists speculate that the new trade agreement could boost the region's GDP by as much as five percent over the next decade.",
    ],
    'subsequent': [
        "The initial experiment yielded promising results, and subsequent trials confirmed that the treatment was both safe and effective.",
    ],
    'substantiate': [
        "The journalist spent months gathering documents to substantiate her claims of corruption within the city government.",
    ],
    'supplant': [
        "Digital streaming services have largely supplanted physical media, with vinyl record sales now representing only a tiny fraction of the music market.",
    ],
    'tangible': [
        "The program has produced tangible results: graduation rates have increased by twelve percent and dropout rates have fallen to their lowest level in a decade.",
    ],
    'thereby': [
        "The new filtration system removes contaminants from the water supply, thereby reducing the risk of waterborne illness in the community.",
    ],
    'undermine': [
        "Critics argue that the proposed budget cuts would undermine the effectiveness of public schools by eliminating funding for after-school programs and teacher training.",
    ],
    'underscore': [
        "The recent surge in extreme weather events underscores the urgent need for comprehensive climate policy at both the national and international levels.",
    ],
    'uniformly': [
        "The new safety standards were not uniformly adopted across all factories, leading to significant variation in working conditions from one facility to the next.",
    ],
    'unprecedented': [
        "The speed at which the vaccine was developed was unprecedented, compressing what normally takes a decade of research into less than a year.",
    ],
    'virtually': [
        "Advances in renewable energy have made it virtually possible to power entire cities without relying on fossil fuels, though challenges in storage and distribution remain.",
    ],
    'ultimately': [
        "After years of debate, the committee ultimately decided to approve the new highway project, concluding that its economic benefits outweighed the environmental costs.",
    ],
}

# Apply context replacements
for word_entry in word_list:
    w = word_entry['word']
    if w in missing_by_word and w in replacement_contexts:
        bad_contexts = missing_by_word[w]
        good_contexts = replacement_contexts[w]

        new_sat_context = []
        replacements_made = 0
        for ctx in word_entry.get('sat_context', []):
            # Check if this context is one of the bad ones
            is_bad = False
            for bad in bad_contexts:
                if ctx.startswith(bad[:40]) or bad[:40] in ctx:
                    is_bad = True
                    break

            if is_bad and replacements_made < len(good_contexts):
                new_sat_context.append(good_contexts[replacements_made])
                replacements_made += 1
                stats['contexts_replaced'] += 1
            else:
                new_sat_context.append(ctx)

        word_entry['sat_context'] = new_sat_context

# For words where we don't have a high-confidence replacement, flag them
for word_entry in word_list:
    w = word_entry['word']
    if w in missing_by_word and w not in replacement_contexts:
        # Check if any contexts are actually bad
        bad_contexts = missing_by_word[w]
        for ctx in word_entry.get('sat_context', []):
            for bad in bad_contexts:
                if ctx.startswith(bad[:40]) or bad[:40] in ctx:
                    word_entry['needs_review'] = True
                    stats['needs_review_items'].append(f"Context for '{w}' still missing the word")
                    break


# --- 6. Add explanations to embedded questions ---

def generate_explanation(question_data):
    """Generate a brief explanation for why the answer is correct."""
    answer = question_data.get('answer', '')
    question = question_data.get('question', '')
    passage = question_data.get('passage', '')
    options = question_data.get('options', [])

    if not answer:
        return None

    # For vocabulary-in-context / word completion questions
    if 'completes the text' in question.lower() and len(answer.split()) <= 3:
        return f'"{answer}" is the best choice because it fits the context of the passage, accurately capturing the meaning and tone required by the surrounding text.'

    # For "main purpose" or "main idea" questions
    if 'main purpose' in question.lower() or 'main idea' in question.lower():
        return f'The correct answer captures the overall purpose of the passage. The other options either focus on minor details or make claims not supported by the text.'

    # For "function of" questions
    if 'function' in question.lower() and 'underlined' in question.lower():
        return f'The underlined portion serves a specific rhetorical function in the passage. The correct answer identifies this function, while the other options mischaracterize the role of the underlined text.'

    # For evidence-based questions
    if 'evidence' in question.lower() or 'support' in question.lower():
        return f'The correct answer provides the strongest textual evidence for the claim in question. The other options either address different points or do not directly support the stated claim.'

    # For inference questions
    if 'infer' in question.lower() or 'suggest' in question.lower() or 'imply' in question.lower():
        return f'The correct answer is the inference best supported by the details in the passage. The other options go beyond what the text supports or contradict information presented.'

    # Generic explanation
    return f'This answer is best supported by the information presented in the passage, while the other options either misrepresent details, make unsupported claims, or fail to address the question directly.'

for word_entry in word_list:
    for q in word_entry.get('sat_questions', []):
        if 'explanation' not in q and q.get('answer'):
            explanation = generate_explanation(q)
            if explanation:
                q['explanation'] = explanation
                stats['explanations_added'] += 1


# ============================================================
# Save files
# ============================================================

with open('word_list.json', 'w') as f:
    json.dump(word_list, f, indent=2, ensure_ascii=False)

with open('sat_reading_questions_deduplicated.json', 'w') as f:
    json.dump(sat_questions, f, indent=2, ensure_ascii=False)

# Print summary
print("=" * 60)
print("CONTENT IMPROVEMENT SUMMARY")
print("=" * 60)
print(f"Blanks filled in sat_questions file: {stats['blanks_filled_sat_questions']}")
print(f"Blanks filled in word_list passages: {stats['blanks_filled_word_list_passages']}")
print(f"Blanks filled in word_list contexts: {stats['blanks_filled_word_list_contexts']}")
print(f"Questions removed (sat file): {stats['questions_removed_sat']}")
print(f"Questions removed (word_list): {stats['questions_removed_word_list']}")
print(f"Fragment examples fixed: {stats['fragment_examples_fixed']}")
print(f"Definitions updated: {stats['definitions_updated']}")
print(f"Contexts replaced: {stats['contexts_replaced']}")
print(f"Explanations added: {stats['explanations_added']}")
print(f"Items flagged needs_review: {len(stats['needs_review_items'])}")
if stats['needs_review_items']:
    for item in stats['needs_review_items'][:20]:
        print(f"  - {item}")
    if len(stats['needs_review_items']) > 20:
        print(f"  ... and {len(stats['needs_review_items']) - 20} more")

# Save stats for summary generation
with open('content-improvement/fix-stats.json', 'w') as f:
    json.dump(stats, f, indent=2, ensure_ascii=False)

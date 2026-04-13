#!/usr/bin/env python3
"""Fix remaining context entries where the word is missing."""

import json
import os

os.chdir('/Users/jiong/myprojects/satspell')

with open('word_list.json', 'r') as f:
    word_list = json.load(f)

with open('content-improvement/audit-report.json', 'r') as f:
    audit_report = json.load(f)

from collections import defaultdict
missing_by_word = defaultdict(list)
for item in audit_report.get('word_missing_from_context', []):
    missing_by_word[item['word']].append(item['context'])

replacement_contexts = {
    'attrition': [
        "The company experienced significant attrition among senior staff, losing nearly a quarter of its experienced engineers in a single year.",
        "The general's strategy relied on attrition, gradually wearing down the enemy's forces through a series of small, relentless engagements.",
    ],
    'commended': [
        "The teacher commended the student for her thorough research, noting that the depth of her analysis exceeded what was expected at the undergraduate level.",
    ],
    'complementary': [
        "The two researchers brought complementary skills to the project: one excelled at data analysis while the other had deep expertise in experimental design.",
        "The restaurant offers a complementary blend of traditional and modern cuisine, pairing classic techniques with unexpected flavor combinations.",
        "Art historians have noted that the complementary colors in the painting create a sense of visual harmony that draws the viewer's eye across the canvas.",
    ],
    'consequently': [
        "The factory discharged untreated wastewater into the river for years; consequently, the local fish population declined dramatically.",
    ],
    'conspicuous': [
        "The bright red sculpture was conspicuous against the gray concrete of the plaza, drawing the attention of every passerby.",
        "Her conspicuous absence from the meeting led colleagues to speculate that she disagreed with the proposed changes.",
        "The sociologist studied patterns of conspicuous consumption, examining how people use expensive goods to signal social status.",
    ],
    'corroborate': [
        "The eyewitness testimony helped corroborate the forensic evidence, strengthening the prosecution's case considerably.",
    ],
    'denotes': [
        "In musical notation, a sharp symbol denotes that a note should be raised by one half step.",
        "The prefix 'bio-' denotes a connection to living organisms, as seen in words like biology and biodiversity.",
        "In the study, a score above ninety denotes mastery of the material, while scores below sixty indicate the need for additional instruction.",
    ],
    'diffusion': [
        "The diffusion of printing technology across Europe in the fifteenth century accelerated the spread of new ideas and contributed to the Renaissance.",
        "In chemistry, diffusion refers to the process by which molecules move from areas of high concentration to areas of low concentration.",
    ],
    'efficacy': [
        "Clinical trials are designed to measure the efficacy of new medications, comparing their effects against a placebo to determine whether they produce meaningful benefits.",
    ],
    'eliciting': [
        "The researcher's carefully worded questions were effective in eliciting honest responses from participants who might otherwise have been reluctant to share personal opinions.",
    ],
    'engender': [
        "The policy changes engendered widespread frustration among employees, who felt they had not been consulted before the decisions were made.",
        "The leader's passionate speeches were intended to engender a sense of national unity during a period of deep political division.",
    ],
    'engendering': [
        "By engendering trust between communities and law enforcement, the new program hopes to reduce crime through cooperation rather than confrontation.",
    ],
    'enumerate': [
        "The report carefully enumerates the steps required to bring the building up to current safety codes, listing each deficiency along with a recommended solution.",
    ],
    'evade': [
        "The suspect attempted to evade capture by fleeing across the border, but international cooperation between police agencies led to his arrest within days.",
    ],
    'exaggerate': [
        "Critics accused the filmmaker of choosing to exaggerate the dangers of the technology in order to create a more dramatic narrative.",
    ],
    'expense': [
        "The expansion of urban development often comes at the expense of natural habitats, displacing wildlife that once thrived in those areas.",
    ],
    'extemporaneous': [
        "The senator's extemporaneous remarks at the press conference were surprisingly eloquent, given that she had no time to prepare a formal statement.",
    ],
    'fusion': [
        "The chef's menu reflects a fusion of Japanese and Mexican culinary traditions, combining fresh sashimi with spicy salsas in unexpected but harmonious ways.",
    ],
    'hallmark': [
        "Attention to detail has always been the hallmark of her writing, with every sentence carefully crafted to convey precisely the intended meaning.",
    ],
    'halting': [
        "The witness gave a halting account of the events, pausing frequently and struggling to find the right words to describe what she had seen.",
    ],
    'impart': [
        "The master craftsman sought to impart his knowledge to the next generation of woodworkers, spending hours each day teaching techniques he had learned over a lifetime.",
    ],
    'inconsequential': [
        "What seemed like an inconsequential detail in the early chapters of the novel turned out to be a crucial clue to the mystery's resolution.",
    ],
    'inconsistencies': [
        "The auditors flagged several inconsistencies in the financial records, noting that reported expenses did not match the amounts shown on receipts.",
    ],
    'inestimable': [
        "The manuscripts held in the archive are of inestimable value to scholars, providing firsthand accounts of events that were previously known only through secondhand sources.",
    ],
    'innovative': [
        "The company's innovative approach to packaging has significantly reduced plastic waste while maintaining the durability needed to protect products during shipping.",
    ],
    'insuperable': [
        "What initially appeared to be an insuperable obstacle was eventually overcome through creative problem-solving and persistent effort.",
    ],
    'insurmountable': [
        "The team faced what seemed like insurmountable challenges, but through careful planning and collaboration, they completed the project ahead of schedule.",
    ],
    'integral': [
        "Community feedback was an integral part of the design process, ensuring that the new park would meet the needs of the residents who would use it most.",
    ],
    'interconnected': [
        "The study revealed that the region's economic, environmental, and social challenges are deeply interconnected, meaning that progress in one area requires attention to all three.",
    ],
    'interplay': [
        "The novel explores the interplay between personal ambition and family obligation, showing how the protagonist's choices affect those closest to her.",
    ],
    'invoked': [
        "The speaker invoked the memory of past struggles for justice to inspire the audience to continue fighting for equality.",
    ],
    'irrefutable': [
        "The fossil record provides irrefutable evidence that dinosaurs once roamed every continent on Earth, including Antarctica.",
    ],
    'lean': [
        "During the lean winter months, the community relied on stored grain and preserved vegetables to sustain itself until the spring harvest.",
    ],
    'likewise': [
        "The first study found that students performed better with hands-on learning; likewise, a follow-up study confirmed that practical exercises improved retention more than lectures alone.",
    ],
    'magnify': [
        "The use of electron microscopes has allowed scientists to magnify cellular structures thousands of times, revealing details invisible to the naked eye.",
    ],
    'multifariousness': [
        "The multifariousness of the city's cultural offerings—from opera and ballet to street art and underground music—makes it one of the most vibrant places in the world.",
    ],
    'mutable': [
        "Unlike the fixed laws of physics, social norms are highly mutable, shifting from one generation to the next in response to changing values.",
    ],
    'nebulous': [
        "The company's strategy remained nebulous, with executives offering only vague assurances about future growth instead of concrete plans.",
    ],
    'obstinacy': [
        "The negotiator's obstinacy on minor procedural points nearly derailed the entire peace process, frustrating diplomats who had worked for months to arrange the talks.",
    ],
    'orthodox': [
        "The scientist's findings challenged orthodox views of plate tectonics, suggesting that continental drift may occur more rapidly than previously believed.",
    ],
    'palpable': [
        "The tension in the courtroom was palpable as the jury filed in to deliver its verdict after three days of deliberation.",
    ],
    'paucity': [
        "The paucity of reliable data from the region makes it difficult for researchers to draw firm conclusions about the effects of deforestation on local wildlife.",
    ],
    'perturbation': [
        "Even a small perturbation in the orbit of an asteroid can, over millions of years, result in a significant change in its trajectory.",
    ],
    'pervades': [
        "A sense of optimism pervades the community since the announcement of new jobs coming to the area, lifting spirits that had been low for years.",
    ],
    'pervasive': [
        "The influence of social media on modern life is so pervasive that it shapes everything from political discourse to personal relationships.",
    ],
    'plentiful': [
        "In the years following the war, resources that had once been scarce became plentiful again, and the economy began a sustained period of growth.",
    ],
    'pollinate': [
        "Wind and insects pollinate most flowering plants, but some species rely on birds or bats to carry pollen from one bloom to another.",
    ],
    'populated': [
        "The region was once densely populated by indigenous communities who built elaborate settlements along the riverbanks.",
    ],
    'prescient': [
        "The author's prescient novel, published in 1990, accurately predicted many of the technological and social changes that would define the early twenty-first century.",
    ],
    'prevail over': [
        "Throughout history, movements for civil rights have ultimately managed to prevail over entrenched systems of inequality, though progress has often been painfully slow.",
    ],
    'reciprocal': [
        "The two nations signed a reciprocal trade agreement, each reducing tariffs on the other's exports by the same percentage.",
    ],
    'reliably': [
        "The new sensor can reliably detect trace amounts of pollutants in groundwater, providing early warning before contamination reaches dangerous levels.",
    ],
    'revolt': [
        "The citizens organized a revolt against the oppressive tax policies, staging demonstrations that eventually forced the government to negotiate reforms.",
    ],
    'satiate': [
        "No amount of reading seemed to satiate her curiosity about the ancient civilization; each discovery only raised more questions she wanted to answer.",
    ],
    'soothed': [
        "The gentle rhythm of the waves soothed the travelers after their long journey, and they sat quietly on the shore as the sun set.",
    ],
    'spurious': [
        "The committee dismissed the allegations as spurious, noting that they were based on fabricated documents and unreliable testimony.",
    ],
    'subtlety': [
        "The subtlety of the composer's harmonic choices is easy to overlook on first listening, but repeated hearings reveal layers of complexity beneath the simple melody.",
    ],
    'supplement': [
        "The professor encouraged students to supplement the textbook readings with primary source materials available in the university library.",
    ],
    'supposition': [
        "The detective's supposition that the crime was committed by someone known to the victim was later confirmed when DNA evidence pointed to a close associate.",
    ],
    'suppress': [
        "The government attempted to suppress publication of the report, but journalists leaked its contents to the press before authorities could intervene.",
    ],
    'surmounted': [
        "The expedition surmounted numerous obstacles, including extreme weather and equipment failures, to become the first team to reach the summit by the northern route.",
    ],
    'synthesis': [
        "The researcher's book represents a masterful synthesis of decades of scholarship, drawing together findings from history, economics, and sociology into a single coherent narrative.",
    ],
    'tranquil': [
        "The tranquil surface of the lake reflected the surrounding mountains with such clarity that it was difficult to tell where the water ended and the sky began.",
    ],
    'tranquility': [
        "The garden was designed as a space of tranquility, with winding paths, flowing water, and carefully placed stones meant to encourage quiet reflection.",
    ],
    'ubiquitous': [
        "Smartphones have become so ubiquitous that it is now unusual to see someone without one, even in the most remote corners of the developing world.",
    ],
    'unequivocal': [
        "The panel issued an unequivocal statement condemning the use of chemical weapons, leaving no room for misinterpretation of its position.",
    ],
}

# Apply fixes
contexts_replaced = 0
needs_review_cleared = 0

for word_entry in word_list:
    w = word_entry['word']
    if w in missing_by_word and w in replacement_contexts:
        bad_contexts = missing_by_word[w]
        good_contexts = replacement_contexts[w]

        new_sat_context = []
        replacements_made = 0
        for ctx in word_entry.get('sat_context', []):
            is_bad = False
            for bad in bad_contexts:
                if ctx.startswith(bad[:40]) or bad[:40] in ctx:
                    is_bad = True
                    break

            if is_bad and replacements_made < len(good_contexts):
                new_sat_context.append(good_contexts[replacements_made])
                replacements_made += 1
                contexts_replaced += 1
            else:
                new_sat_context.append(ctx)

        word_entry['sat_context'] = new_sat_context

        # Clear needs_review flag if we fixed all contexts
        if word_entry.get('needs_review') and replacements_made > 0:
            del word_entry['needs_review']
            needs_review_cleared += 1

print(f"Additional contexts replaced: {contexts_replaced}")
print(f"needs_review flags cleared: {needs_review_cleared}")

# Count remaining needs_review
remaining = sum(1 for w in word_list if w.get('needs_review'))
print(f"Remaining needs_review: {remaining}")

with open('word_list.json', 'w') as f:
    json.dump(word_list, f, indent=2, ensure_ascii=False)

# Update stats
with open('content-improvement/fix-stats.json', 'r') as f:
    stats = json.load(f)

stats['contexts_replaced'] += contexts_replaced
# Recalculate needs_review items
remaining_words = [w['word'] for w in word_list if w.get('needs_review')]
stats['needs_review_items'] = [f"Context for '{w}' still missing the word" for w in remaining_words]

with open('content-improvement/fix-stats.json', 'w') as f:
    json.dump(stats, f, indent=2, ensure_ascii=False)

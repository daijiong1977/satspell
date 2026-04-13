#!/usr/bin/env python3
"""Fix all remaining blank contexts in word_list.json by replacing them with good contexts."""

import json
import os

os.chdir('/Users/jiong/myprojects/satspell')

with open('word_list.json', 'r') as f:
    word_list = json.load(f)

# For contexts with blanks that we can't fill, replace them with good sentences
# that use the word naturally
replacement_map = {
    'affecting': {
        1: "The documentary explores how deforestation is affecting indigenous communities across the Amazon, disrupting centuries-old ways of life.",
    },
    'ample': {
        0: "The library provided ample study space for students preparing for final exams, with quiet rooms available on every floor.",
        1: "The grant offered ample funding for the research team to conduct field studies over a three-year period.",
    },
    'arbitrary': {
        0: "The philosopher argued that moral judgments are not arbitrary but are grounded in shared principles that have evolved over millennia.",
        1: "Critics complained that the committee's selection criteria appeared arbitrary, with no clear explanation for why some applicants were chosen over others.",
        2: "The teacher emphasized that the grading rubric was designed to be fair and consistent, not arbitrary or subjective.",
    },
    'corpus': {
        3: "Linguists compiled a large corpus of spoken English to study how regional dialects influence word choice and sentence structure.",
    },
    'criterion': {
        0: "The primary criterion for judging the science fair entries was originality of research, though clarity of presentation was also considered.",
        1: "Popper argued that the criterion of falsifiability should be the standard for distinguishing genuine scientific theories from pseudoscience.",
    },
    'critical': {
        1: "The film received critical acclaim for its innovative storytelling and stunning cinematography, earning several awards at international festivals.",
    },
    'demonstrate': {
        1: "The experiment was designed to demonstrate that the new material could withstand temperatures exceeding 2,000 degrees Fahrenheit without degrading.",
    },
    'designation': {
        1: "The park earned its designation as a UNESCO World Heritage Site after a rigorous evaluation of its ecological and cultural significance.",
        2: "Several years often pass between a soil's selection and its official designation as a state symbol, as the legislative process can be slow.",
    },
    'empirical': {
        1: "The hypothesis remained controversial until empirical studies provided measurable evidence supporting its central claims.",
    },
    'examine': {
        2: "In their research, behavioral economists integrate methods from psychology and economics to examine how and why people make particular choices.",
    },
    'extensive': {
        1: "The historian's extensive research in European archives uncovered letters that shed new light on diplomatic negotiations during the war.",
    },
    'fair': {
        1: "The judge was known for conducting fair trials, carefully weighing all evidence before reaching a verdict.",
    },
    'fungi': {
        0: "Tree resins quickly seal wounds, which helps prevent harmful insects and fungi from entering the wood and causing decay.",
    },
    'imply': {
        0: "The data does not imply a causal relationship between the two variables; further research is needed to determine whether one actually influences the other.",
        2: "The author's choice of imagery seems to imply a deep ambivalence about technological progress, though she never states this directly.",
    },
    'insight': {
        1: "The biography offers valuable insight into the artist's creative process, revealing how personal struggles shaped her most celebrated works.",
    },
    'insuperable': {
        1: "Though the mathematical challenge seemed insuperable to many researchers, a breakthrough in computational methods eventually made a proof possible.",
    },
    'integrate': {
        0: "The school's new curriculum aims to integrate the arts with core academic subjects, allowing students to explore scientific concepts through creative projects.",
    },
    'keen': {
        0: "The young scientist displayed a keen interest in marine biology, spending every available weekend observing tidal pools along the coast.",
    },
    'lot': {
        0: "The auction attracted a lot of attention from collectors, with several rare manuscripts selling for prices well above their estimated value.",
    },
    'multifariousness': {
        1: "The multifariousness of plant structures found in the tropical forest reflects millions of years of evolutionary adaptation to varied environmental pressures.",
    },
    'patent': {
        2: "The inventor's 1949 patent described an interactive reading device with features that would not become commonplace in electronic books for another sixty years.",
    },
    'petition': {
        1: "A group of prominent authors signed a petition protesting the unauthorized reproduction of their work, calling for stronger copyright protections.",
    },
    'populated': {
        1: "The researchers populated the experimental plots with carefully selected microbe communities to study how soil composition affects plant growth.",
        2: "The valley was once populated by thriving agricultural communities, but prolonged drought forced most residents to relocate to the coast.",
    },
    'precursor': {
        2: "The medieval trading city served as a precursor to modern commercial centers, establishing banking practices and trade agreements that influenced European commerce for centuries.",
    },
    'primary': {
        0: "The primary goal of the expedition was to collect geological samples from the ocean floor, though secondary objectives included mapping underwater volcanic activity.",
    },
    'prominence': {
        3: "The mountain's prominence—the height difference between its summit and the lowest contour line encircling it—makes it one of the most visually striking peaks in the range.",
        4: "The young poet rose to prominence after her debut collection won a major literary prize, drawing praise from critics nationwide.",
    },
    'promote': {
        1: "The researcher suggests that the antioxidant can promote cellular health by neutralizing the free radicals that cause tissue damage over time.",
    },
    'prototype': {
        0: "The engineers built a working prototype of the device, testing its basic functions before investing in the complex electronics needed for the final product.",
    },
    'proximity': {
        2: "The proximity of the two schools allows students to share facilities, including a library, gymnasium, and science laboratory.",
    },
    'radical': {
        0: "The scientist proposed a radical new theory that challenged decades of established thinking about how ecosystems respond to climate change.",
        1: "Antioxidants help protect cells from radical damage by neutralizing unstable molecules before they can harm healthy tissue.",
    },
    'repository': {
        1: "The national archive serves as a repository of historical documents, preserving everything from presidential correspondence to census records.",
    },
    'temperate': {
        3: "The temperate climate of the region, with its mild winters and warm summers, makes it ideal for growing a wide variety of fruit and vegetable crops.",
    },
    'tenuous': {
        0: "The connection between the two events was tenuous at best, relying on circumstantial evidence that many scholars found unconvincing.",
        1: "The endangered species clings to a tenuous existence in a shrinking habitat, with fewer than five hundred individuals remaining in the wild.",
        2: "The treaty established a tenuous peace between the two nations, one that many diplomats feared would not survive the next election cycle.",
    },
    'transport': {
        1: "The construction of the railway transformed how goods were transported across the continent, reducing delivery times from weeks to days.",
    },
    'unclassifiable': {
        0: "The writer's work is deliberately unclassifiable, blending elements of science fiction, literary fiction, and memoir in ways that resist easy categorization.",
    },
    'utility': {
        1: "The utility of the new software tool became apparent when it reduced the time required for data analysis from several hours to just a few minutes.",
    },
    'vibrant': {
        0: "The mural's vibrant colors—deep reds, electric blues, and bright yellows—transformed the dull concrete wall into a striking work of public art.",
    },
}

blanks_fixed = 0
for word_entry in word_list:
    w = word_entry['word']
    if w in replacement_map:
        for idx, replacement in replacement_map[w].items():
            if idx < len(word_entry.get('sat_context', [])):
                old = word_entry['sat_context'][idx]
                if '______' in old or '___' in old:
                    word_entry['sat_context'][idx] = replacement
                    blanks_fixed += 1

print(f"Blanks fixed in this pass: {blanks_fixed}")

# Verify no blanks remain
remaining = 0
for w in word_list:
    for ctx in w.get('sat_context', []):
        if '______' in ctx or '___' in ctx:
            remaining += 1
            print(f"REMAINING: {w['word']}: {ctx[:80]}")
    for q in w.get('sat_questions', []):
        if '______' in q.get('passage', '') or '___' in q.get('passage', ''):
            remaining += 1
            print(f"REMAINING Q: {w['word']}: {q['passage'][:80]}")

print(f"Total remaining blanks: {remaining}")

with open('word_list.json', 'w') as f:
    json.dump(word_list, f, indent=2, ensure_ascii=False)

const response = await fetch("./data/findings.json");
const data = await response.json();
const repoBaseUrl = data.meta.repoBaseUrl;

const verdictClass = {
  Solid: "badge-solid",
  Qualified: "badge-qualified",
  Illustrative: "badge-illustrative",
};

const statusClass = {
  proved: "status-proved",
  qualified: "status-qualified",
  example: "status-example",
  frontier: "status-frontier",
};

// Jargon definitions — shown as tooltips on dotted-underline terms.
const jargonDefs = {
  "expected utility": "a way of choosing between options by multiplying how good each outcome is by how likely it is, then picking the highest number",
  "lexicographic preferences": "instead of putting everything on one scale, you handle the worst outcomes first and only compare the rest after ruling out catastrophe",
  "TDT": "Timeless Decision Theory — a theory that says you should choose as if you are selecting the output of your decision algorithm, not just reacting to the situation",
  "EDT": "Evidential Decision Theory — a theory that says you should choose the action that is best news about the outcome, even if it does not cause the outcome",
  "CDT": "Causal Decision Theory — a theory that says you should choose the action that causally produces the best outcome",
  "common priors": "the assumption that all rational agents start from the same background beliefs before seeing different evidence",
  "Aumann agreement": "a theorem showing that rational agents with common priors who share their conclusions must eventually agree — even without sharing their evidence",
  "Nash equilibrium": "a situation where no player can improve their outcome by changing only their own strategy, given what everyone else is doing",
  "subgame-perfect": "a stronger version of Nash equilibrium that also requires rational play at every point in the game, not just the start",
  "NP oracle": "a hypothetical device that instantly solves problems that would normally take an impossibly long time to compute, but whose answers are easy to verify",
  "money-pump": "a sequence of trades where someone's preferences lead them to give away money in a circle, ending up worse off by their own standards",
  "Novikov consistency": "a principle from physics saying that time travel cannot create paradoxes — any time loop must be self-consistent",
  "Stackelberg": "a game where one player moves first and commits publicly, forcing the other to respond — giving the leader a strategic advantage",
  "Bayesian": "relating to Bayes' theorem, a formula for updating your beliefs when you get new evidence",
  "posterior": "your updated belief after seeing new evidence (as opposed to your prior belief before seeing it)",
  "prior": "your initial belief about how likely something is before seeing new evidence",
  "fixed point": "a state that maps back to itself — in a time loop, an outcome that is self-consistent when sent back in time",
  "causal graph": "a diagram showing which events cause which other events, with arrows pointing from cause to effect",
  "logical counterfactuals": "hypothetical scenarios asking 'what would happen if my decision algorithm gave a different answer?' — harder to define than ordinary counterfactuals",
  "decision theory": "the study of how to make choices when outcomes are uncertain — it tries to define what 'rational' means in precise terms",
  "Lean 4": "a programming language designed for writing mathematical proofs that a computer can check step by step",
  "Lean": "a programming language designed for writing mathematical proofs that a computer can check step by step",
  "Bayesian reasoning": "updating your beliefs based on new evidence, using probability — named after the mathematician Thomas Bayes",
  "game theory": "the study of strategic situations where the best choice depends on what other people decide to do",
  "hypothesis": "a specific claim or explanation you're testing — the thing you're trying to prove or disprove",
  "proof assistant": "software that checks every logical step of an argument and refuses to continue if a step is missing or unjustified",
  "formal verification": "using software to check that every step of an argument follows logically, with no gaps or hand-waving allowed",
};

// Map featured finding titles to their hidden assumptions.
const axiomBreaks = {
  "Confirmation bias is not always irrational — it depends on what you already believe":
    "The irrationality of confirmation bias depends on what hypotheses you thought were plausible — it is not a universal law.",
  "Time travel does not give you a supercomputer — the universe can always choose the boring loop":
    "Self-consistency does not select the useful fixed point; the trivial 'nothing happens' loop is always available.",
  "The standard way to compare catastrophic outcomes breaks when everything might kill everyone":
    "Expected utility assumes outcomes can be summed and compared on a single scale — even when one outcome is negative infinity.",
};

document.querySelector("#source-note").textContent =
  `Source of truth: ${data.meta.sourceOfTruth}`;
document.querySelector("#sync-note").textContent = data.meta.syncPolicy;

renderFeaturedFindings(data.meta.featuredFindings);
renderCaseFiles(data.caseFiles);
renderLedger(data.hiddenAssumptions);

// After all rendering, hydrate jargon tooltips across the page.
hydrateJargon();

// Handle hash-based navigation on load.
if (window.location.hash) {
  setTimeout(() => {
    const target = document.querySelector(window.location.hash);
    if (target) target.scrollIntoView({ behavior: "smooth", block: "start" });
  }, 300);
}

function slugify(text) {
  return text
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "")
    .slice(0, 60);
}

function anchorButton(id) {
  return `<a class="anchor-link" href="#${id}" title="Copy link to this finding" aria-label="Link to this finding">#</a>`;
}


function renderFeaturedFindings(items) {
  const container = document.querySelector("#featured-findings");
  container.innerHTML = items
    .map(
      (item) => {
        const id = `finding-${slugify(item.title)}`;
        return `
        <article class="featured-card" id="${id}">
          <div class="card-top">
            <div>
              <div class="meta-row">
                <span class="featured-rank">${escapeHtml(item.rank)}</span>
                <span class="status-badge ${statusClass[item.badgeStyle] || ""}">
                  ${escapeHtml(item.badge)}
                </span>
                <span class="tag">${escapeHtml(item.findingKind)}</span>
              </div>
              <p class="section-kicker" style="margin-top:0.5rem">${escapeHtml(item.module)}</p>
              <h3>${escapeHtml(item.title)} ${anchorButton(id)}</h3>
            </div>
          </div>
          <p>${escapeHtml(item.summary)}</p>
          ${axiomBreaks[item.title] ? `
          <div class="axiom-callout">
            <span class="axiom-label">Hidden assumption</span>
            <span class="axiom-value">${escapeHtml(axiomBreaks[item.title])}</span>
          </div>
          ` : ""}
          <div class="link-list">
            <a class="proof-link" href="${escapeHtml(githubBlob(item.modulePath, item.moduleLine))}" target="_blank" rel="noreferrer">Module</a>
            ${item.theoremLinks
              .map(
                (link) =>
                  `<a class="proof-link" href="${escapeHtml(githubBlob(item.modulePath, link.line))}" target="_blank" rel="noreferrer">${escapeHtml(link.label)}</a>`
              )
              .join("")}
          </div>
          <details class="viewer" data-snippet-path="${escapeHtml(item.snippetPath)}">
            <summary>See the Lean proof</summary>
            <pre><code>Loading excerpt...</code></pre>
          </details>
        </article>
      `;
      }
    )
    .join("");
  hydrateSnippets();
}


const CASE_FILES_VISIBLE = 3;

function renderCaseFiles(caseFiles) {
  const container = document.querySelector("#case-files");
  const total = caseFiles.length;

  container.innerHTML = caseFiles
    .map(
      (item, index) => {
        const id = `finding-${slugify(item.title)}`;
        const hiddenClass = index >= CASE_FILES_VISIBLE ? " case-card-hidden" : "";
        return `
        <article class="case-card${hiddenClass}" data-case-index="${index}" id="${id}">
          <div class="case-card-summary">
            <div class="card-top">
              <div>
                <p class="section-kicker">${escapeHtml(item.module)}</p>
                <h3>${escapeHtml(item.title)} ${anchorButton(id)}</h3>
              </div>
              <span class="badge ${verdictClass[item.verdict] || ""}">
                ${escapeHtml(item.verdict)}
              </span>
            </div>

            ${item.keyAssumption ? `
            <div class="axiom-callout axiom-callout-compact">
              <span class="axiom-label">Hidden assumption</span>
              <span class="axiom-value">${escapeHtml(item.keyAssumption)}</span>
            </div>
            ` : ""}

            <button class="case-card-expand" aria-label="Expand details">
              <span class="expand-icon">&#9660;</span> Details
            </button>
          </div>

          <div class="case-card-details">
            <div class="card-block">
              <h4>HPMOR claim</h4>
              <p class="claim-quote">${escapeHtml(item.hpmorClaim)}</p>
            </div>

            <div class="card-block">
              <h4>What survived</h4>
              <p>${escapeHtml(item.whatSurvived)}</p>
            </div>

            <div class="card-block">
              <h4>What reality objected to</h4>
              <p>${escapeHtml(item.whatRealityObjectedTo)}</p>
            </div>

            <div class="provenance">
              <div class="provenance-row"><strong>Lean module:</strong> <a href="${escapeHtml(githubBlob(item.modulePath, item.moduleLine || 1))}" target="_blank" rel="noreferrer"><code>${escapeHtml(item.modulePath)}</code></a></div>
              <div class="provenance-row"><strong>Theorem anchors:</strong> ${item.theoremLinks
                .map(
                  (link) =>
                    `<a href="${escapeHtml(githubBlob(item.modulePath, link.line))}" target="_blank" rel="noreferrer">${escapeHtml(link.label)}</a>`
                )
                .join(", ")}</div>
              <div class="provenance-row"><strong>Proof status:</strong> ${escapeHtml(item.proofStatus)}</div>
              <div class="provenance-row"><strong>Roadmap:</strong> <a href="${escapeHtml(roadmapLine(item.roadmapLine))}" target="_blank" rel="noreferrer">entry at line ${escapeHtml(item.roadmapLine)}</a></div>
            </div>

            <div class="card-block">
              <h4>Best next pressure points</h4>
              <ul class="bullet-list">
                ${item.nextPressurePoints.map((point) => `<li>${escapeHtml(point)}</li>`).join("")}
              </ul>
            </div>
          </div>
        </article>
      `;
      }
    )
    .join("");

  // "Show more" button
  if (total > CASE_FILES_VISIBLE) {
    const btn = document.createElement("button");
    btn.className = "show-more-btn";
    btn.textContent = `Show all ${total} findings`;
    btn.addEventListener("click", () => {
      container.querySelectorAll(".case-card-hidden").forEach((card) => {
        card.classList.remove("case-card-hidden");
      });
      btn.remove();
    });
    container.after(btn);
  }

  // Add click-to-expand behavior
  container.querySelectorAll(".case-card").forEach((card) => {
    card.addEventListener("click", (e) => {
      // Don't toggle if clicking a link or anchor
      if (e.target.closest("a")) return;
      card.classList.toggle("expanded");
    });
  });
}

function renderLedger(entries) {
  const container = document.querySelector("#ledger");
  container.innerHTML = entries
    .map(
      (entry) => `
        <article class="ledger-item">
          <h3>${escapeHtml(entry.title)}</h3>
          <p>${escapeHtml(entry.description)}</p>
        </article>
      `
    )
    .join("");
}


function githubBlob(path, line = 1) {
  return `${repoBaseUrl}${path}#L${line}`;
}

function roadmapLine(line) {
  return `${repoBaseUrl}ROADMAP.md#L${line}`;
}

async function hydrateSnippets() {
  const viewers = document.querySelectorAll("[data-snippet-path]");
  await Promise.all(
    [...viewers].map(async (viewer) => {
      const path = viewer.getAttribute("data-snippet-path");
      const code = viewer.querySelector("code");
      try {
        const response = await fetch(path);
        code.textContent = await response.text();
      } catch {
        code.textContent = "Excerpt unavailable. Use the theorem links above.";
      }
    })
  );
}

// Jargon tooltip hydration: scans text nodes and wraps matching terms
// in <span class="jargon" data-definition="..."> elements.
function hydrateJargon() {
  // Build a sorted list of terms (longest first to avoid partial matches).
  const terms = Object.keys(jargonDefs).sort((a, b) => b.length - a.length);
  // Build a single regex matching any term (case-insensitive, word-boundary).
  const pattern = new RegExp(
    `\\b(${terms.map((t) => t.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")).join("|")})\\b`,
    "gi"
  );

  const seen = new Set(); // Track terms already defined so we only tooltip each once.

  // Walk the DOM tree and process text nodes.
  const walker = document.createTreeWalker(
    document.querySelector(".page-shell"),
    NodeFilter.SHOW_TEXT,
    {
      acceptNode(node) {
        // Skip nodes inside code, pre, script, style, or already-wrapped jargon spans.
        const parent = node.parentElement;
        if (!parent) return NodeFilter.FILTER_REJECT;
        const tag = parent.tagName;
        if (tag === "CODE" || tag === "PRE" || tag === "SCRIPT" || tag === "STYLE")
          return NodeFilter.FILTER_REJECT;
        if (parent.classList.contains("jargon")) return NodeFilter.FILTER_REJECT;
        return NodeFilter.FILTER_ACCEPT;
      },
    }
  );

  const textNodes = [];
  while (walker.nextNode()) textNodes.push(walker.currentNode);

  for (const node of textNodes) {
    const text = node.textContent;
    if (!pattern.test(text)) continue;
    pattern.lastIndex = 0; // Reset regex state.

    const frag = document.createDocumentFragment();
    let lastIndex = 0;
    let match;

    pattern.lastIndex = 0;
    while ((match = pattern.exec(text)) !== null) {
      const term = match[1];
      const termKey = term.toLowerCase();
      // Only wrap first occurrence of each term.
      const def = jargonDefs[termKey] || jargonDefs[term];
      if (!def) continue;

      // Add text before the match.
      if (match.index > lastIndex) {
        frag.appendChild(document.createTextNode(text.slice(lastIndex, match.index)));
      }

      if (seen.has(termKey)) {
        // Already defined — just pass through as plain text.
        frag.appendChild(document.createTextNode(term));
      } else {
        seen.add(termKey);
        const span = document.createElement("span");
        span.className = "jargon";
        span.setAttribute("tabindex", "0");
        span.setAttribute("data-definition", def);
        span.textContent = term;
        frag.appendChild(span);
      }

      lastIndex = match.index + match[0].length;
    }

    if (lastIndex === 0) continue; // No actual replacements made.

    // Add remaining text.
    if (lastIndex < text.length) {
      frag.appendChild(document.createTextNode(text.slice(lastIndex)));
    }

    node.parentNode.replaceChild(frag, node);
  }
}

function countBy(items, key) {
  return items.reduce((acc, item) => {
    const value = item[key];
    acc[value] = (acc[value] || 0) + 1;
    return acc;
  }, {});
}

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}

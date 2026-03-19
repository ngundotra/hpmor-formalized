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

document.querySelector("#source-note").textContent =
  `Source of truth: ${data.meta.sourceOfTruth}`;
document.querySelector("#sync-note").textContent = data.meta.syncPolicy;

renderFeaturedFindings(data.meta.featuredFindings);
renderDashboard(data);
renderSummary(data);
renderWhyItMatters(data.meta.whyItMatters);
renderTakeaways(data.meta.keyTakeaways);
renderLegend(data.meta.legend);
renderCaseFiles(data.caseFiles);
renderLedger(data.hiddenAssumptions);
renderAttacks(data.nextAttacks);
renderTools(data.tools);

function renderDashboard(siteData) {
  const dashboard = document.querySelector("#dashboard");
  const total = siteData.caseFiles.length;
  const hiddenAssumptions = siteData.hiddenAssumptions.length;
  const byVerdict = countBy(siteData.caseFiles, "verdict");
  const byTier = countBy(siteData.caseFiles, "currentTier");

  const stats = [
    {
      label: "Imported Modules",
      value: escapeHtml(siteData.meta.repoStats.modules),
      blurb: "Lean modules currently imported into the library root.",
    },
    {
      label: "Declarations",
      value: escapeHtml(siteData.meta.repoStats.theorems),
      blurb: "Current theorem + lemma declarations across the codebase.",
    },
    {
      label: "Tracked Findings",
      value: escapeHtml(siteData.meta.repoStats.trackedFindings),
      blurb: "Findings currently summarized in the roadmap table.",
    },
    {
      label: "Current Split",
      value: `${byVerdict.Solid || 0}/${byVerdict.Qualified || 0}/${byVerdict.Illustrative || 0}`,
      blurb: "Solid, qualified, and illustrative case files in the current surface view.",
    },
    {
      label: "Hidden Assumptions",
      value: String(hiddenAssumptions),
      blurb: "Places where formalization forced an unstated premise into view.",
    },
    {
      label: "Tier Spread",
      value: Object.keys(byTier)
        .sort()
        .map((tier) => tier.replace("Tier ", "T"))
        .join(" · "),
      blurb: "Acceptance-tier footprint across the case files shown here.",
    },
  ].slice(0, 6);

  dashboard.innerHTML = stats
    .map(
      (stat) => `
        <article class="stat-card">
          <p class="section-kicker">${escapeHtml(stat.label)}</p>
          <span class="value">${escapeHtml(stat.value)}</span>
          <p>${escapeHtml(stat.blurb)}</p>
        </article>
      `
    )
    .join("");
}

function renderFeaturedFindings(items) {
  const container = document.querySelector("#featured-findings");
  container.innerHTML = items
    .map(
      (item) => `
        <article class="featured-card">
          <div class="card-top">
            <div>
              <p class="section-kicker">${escapeHtml(item.module)}</p>
              <h3>${escapeHtml(item.title)}</h3>
            </div>
            <span class="status-badge ${statusClass[item.badgeStyle] || ""}">
              ${escapeHtml(item.badge)}
            </span>
          </div>
          <p>${escapeHtml(item.summary)}</p>
          <div class="card-block">
            <h4>Why it matters</h4>
            <p>${escapeHtml(item.whyItMatters)}</p>
          </div>
          <div class="link-list">
            <a class="proof-link" href="${escapeHtml(githubBlob(item.modulePath, item.moduleLine))}" target="_blank" rel="noreferrer">Module</a>
            ${item.theoremLinks
              .map(
                (link) =>
                  `<a class="proof-link" href="${escapeHtml(githubBlob(item.modulePath, link.line))}" target="_blank" rel="noreferrer">${escapeHtml(link.label)}</a>`
              )
              .join("")}
          </div>
          <details class="viewer">
            <summary>View Lean excerpt</summary>
            <pre><code>${escapeHtml(item.leanSnippet)}</code></pre>
          </details>
        </article>
      `
    )
    .join("");
}

function renderSummary(siteData) {
  const summary = document.querySelector("#summary");
  summary.innerHTML = siteData.meta.summaryChips
    .map((chip) => `<span class="summary-chip">${escapeHtml(chip)}</span>`)
    .join("");
}

function renderWhyItMatters(items) {
  const container = document.querySelector("#why-it-matters");
  container.innerHTML = items
    .map(
      (item) => `
        <article class="why-card">
          <h3>${escapeHtml(item.title)}</h3>
          <p>${escapeHtml(item.description)}</p>
        </article>
      `
    )
    .join("");
}

function renderTakeaways(items) {
  const container = document.querySelector("#takeaways");
  container.innerHTML = `
    <table class="takeaway-table">
      <thead>
        <tr>
          <th>Finding</th>
          <th>What changed</th>
          <th>Why it matters</th>
        </tr>
      </thead>
      <tbody>
        ${items
          .map(
            (item) => `
              <tr>
                <td>${escapeHtml(item.title)}</td>
                <td>${escapeHtml(item.change)}</td>
                <td>${escapeHtml(item.whyItMatters)}</td>
              </tr>
            `
          )
          .join("")}
      </tbody>
    </table>
  `;
}

function renderLegend(items) {
  const container = document.querySelector("#legend");
  container.innerHTML = items
    .map(
      (item) => `
        <article class="legend-card">
          <h3>${escapeHtml(item.label)}</h3>
          <p>${escapeHtml(item.description)}</p>
        </article>
      `
    )
    .join("");
}

function renderCaseFiles(caseFiles) {
  const container = document.querySelector("#case-files");
  container.innerHTML = caseFiles
    .map(
      (item) => `
        <article class="case-card">
          <div class="card-top">
            <div>
              <p class="section-kicker">${escapeHtml(item.module)}</p>
              <h3>${escapeHtml(item.title)}</h3>
            </div>
            <span class="badge ${verdictClass[item.verdict] || ""}">
              ${escapeHtml(item.verdict)}
            </span>
          </div>

          <div class="card-meta">
            <span class="tag">${escapeHtml(item.currentTier)}</span>
            <span class="tag">${escapeHtml(item.signal)}</span>
            <span class="tag">${escapeHtml(item.status)}</span>
            <span class="status-badge ${statusClass[item.badgeStyle] || ""}">
              ${escapeHtml(item.badge)}
            </span>
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
            <div class="provenance-row"><strong>Reading:</strong> ${escapeHtml(item.readingMode)}</div>
          </div>

          <div class="card-block">
            <h4>HPMOR claim</h4>
            <p>${escapeHtml(item.hpmorClaim)}</p>
          </div>

          <div class="card-block">
            <h4>What survived</h4>
            <p>${escapeHtml(item.whatSurvived)}</p>
          </div>

          <div class="card-block">
            <h4>What reality objected to</h4>
            <p>${escapeHtml(item.whatRealityObjectedTo)}</p>
          </div>

          <div class="card-block">
            <h4>Best next pressure points</h4>
            <ul class="bullet-list">
              ${item.nextPressurePoints.map((point) => `<li>${escapeHtml(point)}</li>`).join("")}
            </ul>
          </div>
        </article>
      `
    )
    .join("");
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

function renderAttacks(attacks) {
  const container = document.querySelector("#attacks");
  container.innerHTML = `
    <table class="attack-table">
      <thead>
        <tr>
          <th>Attack</th>
          <th>Expected value</th>
          <th>Difficulty</th>
          <th>Hidden-assumption potential</th>
          <th>Why it matters</th>
        </tr>
      </thead>
      <tbody>
        ${attacks
          .map(
            (attack) => `
              <tr>
                <td>${escapeHtml(attack.title)}</td>
                <td>${escapeHtml(attack.expectedValue)}</td>
                <td>${escapeHtml(attack.difficulty)}</td>
                <td>${escapeHtml(attack.hiddenAssumptionPotential)}</td>
                <td>${escapeHtml(attack.description)}</td>
              </tr>
            `
          )
          .join("")}
      </tbody>
    </table>
  `;
}

function renderTools(tools) {
  const container = document.querySelector("#tools");
  container.innerHTML = tools
    .map(
      (tool) => `
        <article class="tool-card">
          <span class="tool-status">${escapeHtml(tool.result)}</span>
          <h3>${escapeHtml(tool.name)}</h3>
          <p>${escapeHtml(tool.notes)}</p>
        </article>
      `
    )
    .join("");
}

function githubBlob(path, line = 1) {
  return `${repoBaseUrl}${path}#L${line}`;
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

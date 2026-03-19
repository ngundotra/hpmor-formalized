const response = await fetch("./data/findings.json");
const data = await response.json();

const verdictClass = {
  Solid: "badge-solid",
  Qualified: "badge-qualified",
  Illustrative: "badge-illustrative",
};

document.querySelector("#source-note").textContent =
  `Source of truth: ${data.meta.sourceOfTruth}`;
document.querySelector("#sync-note").textContent = data.meta.syncPolicy;

renderDashboard(data);
renderSummary(data);
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
      label: "Case Files",
      value: String(total),
      blurb: "Distinct formalization fronts currently tracked from the findings record.",
    },
    {
      label: "Hidden Assumptions",
      value: String(hiddenAssumptions),
      blurb: "Places where formalization forced an unspoken premise into view.",
    },
    {
      label: "Solid vs Qualified",
      value: `${byVerdict.Solid || 0}/${byVerdict.Qualified || 0}`,
      blurb: "Solid cores versus claims that survive only with important caveats.",
    },
    {
      label: "Tier Spread",
      value: Object.keys(byTier)
        .sort()
        .map((tier) => tier.replace("Tier ", "T"))
        .join(" · "),
      blurb: "Current acceptance-tier footprint across the tracked case files.",
    },
  ];

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

function renderSummary(siteData) {
  const summary = document.querySelector("#summary");
  summary.innerHTML = siteData.meta.summaryChips
    .map((chip) => `<span class="summary-chip">${escapeHtml(chip)}</span>`)
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
  container.innerHTML = attacks
    .map(
      (attack) => `
        <article class="attack-card">
          <span class="priority">${escapeHtml(attack.priority)}</span>
          <h3>${escapeHtml(attack.title)}</h3>
          <p>${escapeHtml(attack.description)}</p>
        </article>
      `
    )
    .join("");
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

import fs from "fs";
import path from "path";
import slugify from "slugify";
import yaml from "js-yaml";

const issueTitle = process.env.ISSUE_TITLE || "Runbook note";
const issueBody = process.env.ISSUE_BODY || "";
const issueNumber = process.env.ISSUE_NUMBER || "0";

// Optional envs from GitHub Action
const issueCategoryEnv = process.env.ISSUE_CATEGORY || process.env.CATEGORY || "";
const issueLabels = process.env.ISSUE_LABELS || "";

const allowedCategories = [
  "ubuntu",
  "docker",
  "nginx",
  "cloudflare",
  "sqlserver",
  "git",
  "errors",
  "tools",
];

const categoryTitles = {
  ubuntu: "Ubuntu",
  docker: "Docker",
  nginx: "Nginx",
  cloudflare: "Cloudflare",
  sqlserver: "SQL Server",
  git: "Git",
  errors: "Errors",
  tools: "Tools",
};

const categoryAliases = {
  "sql server": "sqlserver",
  "sql-server": "sqlserver",
  "mssql": "sqlserver",
  "ms sql": "sqlserver",
  "cloud flare": "cloudflare",
  "cloud-flare": "cloudflare",
};

function extractSection(body, sectionName) {
  const escapedSectionName = sectionName.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

  const patterns = [
    new RegExp(`^#{2,6}\\s+${escapedSectionName}\\s*\\n+([\\s\\S]*?)(\\n#{2,6}\\s+|$)`, "im"),
    new RegExp(`\\*\\*${escapedSectionName}\\*\\*\\s*\\n+([\\s\\S]*?)(\\n\\*\\*|\\n#{2,6}\\s+|$)`, "i"),
    new RegExp(`^${escapedSectionName}\\s*:\\s*(.+)$`, "im"),
  ];

  for (const regex of patterns) {
    const match = body.match(regex);

    if (match && match[1]) {
      return match[1].trim();
    }
  }

  return "";
}

function normalizeCategory(value) {
  const raw = (value || "")
    .trim()
    .toLowerCase()
    .replace(/[`"'[\]()]/g, "")
    .replace(/^[-*+]\s*/, "")
    .replace(/^category\s*:\s*/, "")
    .trim();

  const firstLine = raw
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter(Boolean)[0] || "";

  const cleaned = categoryAliases[firstLine] || firstLine;

  if (allowedCategories.includes(cleaned)) {
    return cleaned;
  }

  for (const category of allowedCategories) {
    const regex = new RegExp(`(^|[^a-z0-9])${category}([^a-z0-9]|$)`, "i");

    if (regex.test(raw)) {
      return category;
    }
  }

  for (const [alias, category] of Object.entries(categoryAliases)) {
    if (raw.includes(alias)) {
      return category;
    }
  }

  return "";
}

function resolveCategory() {
  const categoryFromEnv = normalizeCategory(issueCategoryEnv);

  if (categoryFromEnv) {
    return categoryFromEnv;
  }

  const categoryFromIssue = normalizeCategory(extractSection(issueBody, "Category"));

  if (categoryFromIssue) {
    return categoryFromIssue;
  }

  const categoryFromLabels = normalizeCategory(issueLabels);

  if (categoryFromLabels) {
    return categoryFromLabels;
  }

  console.log("Category not found. Fallback to errors.");

  return "errors";
}

function cleanIssueTitle(value) {
  return (value || "")
    .replace(/^\[Runbook\]\s*/i, "")
    .trim();
}

function toDisplayTitle(value) {
  return (value || "")
    .replace(/-/g, " ")
    .replace(/\b\w/g, (char) => char.toUpperCase())
    .trim();
}

function getMarkdownTitle(markdown, fallbackTitle) {
  const match = markdown.match(/^#\s+(.+)$/m);

  if (match && match[1]) {
    return match[1].trim();
  }

  return fallbackTitle;
}

function ensureDirectory(directoryPath) {
  if (!fs.existsSync(directoryPath)) {
    fs.mkdirSync(directoryPath, { recursive: true });
  }
}

function updateMkDocsNavigation({ category, targetFile, pageTitle }) {
  const mkdocsFile = "mkdocs.yml";

  if (!fs.existsSync(mkdocsFile)) {
    console.log("mkdocs.yml not found. Skip navigation update.");
    return;
  }

  const relativeDocPath = path.relative("docs", targetFile).replaceAll("\\", "/");
  const categoryTitle = categoryTitles[category] || "Errors";

  const mkdocsContent = fs.readFileSync(mkdocsFile, "utf8");
  const mkdocsConfig = yaml.load(mkdocsContent) || {};

  if (!Array.isArray(mkdocsConfig.nav)) {
    mkdocsConfig.nav = [];
  }

  let navSection = mkdocsConfig.nav.find((item) => {
    return (
      item &&
      typeof item === "object" &&
      Object.prototype.hasOwnProperty.call(item, categoryTitle)
    );
  });

  if (!navSection) {
    navSection = {
      [categoryTitle]: [],
    };

    mkdocsConfig.nav.push(navSection);
  }

  if (!Array.isArray(navSection[categoryTitle])) {
    navSection[categoryTitle] = [];
  }

  const alreadyExists = navSection[categoryTitle].some((item) => {
    if (typeof item === "string") {
      return item === relativeDocPath;
    }

    if (item && typeof item === "object") {
      return Object.values(item).includes(relativeDocPath);
    }

    return false;
  });

  if (alreadyExists) {
    console.log(`${relativeDocPath} already exists in mkdocs.yml`);
    return;
  }

  navSection[categoryTitle].push({
    [pageTitle]: relativeDocPath,
  });

  fs.writeFileSync(
    mkdocsFile,
    yaml.dump(mkdocsConfig, {
      lineWidth: -1,
      noRefs: true,
      sortKeys: false,
    }),
    "utf8"
  );

  console.log(`Updated mkdocs.yml with ${relativeDocPath}`);
}

const topicTitleFromIssue = extractSection(issueBody, "Topic title");

const category = resolveCategory();
const cleanedIssueTitle = cleanIssueTitle(issueTitle);
const rawTitle = topicTitleFromIssue || cleanedIssueTitle || `Runbook issue ${issueNumber}`;

const fileName = slugify(rawTitle, {
  lower: true,
  strict: true,
});

const targetDir = path.join("docs", category);
ensureDirectory(targetDir);

const targetFile = path.join(targetDir, `${fileName || `issue-${issueNumber}`}.md`);

// Use issue body directly. No AI processing.
const markdown = issueBody.trim();

if (!markdown) {
  throw new Error("ISSUE_BODY is empty. Cannot create markdown file.");
}

fs.writeFileSync(targetFile, `${markdown}\n`, "utf8");

console.log(`Created ${targetFile}`);

const pageTitle = getMarkdownTitle(markdown, toDisplayTitle(fileName));

updateMkDocsNavigation({
  category,
  targetFile,
  pageTitle,
});
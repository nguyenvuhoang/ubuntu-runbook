import fs from "fs";
import path from "path";
import OpenAI from "openai";
import slugify from "slugify";
import yaml from "js-yaml";

const client = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

const issueTitle = process.env.ISSUE_TITLE || "Runbook note";
const issueBody = process.env.ISSUE_BODY || "";
const issueNumber = process.env.ISSUE_NUMBER || "0";
const model = process.env.OPENAI_MODEL || "gpt-5.4-mini";

const allowedCategories = [
  "ubuntu",
  "docker",
  "nginx",
  "cloudflare",
  "sqlserver",
  "git",
  "errors",
];

const categoryTitles = {
  ubuntu: "Ubuntu",
  docker: "Docker",
  nginx: "Nginx",
  cloudflare: "Cloudflare",
  sqlserver: "SQL Server",
  git: "Git",
  errors: "Errors",
};

function extractSection(body, sectionName) {
  const regex = new RegExp(`###\\s+${sectionName}\\s+([\\s\\S]*?)(\\n###|$)`, "i");
  const match = body.match(regex);

  if (!match) {
    return "";
  }

  return match[1].trim();
}

function normalizeCategory(value) {
  const normalized = (value || "").trim().toLowerCase();

  if (allowedCategories.includes(normalized)) {
    return normalized;
  }

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

const categoryFromIssue = extractSection(issueBody, "Category");
const topicTitleFromIssue = extractSection(issueBody, "Topic title");

const category = normalizeCategory(categoryFromIssue);
const cleanedIssueTitle = cleanIssueTitle(issueTitle);
const rawTitle = topicTitleFromIssue || cleanedIssueTitle || `Runbook issue ${issueNumber}`;

const fileName = slugify(rawTitle, {
  lower: true,
  strict: true,
});

const targetDir = path.join("docs", category);
ensureDirectory(targetDir);

const targetFile = path.join(targetDir, `${fileName || `issue-${issueNumber}`}.md`);

const prompt = `
You are maintaining a MkDocs DevOps runbook.

Convert the following GitHub issue into a clean Markdown runbook note.

Rules:
- Output Markdown only.
- Use English command comments.
- Keep commands safe and practical.
- Do not invent credentials, private IPs, passwords, tokens, or secrets.
- If information is missing, add a "Notes" section with assumptions.
- Keep the content concise but useful.
- Use this exact structure:

# ${rawTitle}

## Situation

## Error

## Root cause

## Fix commands

## Verification commands

## Notes

## Tags

Issue title:
${issueTitle}

Issue body:
${issueBody}
`;

const response = await client.responses.create({
  model,
  input: prompt,
});

const markdown = response.output_text || "";

if (!markdown.trim()) {
  throw new Error("OpenAI returned empty markdown content.");
}

fs.writeFileSync(targetFile, markdown, "utf8");

console.log(`Created ${targetFile}`);

const pageTitle = getMarkdownTitle(markdown, toDisplayTitle(fileName));

updateMkDocsNavigation({
  category,
  targetFile,
  pageTitle,
});
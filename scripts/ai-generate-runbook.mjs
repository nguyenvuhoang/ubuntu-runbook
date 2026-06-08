import fs from "fs";
import path from "path";
import OpenAI from "openai";
import slugify from "slugify";

const client = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

const issueTitle = process.env.ISSUE_TITLE || "Runbook note";
const issueBody = process.env.ISSUE_BODY || "";
const issueNumber = process.env.ISSUE_NUMBER || "0";

const prompt = `
You are maintaining a MkDocs DevOps runbook.

Convert the following GitHub issue into a clean Markdown runbook note.

Rules:
- Output Markdown only.
- Use English command comments.
- Keep commands safe and practical.
- Do not invent credentials, private IPs, passwords, tokens, or secrets.
- If information is missing, add a "Notes" section with assumptions.
- Use this structure:

# Title

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
  model: "gpt-5.4-mini",
  input: prompt,
});

const markdown = response.output_text || "";

const categoryMatch = issueBody.match(/### Category\s+([\s\S]*?)(\n###|$)/i);
let category = categoryMatch ? categoryMatch[1].trim().toLowerCase() : "errors";

const allowedCategories = [
  "ubuntu",
  "docker",
  "nginx",
  "cloudflare",
  "sqlserver",
  "git",
  "errors",
];

if (!allowedCategories.includes(category)) {
  category = "errors";
}

const fileName = slugify(issueTitle.replace("[Runbook]", ""), {
  lower: true,
  strict: true,
});

const targetDir = path.join("docs", category);
fs.mkdirSync(targetDir, { recursive: true });

const targetFile = path.join(targetDir, `${fileName || `issue-${issueNumber}`}.md`);

fs.writeFileSync(targetFile, markdown, "utf8");

console.log(`Created ${targetFile}`);
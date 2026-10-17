const vscode = require("vscode");
const snippets = require("./snippet.json");
const snippet = snippets["LaTeX boilerplate"];

function activate(context) {
  const provider = vscode.languages.registerCompletionItemProvider(
    { language: "latex", scheme: "file" },
    {
      provideCompletionItems(document, position) {
        const linePrefix = document
          .lineAt(position)
          .text.slice(0, position.character);
        if (!/^\s*!$/.test(linePrefix)) {
          return undefined;
        }

        const item = new vscode.CompletionItem(
          "LaTeX boilerplate",
          vscode.CompletionItemKind.Snippet,
        );
        item.insertText = new vscode.SnippetString(snippet.body.join("\n"));
        item.detail = snippet.description;
        item.documentation = new vscode.MarkdownString(
          "Chèn khung LaTeX chuẩn Word Việt Nam (XeLaTeX).",
        );
        item.filterText = "!";
        item.sortText = "0";
        item.range = new vscode.Range(position.translate(0, -1), position);
        return [item];
      },
    },
    "!",
  );

  context.subscriptions.push(provider);
}

function deactivate() {}

module.exports = { activate, deactivate };
